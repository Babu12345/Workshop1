import MapKit

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

  // Look up real coordinates for a typed address (nudged toward NYC so partial
  // addresses like "32 Spring St" resolve). Returns nil if it's empty or no
  // match is found.
  static func coordinate(forAddress address: String) async -> CLLocationCoordinate2D? {
    let trimmed = address.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return nil }

    let mentionsNY =
      trimmed.range(of: "new york", options: .caseInsensitive) != nil ||
      trimmed.range(of: ", ny", options: .caseInsensitive) != nil

    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = mentionsNY ? trimmed : "\(trimmed), New York, NY"
    request.region = MKCoordinateRegion(
      center: fallback,
      latitudinalMeters: 25_000,
      longitudinalMeters: 25_000
    )

    guard let response = try? await MKLocalSearch(request: request).start(),
          let item = response.mapItems.first else { return nil }
    return item.placemark.coordinate
  }

  // A random point around Manhattan — used when there's no usable address.
  static func randomManhattan() -> CLLocationCoordinate2D {
    CLLocationCoordinate2D(
      latitude: fallback.latitude + Double.random(in: -0.04...0.04),
      longitude: fallback.longitude + Double.random(in: -0.04...0.04)
    )
  }
}
