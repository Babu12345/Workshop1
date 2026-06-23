import Foundation
import Combine
import CoreLocation

// Wraps CLLocationManager to publish the phone's current location and the
// direction it's physically pointing, so the compass needle can track a
// restaurant as you turn around.
final class CompassHeading: NSObject, ObservableObject, CLLocationManagerDelegate {
  @Published var coordinate: CLLocationCoordinate2D?
  @Published var heading: CLLocationDirection = 0   // degrees from north
  @Published var hasHeading = false
  @Published var authorized = false

  private let manager = CLLocationManager()

  override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
  }

  func start() {
    manager.requestWhenInUseAuthorization()
    manager.startUpdatingLocation()
    if CLLocationManager.headingAvailable() {
      manager.startUpdatingHeading()
    }
  }

  // Where the compass points from: live location, or Times Square as a fallback.
  var origin: CLLocationCoordinate2D { coordinate ?? Geo.fallback }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    coordinate = locations.last?.coordinate
  }

  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    heading = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
    hasHeading = true
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    authorized = status == .authorizedWhenInUse || status == .authorizedAlways
  }
}
