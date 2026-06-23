import Amplify
import Foundation

// Mirrors the `Restaurant` model in web/amplify/data/resource.ts so this app
// reads and writes the exact same DynamoDB table as the website.
public nonisolated struct Restaurant: Model {
  public let id: String
  public var name: String
  public var cuisine: String?
  public var address: String?
  public var lat: Double
  public var lng: Double
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?

  public init(
    id: String = UUID().uuidString,
    name: String,
    cuisine: String? = nil,
    address: String? = nil,
    lat: Double,
    lng: Double
  ) {
    self.init(
      id: id, name: name, cuisine: cuisine, address: address,
      lat: lat, lng: lng, createdAt: nil, updatedAt: nil
    )
  }

  init(
    id: String = UUID().uuidString,
    name: String,
    cuisine: String? = nil,
    address: String? = nil,
    lat: Double,
    lng: Double,
    createdAt: Temporal.DateTime? = nil,
    updatedAt: Temporal.DateTime? = nil
  ) {
    self.id = id
    self.name = name
    self.cuisine = cuisine
    self.address = address
    self.lat = lat
    self.lng = lng
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}
