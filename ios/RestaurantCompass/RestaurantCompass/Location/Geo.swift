import CoreLocation

// Plain geometry for the compass — no backend or device dependency.
enum Geo {
  // Fallback "you are here" when location isn't available yet (e.g. simulator
  // with no simulated location): the middle of Times Square.
  static let fallback = CLLocationCoordinate2D(latitude: 40.758, longitude: -73.9855)

  // Compass bearing in degrees (0 = north, 90 = east) from one point to another.
  static func bearing(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
    let lat1 = from.latitude * .pi / 180
    let lat2 = to.latitude * .pi / 180
    let dLng = (to.longitude - from.longitude) * .pi / 180
    let y = sin(dLng) * cos(lat2)
    let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng)
    let deg = atan2(y, x) * 180 / .pi
    return (deg + 360).truncatingRemainder(dividingBy: 360)
  }

  // Straight-line distance in miles.
  static func distanceMiles(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
    let a = CLLocation(latitude: from.latitude, longitude: from.longitude)
    let b = CLLocation(latitude: to.latitude, longitude: to.longitude)
    return a.distance(from: b) / 1609.344
  }
}
