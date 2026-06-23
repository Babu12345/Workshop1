//
//  RestaurantCompassApp.swift
//  RestaurantCompass
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSAPIPlugin

@main
struct RestaurantCompassApp: App {
  init() {
    Self.configureAmplify()
  }

  var body: some Scene {
    WindowGroup {
      RootView()
    }
  }

  // Wire up Cognito auth + the AppSync/GraphQL data API, pointed at the same
  // backend as the website via amplify_outputs.json (bundled in the app).
  private static func configureAmplify() {
    do {
      try Amplify.add(plugin: AWSCognitoAuthPlugin())
      try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
      try Amplify.configure(with: .resource(named: "amplify_outputs"))
      print("✅ Amplify configured")
    } catch {
      print("❌ Failed to configure Amplify: \(error)")
    }
  }
}

// Shows the login flow until the user is signed in, then the dashboard.
struct RootView: View {
  @StateObject private var auth = AuthViewModel()

  var body: some View {
    Group {
      if auth.isCheckingAuth {
        ZStack {
          Color.paper.ignoresSafeArea()
          ProgressView()
        }
      } else if auth.isSignedIn {
        DashboardView().environmentObject(auth)
      } else {
        AuthView().environmentObject(auth)
      }
    }
    .task { await auth.checkAuthStatus() }
  }
}
