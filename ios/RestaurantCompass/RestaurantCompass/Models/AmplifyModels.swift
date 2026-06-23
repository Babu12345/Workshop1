import Amplify
import Foundation

// Registers our models with Amplify. Passed to AWSAPIPlugin so the typed
// GraphQLRequest.list/.create helpers know about Restaurant.
public nonisolated final class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "restaurant-compass-1"

  public init() {}

  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Restaurant.self)
  }
}
