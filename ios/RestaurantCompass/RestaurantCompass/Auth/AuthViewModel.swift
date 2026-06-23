import Foundation
import Combine
import Amplify

// Cognito auth, mirroring the website's flow: sign up → confirm emailed code →
// sign in. Same user pool as the web app, so accounts are shared.
@MainActor
final class AuthViewModel: ObservableObject {
  @Published var isSignedIn = false
  @Published var isCheckingAuth = true
  @Published var email = ""
  @Published var userId = ""
  @Published var isWorking = false
  @Published var errorMessage = ""

  func checkAuthStatus() async {
    isCheckingAuth = true
    do {
      let session = try await Amplify.Auth.fetchAuthSession()
      isSignedIn = session.isSignedIn
      if isSignedIn { await loadUser() }
    } catch {
      isSignedIn = false
    }
    isCheckingAuth = false
  }

  private func loadUser() async {
    do {
      let user = try await Amplify.Auth.getCurrentUser()
      userId = user.userId
      let attributes = try await Amplify.Auth.fetchUserAttributes()
      email = attributes.first(where: { $0.key == .email })?.value ?? user.username
    } catch {
      // leave defaults
    }
  }

  /// Returns true if Cognito needs the emailed confirmation code next.
  func signUp(email: String, password: String) async -> Bool {
    isWorking = true; errorMessage = ""
    defer { isWorking = false }
    do {
      let attributes = [AuthUserAttribute(.email, value: email)]
      let result = try await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: .init(userAttributes: attributes)
      )
      if case .confirmUser = result.nextStep { return true }
      return false
    } catch {
      errorMessage = friendly(error)
      return false
    }
  }

  /// Returns true once the account is confirmed.
  func confirm(email: String, code: String) async -> Bool {
    isWorking = true; errorMessage = ""
    defer { isWorking = false }
    do {
      let result = try await Amplify.Auth.confirmSignUp(for: email, confirmationCode: code)
      return result.isSignUpComplete
    } catch {
      errorMessage = friendly(error)
      return false
    }
  }

  func resendCode(email: String) async {
    errorMessage = ""
    do {
      _ = try await Amplify.Auth.resendSignUpCode(for: email)
    } catch {
      errorMessage = friendly(error)
    }
  }

  func signIn(email: String, password: String) async {
    isWorking = true; errorMessage = ""
    defer { isWorking = false }
    do {
      let result = try await Amplify.Auth.signIn(username: email, password: password)
      if result.isSignedIn {
        await loadUser()
        isSignedIn = true
      } else {
        errorMessage = "Couldn't finish signing in (\(result.nextStep))."
      }
    } catch {
      errorMessage = friendly(error)
    }
  }

  func signOut() async {
    isWorking = true
    _ = await Amplify.Auth.signOut()
    isSignedIn = false
    email = ""
    userId = ""
    isWorking = false
  }

  private func friendly(_ error: Error) -> String {
    if let authError = error as? AuthError { return authError.errorDescription }
    return error.localizedDescription
  }
}
