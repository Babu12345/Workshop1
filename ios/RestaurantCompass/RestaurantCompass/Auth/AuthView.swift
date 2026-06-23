import SwiftUI

// Sign in / sign up / confirm screens. One view, three modes — matches the
// website's /login, /signup and /confirm pages.
struct AuthView: View {
  @EnvironmentObject private var auth: AuthViewModel

  enum Mode { case signIn, signUp, confirm }

  @State private var mode: Mode = .signIn
  @State private var email = ""
  @State private var password = ""
  @State private var code = ""

  var body: some View {
    ZStack {
      Color.paper.ignoresSafeArea()

      ScrollView {
        VStack(spacing: 24) {
          VStack(spacing: 10) {
            ZStack {
              Circle().fill(Color.ink).frame(width: 56, height: 56)
              Image(systemName: "location.north.fill")
                .font(.title2).foregroundStyle(Color.accent)
                .rotationEffect(.degrees(-15))
            }
            Text("NYC Restaurant Compass")
              .font(.title3.weight(.semibold)).foregroundStyle(Color.ink)
          }
          .padding(.top, 48)

          VStack(alignment: .leading, spacing: 16) {
            Text(title).font(.title2.weight(.bold)).foregroundStyle(Color.ink)
            Text(subtitle).font(.subheadline).foregroundStyle(Color.inkSoft)

            VStack(spacing: 12) {
              if mode == .confirm {
                field("Email", text: $email, keyboard: .emailAddress)
                field("6-digit code", text: $code, keyboard: .numberPad)
              } else {
                field("Email", text: $email, keyboard: .emailAddress)
                secureField("Password", text: $password)
              }
            }

            if !auth.errorMessage.isEmpty {
              Text(auth.errorMessage)
                .font(.footnote).foregroundStyle(.red)
            }

            Button(action: submit) {
              Text(actionTitle)
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(auth.isWorking)
            .overlay { if auth.isWorking { ProgressView().tint(.white) } }

            if mode == .confirm {
              Button("Resend code") {
                Task { await auth.resendCode(email: email) }
              }
              .font(.subheadline.weight(.medium))
              .foregroundStyle(Color.accent)
            }
          }
          .padding(20)
          .background(Color.white, in: RoundedRectangle(cornerRadius: 20))
          .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.inkFaint.opacity(0.25)))

          footer
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: 480)
        .frame(maxWidth: .infinity)
      }
    }
  }

  // MARK: - Pieces

  private var title: String {
    switch mode {
    case .signIn: return "Welcome back"
    case .signUp: return "Create your account"
    case .confirm: return "Confirm your email"
    }
  }

  private var subtitle: String {
    switch mode {
    case .signIn: return "Log in to see your restaurants and the compass."
    case .signUp: return "We'll email you a 6-digit code to confirm it's you."
    case .confirm: return "Enter the 6-digit code we emailed you."
    }
  }

  private var actionTitle: String {
    switch mode {
    case .signIn: return "Log in"
    case .signUp: return "Sign up"
    case .confirm: return "Confirm & continue"
    }
  }

  @ViewBuilder private var footer: some View {
    switch mode {
    case .signIn:
      switchRow(text: "New here?", action: "Create an account") { mode = .signUp; auth.errorMessage = "" }
    case .signUp:
      switchRow(text: "Already have an account?", action: "Log in") { mode = .signIn; auth.errorMessage = "" }
    case .confirm:
      switchRow(text: "Back to", action: "Log in") { mode = .signIn; auth.errorMessage = "" }
    }
  }

  private func switchRow(text: String, action: String, perform: @escaping () -> Void) -> some View {
    HStack(spacing: 4) {
      Text(text).foregroundStyle(Color.inkSoft)
      Button(action, action: perform).foregroundStyle(Color.ink).fontWeight(.medium)
    }
    .font(.subheadline)
  }

  private func field(_ placeholder: String, text: Binding<String>, keyboard: UIKeyboardType) -> some View {
    TextField(placeholder, text: text)
      .keyboardType(keyboard)
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled()
      .padding(14)
      .background(Color.paper, in: RoundedRectangle(cornerRadius: 12))
      .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.inkFaint.opacity(0.3)))
  }

  private func secureField(_ placeholder: String, text: Binding<String>) -> some View {
    SecureField(placeholder, text: text)
      .padding(14)
      .background(Color.paper, in: RoundedRectangle(cornerRadius: 12))
      .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.inkFaint.opacity(0.3)))
  }

  private func submit() {
    Task {
      switch mode {
      case .signIn:
        await auth.signIn(email: email.trimmingCharacters(in: .whitespaces), password: password)
      case .signUp:
        let needsCode = await auth.signUp(email: email.trimmingCharacters(in: .whitespaces), password: password)
        if needsCode { mode = .confirm }
        else if auth.errorMessage.isEmpty { mode = .signIn }
      case .confirm:
        let done = await auth.confirm(email: email.trimmingCharacters(in: .whitespaces), code: code.trimmingCharacters(in: .whitespaces))
        if done { mode = .signIn }
      }
    }
  }
}
