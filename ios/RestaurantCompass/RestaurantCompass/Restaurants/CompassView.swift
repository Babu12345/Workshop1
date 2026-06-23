import SwiftUI
import CoreLocation

// The compass dial + needle. The needle points along (bearing − deviceHeading),
// so it keeps aiming at the restaurant as you physically turn the phone.
struct CompassView: View {
  let target: Restaurant?
  let origin: CLLocationCoordinate2D
  let heading: CLLocationDirection

  private var bearing: Double {
    guard let target else { return 0 }
    return Geo.bearing(from: origin, to: target.coordinate)
  }

  private var needleAngle: Double { bearing - heading }

  private var distance: Double {
    guard let target else { return 0 }
    return Geo.distanceMiles(from: origin, to: target.coordinate)
  }

  var body: some View {
    VStack(spacing: 16) {
      Text(target == nil ? "Pick a restaurant" : "Pointing to")
        .font(.caption.weight(.semibold))
        .foregroundStyle(Color.accent)
        .textCase(.uppercase)
        .kerning(0.5)

      Text(target?.name ?? "—")
        .font(.title3.weight(.semibold))
        .foregroundStyle(Color.ink)
        .multilineTextAlignment(.center)

      ZStack {
        Circle().fill(Color.paper)
        Circle().stroke(Color.inkFaint.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
          .padding(16)
        ForEach(Array(["N", "E", "S", "W"].enumerated()), id: \.offset) { index, label in
          Text(label)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(Color.inkFaint)
            .offset(y: -96)
            .rotationEffect(.degrees(Double(index) * 90))
        }
        Image(systemName: "location.north.fill")
          .font(.system(size: 64))
          .foregroundStyle(Color.accent)
          .rotationEffect(.degrees(needleAngle))
          .animation(.easeOut(duration: 0.4), value: needleAngle)
          .opacity(target == nil ? 0.2 : 1)
      }
      .frame(width: 220, height: 220)

      if target != nil {
        HStack(spacing: 12) {
          stat(value: "\(Int(bearing.rounded()))°", label: "Heading")
          stat(value: String(format: "%.1f mi", distance), label: "Distance")
        }
      }
    }
    .padding(20)
    .frame(maxWidth: .infinity)
    .background(Color.white, in: RoundedRectangle(cornerRadius: 20))
    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.inkFaint.opacity(0.25)))
  }

  private func stat(value: String, label: String) -> some View {
    VStack(spacing: 2) {
      Text(value).font(.headline).foregroundStyle(Color.ink)
      Text(label).font(.caption).foregroundStyle(Color.inkSoft)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 8)
    .background(Color.paper, in: RoundedRectangle(cornerRadius: 12))
  }
}
