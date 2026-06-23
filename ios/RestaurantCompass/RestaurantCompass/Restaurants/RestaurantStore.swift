import Foundation
import Combine
import Amplify
import AWSPluginsCore
import CoreLocation

// Reads/writes Restaurants against the shared AppSync/DynamoDB backend using
// the typed Amplify Data API. Same shared list and seeding as the website.
@MainActor
final class RestaurantStore: ObservableObject {
  @Published var restaurants: [Restaurant] = []
  @Published var isLoading = true
  @Published var errorMessage = ""

  func load() async {
    isLoading = true
    errorMessage = ""
    await fetch()
    if restaurants.isEmpty && errorMessage.isEmpty {
      await seedIfEmpty()
      await fetch()
    }
    isLoading = false
  }

  private func fetch() async {
    do {
      let result = try await Amplify.API.query(request: .list(Restaurant.self, limit: 1000))
      switch result {
      case .success(let list):
        var all: [Restaurant] = []
        var page: List<Restaurant>? = list
        while let current = page {
          all.append(contentsOf: current)
          page = current.hasNextPage() ? try await current.getNextPage() : nil
        }
        restaurants = all.sorted { $0.name < $1.name }
      case .failure(let error):
        errorMessage = error.localizedDescription
      }
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func add(name: String, cuisine: String, address: String) async {
    // Beginners don't know GPS coordinates, so new spots land at a random
    // point around Manhattan — enough to make the compass move.
    let jitter = { Double.random(in: -0.04...0.04) }
    let restaurant = Restaurant(
      name: name,
      cuisine: cuisine.isEmpty ? "Restaurant" : cuisine,
      address: address.isEmpty ? "New York, NY" : address,
      lat: Geo.fallback.latitude + jitter(),
      lng: Geo.fallback.longitude + jitter()
    )
    do {
      let result = try await Amplify.API.mutate(request: .create(restaurant))
      switch result {
      case .success(let created):
        restaurants.append(created)
        restaurants.sort { $0.name < $1.name }
      case .failure(let error):
        errorMessage = error.localizedDescription
      }
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  // The first signed-in user seeds the shared list; everyone else just reads it.
  private func seedIfEmpty() async {
    for seed in Self.seeds {
      _ = try? await Amplify.API.mutate(request: .create(seed))
    }
  }

  static let seeds: [Restaurant] = [
    Restaurant(name: "Katz's Delicatessen", cuisine: "Deli", address: "205 E Houston St", lat: 40.7223, lng: -73.9874),
    Restaurant(name: "Lombardi's Pizza", cuisine: "Pizza", address: "32 Spring St", lat: 40.7216, lng: -73.9956),
    Restaurant(name: "Balthazar", cuisine: "French", address: "80 Spring St", lat: 40.7225, lng: -73.9981),
    Restaurant(name: "Joe's Shanghai", cuisine: "Chinese", address: "46 Bowery", lat: 40.7148, lng: -73.9967),
    Restaurant(name: "Shake Shack (Madison Sq)", cuisine: "Burgers", address: "Madison Square Park", lat: 40.7414, lng: -73.9882),
    Restaurant(name: "Levain Bakery", cuisine: "Bakery", address: "167 W 74th St", lat: 40.7794, lng: -73.9803),
  ]
}

extension Restaurant {
  var coordinate: CLLocationCoordinate2D { .init(latitude: lat, longitude: lng) }
}
