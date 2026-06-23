# NYC Restaurant Compass — iOS App

A native SwiftUI companion to the website. It signs in with the **same** Amazon Cognito
user pool and reads/writes the **same** `Restaurant` table (AppSync + DynamoDB) — so an
account made on the web works on the phone, and the restaurant list is shared. On top of
that the phone adds the real **compass**: a needle that points at the restaurant you pick
and keeps pointing as you turn.

The Xcode project (`RestaurantCompass/`) is a standard **iOS App** template (SwiftUI). It
uses Xcode's synchronized folders, so any `.swift` file you drop into the
`RestaurantCompass/RestaurantCompass/` folder is automatically part of the app — no project
fiddling.

## One-time setup

### 1. Remove the SwiftData starter
The template ships a tiny SwiftData demo we don't use. Delete `Item.swift`, and remove the
`ModelContainer` / `import SwiftData` code from `RestaurantCompassApp.swift` and
`ContentView.swift` (Amplify handles our data instead).

### 2. Add the Amplify Swift package
In Xcode: **File → Add Package Dependencies…**, enter

```
https://github.com/aws-amplify/amplify-swift
```

Dependency rule **Up to Next Major Version**, starting at **2.52.1**. When prompted for
products, add these three to the **RestaurantCompass** target:

- `Amplify`
- `AWSCognitoAuthPlugin`
- `AWSAPIPlugin`

### 3. Add the backend config
The app reads `amplify_outputs.json` (the same kind of file the website uses). Generate it
from the deployed backend and put it **inside the app's source folder** so it gets bundled:

```bash
cd web
npx ampx generate outputs \
  --branch main --app-id d2lo5rgr6hl8kn \
  --out-dir ../ios/RestaurantCompass/RestaurantCompass \
  --profile <your-aws-profile>
```

(That `--app-id` is the Amplify app created when you deployed the website.) Confirm
`amplify_outputs.json` shows up under `RestaurantCompass/RestaurantCompass/` and is included
in the target's **Copy Bundle Resources** (synchronized folders add it automatically).

### 4. Allow location (for the compass)
Select the **RestaurantCompass** target → **Info** tab → add
**Privacy – Location When In Use Usage Description**
(`NSLocationWhenInUseUsageDescription`), e.g. *"We use your location to point the compass at
your chosen restaurant."*

### 5. Configure Amplify at launch
In `RestaurantCompassApp.swift`, add the plugins and point Amplify at the bundled config:

```swift
import Amplify
import AWSCognitoAuthPlugin
import AWSAPIPlugin

// in the App's init():
try Amplify.add(plugin: AWSCognitoAuthPlugin())
try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
try Amplify.configure(with: .resource(named: "amplify_outputs"))
```

## The app's pieces

Drop these Swift files into `RestaurantCompass/RestaurantCompass/` (group them in folders if
you like — synchronized folders don't care):

| Area | Files | What it does |
| --- | --- | --- |
| Model | `Restaurant.swift`, `Restaurant+Schema.swift`, `AmplifyModels.swift` | The `Restaurant` model, matching `web/amplify/data/resource.ts`, registered with Amplify |
| Auth | `AuthViewModel.swift`, `AuthView.swift` | Cognito sign up → confirm code → sign in (same flow as the website) |
| Data | `RestaurantStore.swift` | `list` / `create` via the typed Amplify Data API, plus first-run seeding |
| Compass | `CompassHeading.swift`, `Geo.swift`, `CompassView.swift` | `CoreLocation` heading + bearing math; the needle |
| Address | `AddressSearch.swift` | MapKit (`MKLocalSearchCompleter`) autocomplete for the add-restaurant address |
| Screens | `DashboardView.swift`, `AddRestaurantView.swift` | The list, add-a-restaurant, and the compass card |

### How the data layer works
The `Restaurant` model is registered through `AmplifyModels` and passed to `AWSAPIPlugin`, so
you get typed requests:

```swift
let result = try await Amplify.API.query(request: .list(Restaurant.self, limit: 1000))
let created = try await Amplify.API.mutate(request: .create(restaurant))
```

The same owner-write / authenticated-read rules from the backend apply, so everyone sees the
shared list and edits only their own additions.

### How the compass works
`CompassHeading` (a `CLLocationManager` wrapper) publishes your live location and the
direction the phone is pointing. The needle rotates by `bearing(you → restaurant) − heading`,
so it tracks the restaurant as you physically turn. On the Simulator there's no magnetometer —
set a location via **Features → Location** and the needle falls back to a north-up bearing.

For added restaurants to point at the *real* place, the add sheet uses MapKit autocomplete
(`AddressSearch`): pick a suggestion and its exact coordinates are stored. If you don't pick one,
the typed address is geocoded (`Geo.coordinate(forAddress:)`), and only if that fails does it drop
near Manhattan.

## Run it
Pick an iPhone simulator (or your device) and **⌘R**. Sign up → check email for the code →
confirm → log in → the dashboard shows the shared NYC list; tap one to aim the compass, or
**+** to add your own. Because it's the same backend, a restaurant you add here shows up on
the website too.
