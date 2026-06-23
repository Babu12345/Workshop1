import Foundation
import Combine
import MapKit

// Maps-style live address autocomplete via MapKit. Suggestions are biased to
// NYC; resolving a tapped suggestion returns its exact coordinates.
final class AddressSearch: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
  @Published var query: String = "" {
    didSet { completer.queryFragment = query }
  }
  @Published var suggestions: [MKLocalSearchCompletion] = []

  private let completer = MKLocalSearchCompleter()

  override init() {
    super.init()
    completer.delegate = self
    completer.resultTypes = [.address, .pointOfInterest]
    // Nudge results toward NYC so partial entries resolve sensibly.
    completer.region = MKCoordinateRegion(
      center: Geo.fallback,
      latitudinalMeters: 25_000,
      longitudinalMeters: 25_000
    )
  }

  // Turn a tapped suggestion into a precise coordinate + a display string.
  func resolve(_ completion: MKLocalSearchCompletion) async -> (CLLocationCoordinate2D, String)? {
    let request = MKLocalSearch.Request(completion: completion)
    guard let response = try? await MKLocalSearch(request: request).start(),
          let item = response.mapItems.first else { return nil }
    let label = [completion.title, completion.subtitle]
      .filter { !$0.isEmpty }
      .joined(separator: ", ")
    return (item.placemark.coordinate, label)
  }

  // MARK: - MKLocalSearchCompleterDelegate

  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    suggestions = completer.results
  }

  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    suggestions = []
  }
}
