# NYC Restaurant Compass — Claude Code Workshop

Build a full-stack **website + iOS app** on an **AWS backend**, using [Claude Code](https://claude.com/claude-code) as your pair programmer.

The demo: **NYC Restaurant Compass.** Sign up, log in, pick any restaurant in New York City, and your phone becomes a compass that points straight at it. Logged-in users can also **add their own stores**.

We build in two phases:

1. **Web first** — get the **landing page and login/register** clean and deployed.
2. **iOS next** — the native app with the live compass, sharing the same accounts and data.

> This project is scaffolded from the **`portrait_v2` template** (`/Users/babuwanyeki/Documents/iOSApps/portrait_v2`): a Next.js + AWS Amplify Gen 2 monorepo with a companion SwiftUI iOS app. Both surfaces share one Cognito user pool and one GraphQL/DynamoDB backend, so accounts and data are interchangeable across web and iOS.

---

## Tech stack

| Layer | Tech |
| --- | --- |
| **Web** | Next.js 16 (App Router, **SSR**), TypeScript, Tailwind CSS |
| **iOS** | SwiftUI + AWS Amplify Swift libraries |
| **Auth** | Amazon Cognito (email login) |
| **Data/API** | AWS AppSync (GraphQL) backed by **DynamoDB** |
| **Functions** | AWS Lambda (custom business logic) |
| **Storage** | Amazon S3 (store photos) |
| **Backend IaC** | AWS Amplify **Gen 2** (`amplify/` — TypeScript) |
| **Hosting** | AWS Amplify Hosting (SSR) |
| **AI pair programmer** | Claude Code |

### ⚠️ This is an SSR app (not a static export)

The web app is server-rendered. The template was switched from a static export to SSR — when you scaffold, make sure these two things match:

- **`web/next.config.js`** — no `output: "export"` (and no static-only `trailingSlash` / `images.unoptimized`). Plain SSR config:

  ```js
  /** @type {import('next').NextConfig} */
  const nextConfig = {
    reactStrictMode: true,
  };
  module.exports = nextConfig;
  ```

- **`amplify.yml`** — artifacts `baseDirectory` is **`.next`** (the SSR build output), **not** `out`:

  ```yaml
  artifacts:
    baseDirectory: .next
    files:
      - '**/*'
  ```

---

## Repository layout

```
Workshop1/
├── amplify/                 # Amplify Gen 2 backend (TypeScript)
│   ├── auth/resource.ts     # Cognito (email login)
│   ├── data/resource.ts     # GraphQL schema → DynamoDB (Restaurant model)
│   ├── functions/           # Lambda functions
│   ├── storage/             # S3 bucket (store photos)
│   └── backend.ts           # wires it all together
├── amplify_outputs.json     # generated backend config (sandbox)
├── web/                     # Next.js SSR web app
│   ├── next.config.js       # SSR config (no output: export)
│   ├── src/app/             # App Router: page.tsx (landing), login, signup, dashboard…
│   ├── src/lib/             # amplify-config, auth-context, data-api
│   └── src/components/      # ui/, marketing/, auth/
└── <iOS Xcode project>/     # SwiftUI app (Phase 2)
```

---

## Before you start — create your accounts

This workshop assumes you're starting from scratch. Create these three accounts first (each is free to sign up):

### 1. GitHub account (for code + deploys)

1. Go to **[github.com/signup](https://github.com/signup)** and create an account.
2. Verify your email.
3. (Recommended) Install [GitHub Desktop](https://desktop.github.com/) or set up `git` on the command line so you can push code. Amplify Hosting deploys straight from a GitHub repo, so you'll need this in Phase 1.

### 2. Claude account + Claude Code (your AI pair programmer)

1. Sign up at **[claude.ai](https://claude.ai)** with your email.
2. To use Claude Code you need an active plan (Pro or Max) **or** API billing. Choose one in your [account settings](https://claude.ai/settings/billing).
3. Install Claude Code:
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```
4. Run it once and log in when prompted:
   ```bash
   claude
   # follow the browser login flow to connect your Claude account
   ```

### 3. Install VS Code (your editor)

1. Download and install **[Visual Studio Code](https://code.visualstudio.com/)** for your OS.
2. (Recommended) Add the [Claude Code extension](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) so you can run Claude Code right inside the editor.

### 4. AWS account (the backend)

1. Sign up at **[aws.amazon.com](https://aws.amazon.com/)** → **Create an AWS Account**. A credit card is required, but this demo stays within the free tier.
2. Create an IAM user (or IAM Identity Center user) with programmatic access — **don't** use the root account for day-to-day work.
3. Install the [AWS CLI](https://aws.amazon.com/cli/) and configure a named profile:
   ```bash
   aws configure --profile workshop
   # paste your Access Key ID, Secret Access Key, region (e.g. us-east-1)
   ```
   Remember this profile name (`workshop`) — you'll pass it to the Amplify commands below.

---

## Prerequisites (tools)

- [ ] **GitHub**, **Claude**, and **AWS** accounts (see above)
- [ ] [Node.js](https://nodejs.org/) **20+** and npm
- [ ] [Claude Code](https://claude.com/claude-code) installed and logged in
- [ ] [AWS CLI](https://aws.amazon.com/cli/) configured with a named profile
- [ ] **VS Code** installed (with the Claude Code extension)
- [ ] **Xcode 15+** (Phase 2, iOS) — macOS only

---

## Phase 1 — Web (landing page + login)

### 1. Install and run the backend sandbox

The Amplify sandbox spins up a personal Cognito + AppSync + DynamoDB stack and writes `amplify_outputs.json`.

```bash
# from the repo root
npm install
npx ampx sandbox --profile <your-aws-profile>
# leave this running — it watches amplify/ and redeploys on change
```

### 2. Run the web app

```bash
cd web
npm install

# point the web app at the sandbox backend
cp ../amplify_outputs.json src/amplify_outputs.json

npm run dev
# open http://localhost:3000
```

### 3. Build the landing page and auth (the Phase 1 goal)

Drive this with Claude Code. Focus on a **clean landing page** and a **working login/register** flow before anything else:

- `web/src/app/page.tsx` — marketing landing page (hero, what the app does, call-to-action).
- `web/src/app/signup`, `login`, `confirm`, `forgot-password` — Cognito auth screens.
- `web/src/lib/auth-context.tsx` — `signUp` / `signIn` / `confirmSignUp` / `signOut` against Cognito.
- `web/src/app/dashboard/` — protected route: list NYC restaurants and a form to **add a store**.

**Definition of done for Phase 1:** landing page looks clean, a new user can register → confirm email → log in → land on the dashboard, and add a store that persists to DynamoDB.

### 4. Deploy the web app (AWS Amplify Hosting)

1. Push the repo to GitHub.
2. AWS Amplify console → **Host web app → Deploy from GitHub**, choose this repo.
3. Amplify detects `amplify.yml` (SSR; `baseDirectory: .next`) and provisions the backend on your branch.
4. Add any required environment variables in the Amplify console.

To deploy backend changes to a branch from the CLI:

```bash
npx ampx pipeline-deploy --branch main --app-id <your-amplify-app-id>
```

To regenerate the production outputs locally:

```bash
npx ampx generate outputs --profile <your-aws-profile> --branch main \
  --app-id <your-amplify-app-id> --out-dir /tmp \
  && mv /tmp/amplify_outputs.json amplify_outputs.main.json
```

---

## Phase 2 — iOS app

The iOS app reuses the **same** Cognito pool and GraphQL backend, so accounts created on the web work on iOS immediately.

### 1. Open the project

```bash
open *.xcodeproj   # from the repo root
```

### 2. Connect to the backend

`amplify_outputs.json` (from the sandbox or the `main` branch) is bundled into the app so Amplify Swift configures against the same backend as the web app.

### 3. Build the features (in this order)

1. **Auth first** — sign up / confirm / sign in / sign out (mirror the web flow with Amplify Auth).
2. **Restaurant list** — fetch restaurants from the GraphQL API.
3. **Add a store** — authenticated create mutation.
4. **The compass** — read device **location** (`CoreLocation`) and **heading** (magnetometer), compute the **bearing** from the user to the selected restaurant, and rotate a needle to point at it live.

---

## Data model (target)

A single `Restaurant` model, owner-authorized so users manage their own stores:

```ts
// amplify/data/resource.ts
Restaurant: a
  .model({
    name: a.string().required(),
    address: a.string(),
    lat: a.float().required(),
    lng: a.float().required(),
    photoKey: a.string(),       // S3 object key for the store photo
  })
  .authorization((allow) => [allow.owner(), allow.authenticated().to(['read'])]),
```

---

## Working with Claude Code

Useful prompts:

- *"Build a clean Next.js landing page in `web/src/app/page.tsx` for NYC Restaurant Compass — hero, feature highlights, and a Sign up CTA. Match the Tailwind setup."*
- *"Wire `web/src/lib/auth-context.tsx` to Cognito with signUp, confirmSignUp, signIn, and signOut."*
- *"Add a `Restaurant` model to `amplify/data/resource.ts` with owner auth, then a `data-api.ts` helper to list and create restaurants."*
- *"In the SwiftUI app, compute the bearing from the user's location to a selected restaurant and rotate a compass needle that updates with the device heading."*

Ask Claude Code to **explain each AWS resource it creates** so you understand what's running in your account.

---

## Cleanup

Stop the sandbox (`Ctrl-C`) and delete its stack to avoid charges:

```bash
npx ampx sandbox delete --profile <your-aws-profile>
```

For a deployed app, delete the Amplify Hosting app (this removes the branch backends), then confirm the Cognito pool, DynamoDB tables, Lambda functions, and S3 bucket are gone. Ask Claude Code to generate the teardown commands.

---

## License

MIT — for educational use in the workshop.
