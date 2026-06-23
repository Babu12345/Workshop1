import SwiftUI
import CoreLocation
import UIKit

// The compass card. Heading-up model: "up" is the way you're facing, so the
// needle points at the restaurant relative to you (turn until it points up,
// then walk forward). The cardinal ring rotates so N still shows true north.
struct CompassView: View {
  let target: Restaurant?
  let userLocation: CLLocationCoordinate2D?
  let heading: CLLocationDirection
  let hasHeading: Bool
  let authorized: Bool
  let denied: Bool

  private var bearing: Double? {
    guard let target, let userLocation else { return nil }
    return Geo.bearing(from: userLocation, to: target.coordinate)
  }

  private var distance: Double? {
    guard let target, let userLocation else { return nil }
    return Geo.distanceMiles(from: userLocation, to: target.coordinate)
  }

  // Target direction relative to where you're facing, normalized to -180…180.
  private var relative: Double? {
    guard let bearing else { return nil }
    var angle = (bearing - heading).truncatingRemainder(dividingBy: 360)
    if angle > 180 { angle -= 360 }
    if angle < -180 { angle += 360 }
    return angle
  }

  var body: some View {
    VStack(spacing: 16) { content }
      .padding(20)
      .frame(maxWidth: .infinity)
      .background(Color.white, in: RoundedRectangle(cornerRadius: 20))
      .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.inkFaint.opacity(0.25)))
  }

  @ViewBuilder private var content: some View {
    if denied {
      message(
        icon: "location.slash",
        title: "Location is off",
        subtitle: "Turn on location for this app in Settings to aim the compass.",
        showSettings: true
      )
    } else if userLocation == nil {
      VStack(spacing: 12) {
        ProgressView()
        Text("Finding your location…").font(.subheadline).foregroundStyle(Color.inkSoft)
      }
      .frame(height: 260)
    } else if target == nil {
      message(
        icon: "mappin.and.ellipse",
        title: "Pick a restaurant",
        subtitle: "Choose one below to point the compass at it.",
        showSettings: false
      )
    } else {
      dial
    }
  }

  private var dial: some View {
    VStack(spacing: 16) {
      Text("Pointing to")
        .font(.caption.weight(.semibold)).foregroundStyle(Color.accent)
        .textCase(.uppercase).kerning(0.5)
      Text(target?.name ?? "—")
        .font(.title3.weight(.semibold)).foregroundStyle(Color.ink)
        .multilineTextAlignment(.center)

      ZStack {
        Circle().fill(Color.paper)
        Circle()
          .stroke(Color.inkFaint.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
          .padding(16)

        // True compass directions. The ring turns so N always points at real
        // north (no animation here, so it follows the smoothed heading without
        // ever spinning the long way around).
        ZStack {
          ForEach(Array(["N", "E", "S", "W"].enumerated()), id: \.offset) { index, label in
            Text(label)
              .font(.caption2.weight(.semibold))
              .foregroundStyle(label == "N" ? Color.accent : Color.inkFaint)
              .offset(y: -66)
              .rotationEffect(.degrees(Double(index) * 90))
          }
        }
        .rotationEffect(.degrees(-heading))

        // A fixed marker at the top = the way you're facing. Line up the needle
        // with it and the restaurant is straight ahead.
        VStack(spacing: 3) {
          Image(systemName: "triangle.fill")
            .font(.system(size: 9)).foregroundStyle(Color.inkFaint)
          Text("AHEAD")
            .font(.system(size: 9, weight: .semibold)).foregroundStyle(Color.inkFaint)
            .kerning(0.5)
        }
        .offset(y: -90)

        // The only thing that moves: the needle, pointing at the restaurant
        // relative to the way you're facing.
        Image(systemName: "location.north.fill")
          .font(.system(size: 64)).foregroundStyle(Color.accent)
          .rotationEffect(.degrees(relative ?? 0))
          .animation(.easeOut(duration: 0.25), value: relative)
      }
      .frame(width: 220, height: 220)

      Text(guidance)
        .font(.subheadline.weight(.medium))
        .foregroundStyle(hasHeading ? Color.ink : Color.inkSoft)
        .multilineTextAlignment(.center)

      HStack(spacing: 12) {
        stat(value: String(format: "%.1f mi", distance ?? 0), label: "Distance")
        stat(value: bearing.map { "\(Int($0.rounded()))°" } ?? "—", label: "Bearing")
      }
    }
  }

  // The turn instruction (or a note when there's no live compass).
  private var guidance: String {
    if !hasHeading { return "Point your phone — the live compass needs a real device" }
    guard let rel = relative else { return "" }
    if abs(rel) <= 8 { return "Straight ahead" }
    let degrees = Int(abs(rel).rounded())
    return rel > 0 ? "Turn right \(degrees)°" : "Turn left \(degrees)°"
  }

  private func stat(value: String, label: String) -> some View {
    VStack(spacing: 2) {
      Text(value).font(.headline).foregroundStyle(Color.ink)
      Text(label).font(.caption).foregroundStyle(Color.inkSoft)
    }
    .frame(maxWidth: .infinity).padding(.vertical, 8)
    .background(Color.paper, in: RoundedRectangle(cornerRadius: 12))
  }

  private func message(icon: String, title: String, subtitle: String, showSettings: Bool) -> some View {
    VStack(spacing: 10) {
      Image(systemName: icon).font(.system(size: 40)).foregroundStyle(Color.inkFaint)
      Text(title).font(.headline).foregroundStyle(Color.ink)
      Text(subtitle).font(.subheadline).foregroundStyle(Color.inkSoft).multilineTextAlignment(.center)
      if showSettings {
        Button("Open Settings") {
          if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
          }
        }
        .font(.subheadline.weight(.semibold)).foregroundStyle(Color.accent)
      }
    }
    .frame(height: 260)
    .padding(.horizontal, 12)
  }
}
