import Amplify
import Foundation

extension Restaurant {
  public enum CodingKeys: String, ModelKey {
    case id
    case name
    case cuisine
    case address
    case lat
    case lng
    case createdAt
    case updatedAt
  }

  public static let keys = CodingKeys.self

  public static let schema = defineSchema { model in
    let restaurant = Restaurant.keys

    // Same rules as the backend: owners manage their own rows; any signed-in
    // user can read the shared list.
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username",
           provider: .userPools, operations: [.create, .update, .delete, .read]),
      rule(allow: .private, provider: .userPools, operations: [.read])
    ]

    model.listPluralName = "Restaurants"
    model.syncPluralName = "Restaurants"

    model.attributes(.primaryKey(fields: [restaurant.id]))

    model.fields(
      .field(restaurant.id, is: .required, ofType: .string),
      .field(restaurant.name, is: .required, ofType: .string),
      .field(restaurant.cuisine, is: .optional, ofType: .string),
      .field(restaurant.address, is: .optional, ofType: .string),
      .field(restaurant.lat, is: .required, ofType: .double),
      .field(restaurant.lng, is: .required, ofType: .double),
      .field(restaurant.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(restaurant.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
  }

  public nonisolated class Path: ModelPath<Restaurant> {}
  public static var rootPath: PropertyContainerPath? { Path() }
}

extension Restaurant: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
