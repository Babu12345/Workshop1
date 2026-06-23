import SwiftUI

// The same ink / paper / accent palette as the website, so the app feels like
// the same product.
extension Color {
  static let paper = Color(red: 0.980, green: 0.980, blue: 0.969)    // #fafaf7
  static let ink = Color(red: 0.110, green: 0.110, blue: 0.094)      // #1c1c18
  static let inkSoft = Color(red: 0.322, green: 0.322, blue: 0.282)  // #525248
  static let inkFaint = Color(red: 0.658, green: 0.658, blue: 0.627) // #a8a8a0
  static let accent = Color(red: 0.917, green: 0.345, blue: 0.047)   // #ea580c
  static let accentSoft = Color(red: 1.0, green: 0.929, blue: 0.835) // #ffedd5
}

// A pill button that matches the website's primary button.
struct PrimaryButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.headline)
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 14)
      .background(Color.ink, in: Capsule())
      .opacity(configuration.isPressed ? 0.85 : 1)
  }
}
