import SwiftUI

// The main screen after login: the live compass, the shared restaurant list,
// add-a-restaurant, and sign out.
struct DashboardView: View {
  @EnvironmentObject private var auth: AuthViewModel
  @StateObject private var store = RestaurantStore()
  @StateObject private var compass = CompassHeading()

  @State private var selectedID: String?
  @State private var showingAdd = false

  private var selected: Restaurant? {
    store.restaurants.first { $0.id == selectedID }
  }

  var body: some View {
    NavigationStack {
      ZStack {
        Color.paper.ignoresSafeArea()

        if store.isLoading {
          ProgressView()
        } else {
          ScrollView {
            VStack(spacing: 20) {
              CompassView(
                target: selected,
                origin: compass.origin,
                heading: compass.heading
              )

              if !store.errorMessage.isEmpty {
                Text(store.errorMessage)
                  .font(.footnote)
                  .foregroundStyle(.red)
                  .frame(maxWidth: .infinity, alignment: .leading)
              }

              VStack(alignment: .leading, spacing: 10) {
                Text("Your restaurants")
                  .font(.headline)
                  .foregroundStyle(Color.ink)

                ForEach(store.restaurants, id: \.id) { restaurant in
                  RestaurantRow(restaurant: restaurant, isSelected: restaurant.id == selectedID)
                    .onTapGesture { selectedID = restaurant.id }
                }
              }
            }
            .padding(20)
          }
        }
      }
      .navigationTitle("Compass")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button { Task { await auth.signOut() } } label: {
            Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
          }
          .tint(Color.inkSoft)
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button { showingAdd = true } label: {
            Label("Add", systemImage: "plus")
          }
          .tint(Color.accent)
        }
      }
      .sheet(isPresented: $showingAdd) {
        AddRestaurantView { name, cuisine, address in
          await store.add(name: name, cuisine: cuisine, address: address)
          selectedID = store.restaurants.first { $0.name == name }?.id ?? selectedID
        }
      }
    }
    .task {
      compass.start()
      await store.load()
      if selectedID == nil { selectedID = store.restaurants.first?.id }
    }
  }
}

private struct RestaurantRow: View {
  let restaurant: Restaurant
  let isSelected: Bool

  var body: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading, spacing: 4) {
        Text(restaurant.name).font(.headline).foregroundStyle(Color.ink)
        if let cuisine = restaurant.cuisine {
          Text(cuisine).font(.subheadline).foregroundStyle(Color.inkSoft)
        }
        if let address = restaurant.address {
          Label(address, systemImage: "mappin.and.ellipse")
            .font(.caption).foregroundStyle(Color.inkFaint)
        }
      }
      Spacer()
      if isSelected {
        Image(systemName: "location.north.fill").foregroundStyle(Color.accent)
      }
    }
    .padding(16)
    .background(isSelected ? Color.accentSoft : Color.white, in: RoundedRectangle(cornerRadius: 16))
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .stroke(isSelected ? Color.accent.opacity(0.6) : Color.inkFaint.opacity(0.2))
    )
  }
}
