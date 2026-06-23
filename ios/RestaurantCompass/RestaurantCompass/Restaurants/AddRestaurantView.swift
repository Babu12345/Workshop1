import SwiftUI
import MapKit

// Add-a-restaurant sheet. The address field autocompletes (MapKit); picking a
// suggestion pins exact coordinates, which are passed back to the store.
struct AddRestaurantView: View {
  let onSave: (_ name: String, _ cuisine: String, _ address: String, _ coordinate: CLLocationCoordinate2D?) async -> Void

  @Environment(\.dismiss) private var dismiss
  @StateObject private var addressSearch = AddressSearch()

  @State private var name = ""
  @State private var cuisine = ""
  @State private var pickedCoordinate: CLLocationCoordinate2D?
  @State private var pickedLabel = ""
  @State private var saving = false

  // The pin is only valid while the text still matches what was picked — once
  // the user edits the address again, suggestions come back.
  private var hasValidPin: Bool {
    pickedCoordinate != nil && addressSearch.query == pickedLabel
  }

  var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField("Name (e.g. Di Fara Pizza)", text: $name)
          TextField("Cuisine (e.g. Pizza)", text: $cuisine)
          TextField("Address (e.g. 205 E Houston St)", text: $addressSearch.query)
            .textInputAutocapitalization(.words)
            .autocorrectionDisabled()
        } footer: {
          Text("Start typing an address and tap a suggestion to pin the exact spot. (No pick? We'll look up the text, or drop it near Manhattan.)")
        }

        if hasValidPin {
          Section {
            Label("Location pinned", systemImage: "mappin.circle.fill")
              .foregroundStyle(Color.accent)
          }
        } else if !addressSearch.suggestions.isEmpty {
          Section("Suggestions") {
            ForEach(addressSearch.suggestions, id: \.self) { suggestion in
              Button { pick(suggestion) } label: {
                VStack(alignment: .leading, spacing: 2) {
                  Text(suggestion.title).foregroundStyle(Color.ink)
                  if !suggestion.subtitle.isEmpty {
                    Text(suggestion.subtitle).font(.caption).foregroundStyle(Color.inkSoft)
                  }
                }
              }
            }
          }
        }
      }
      .navigationTitle("Add restaurant")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Save") { save() }
            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || saving)
        }
      }
    }
  }

  private func pick(_ suggestion: MKLocalSearchCompletion) {
    Task {
      if let (coordinate, label) = await addressSearch.resolve(suggestion) {
        pickedCoordinate = coordinate
        pickedLabel = label
        addressSearch.query = label
        addressSearch.suggestions = []
      }
    }
  }

  private func save() {
    saving = true
    Task {
      await onSave(
        name.trimmingCharacters(in: .whitespaces),
        cuisine.trimmingCharacters(in: .whitespaces),
        addressSearch.query.trimmingCharacters(in: .whitespaces),
        hasValidPin ? pickedCoordinate : nil
      )
      dismiss()
    }
  }
}
