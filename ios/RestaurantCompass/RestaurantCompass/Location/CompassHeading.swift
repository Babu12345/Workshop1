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
  @Published var denied = false

  private let manager = CLLocationManager()

  // Low-pass smoothing state (averaged as a unit vector so it wraps cleanly
  // across north instead of jumping 359° → 1°).
  private var smoothedSin = 0.0
  private var smoothedCos = 1.0
  private var seeded = false

  override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.headingFilter = 1   // ignore sub-degree noise
  }

  func start() {
    manager.requestWhenInUseAuthorization()
    manager.startUpdatingLocation()
    if CLLocationManager.headingAvailable() {
      manager.startUpdatingHeading()
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    coordinate = locations.last?.coordinate
  }

  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    let raw = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
    heading = smooth(raw)
    hasHeading = true
  }

  // Exponential moving average of the heading as a unit vector.
  private func smooth(_ degrees: Double) -> Double {
    let radians = degrees * .pi / 180
    let alpha = 0.2
    if seeded {
      smoothedSin = smoothedSin * (1 - alpha) + sin(radians) * alpha
      smoothedCos = smoothedCos * (1 - alpha) + cos(radians) * alpha
    } else {
      smoothedSin = sin(radians)
      smoothedCos = cos(radians)
      seeded = true
    }
    let result = atan2(smoothedSin, smoothedCos) * 180 / .pi
    return result < 0 ? result + 360 : result
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    authorized = status == .authorizedWhenInUse || status == .authorizedAlways
    denied = status == .denied || status == .restricted
  }
}
