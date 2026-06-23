import SwiftUI

// Add-a-restaurant sheet. Calls back into the store to create it on the backend.
struct AddRestaurantView: View {
  let onSave: (_ name: String, _ cuisine: String, _ address: String) async -> Void

  @Environment(\.dismiss) private var dismiss
  @State private var name = ""
  @State private var cuisine = ""
  @State private var address = ""
  @State private var saving = false

  var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField("Name (e.g. Di Fara Pizza)", text: $name)
          TextField("Cuisine (e.g. Pizza)", text: $cuisine)
          TextField("Address (e.g. 1424 Avenue J)", text: $address)
        } footer: {
          Text("New spots are dropped at a random point around Manhattan so the compass has something to point at.")
        }
      }
      .navigationTitle("Add restaurant")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Save") {
            saving = true
            Task {
              await onSave(
                name.trimmingCharacters(in: .whitespaces),
                cuisine.trimmingCharacters(in: .whitespaces),
                address.trimmingCharacters(in: .whitespaces)
              )
              dismiss()
            }
          }
          .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || saving)
        }
      }
    }
  }
}
