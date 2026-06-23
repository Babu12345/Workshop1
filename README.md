# 🧭 NYC Restaurant Compass — Build a Website & App Workshop

Welcome! 👋 In this workshop you'll build a real website **and** a real iPhone app — even if you've never written a line of code in your life.

You won't be doing the coding yourself. **Claude Code** (an AI assistant) writes the code for you. Your job is to tell it what you want, follow the steps below, and watch it come to life. Think of yourself as the director, and Claude Code as the crew.

## What we're building

A fun app called **NYC Restaurant Compass**:

- You sign up and log in.
- You pick a restaurant in New York City from a list.
- Your phone turns into a **compass** — the needle points straight toward that restaurant, so you can literally follow it there.
- You can also **add your own restaurants** to the list.

We'll build it in two parts:

1. **The website first** — we'll get the welcome page and the login working and looking nice.
2. **The iPhone app next** — same accounts, same data, plus the live compass.

---

## A few words you'll see a lot (don't worry, that's all the jargon)

You don't need to memorize these — just glance back here whenever a word looks unfamiliar.

| Word | What it actually means |
| --- | --- |
| **Website** | The thing you open in a web browser like Chrome or Safari. |
| **App** | The thing you install on your iPhone. |
| **Backend** | The "behind the scenes" part that lives on the internet — it remembers your account and your list of restaurants. Like the kitchen behind a restaurant: you don't see it, but nothing works without it. |
| **AWS** | Amazon Web Services — the company that runs our backend on their computers (so we don't have to). |
| **Terminal** | A plain text window where you type commands. We'll tell you exactly what to type — you just copy, paste, and press Enter. |
| **Command** | A line of text you type into the Terminal to make something happen. |
| **Repo** (repository) | A folder that holds all your project's files, with a history of changes. |
| **Deploy** | To put your website or app "live" on the internet so other people can use it. |
| **Claude Code** | Your AI assistant. It writes and edits the code when you ask it to, in plain English. |

> 💡 **Where do I type commands?** Wherever you run Claude Code (see Step 1). In **VS Code**, open **Terminal → New Terminal** — a panel opens at the bottom. In the **Claude desktop app**, you can simply *ask* Claude to run a command for you, or use its built-in terminal. Either way, you copy, paste, and let it run.

---

## Part 1 — Set up your accounts and tools

We need to create a few free accounts and install a few programs. Take your time and do these in order. ☕

### Step 1 — Choose your workspace (pick ONE)

This is where everything happens. Pick the option that sounds more like you — both run **Claude Code**, so both can build the whole project.

**Option A — Claude Desktop (easiest, "I really don't want to see code")** 🟢
> A simple chat window. You type what you want; Claude does it behind the scenes. Best if you want the least technical experience.
1. Download the **Claude desktop app** from **[claude.ai/download](https://claude.ai/download)**.
2. Install and open it, then sign in (you'll set up the account in Step 3).

**Option B — VS Code (more control, "I'm curious to see the code")** 🔵
> A proper builder's workspace where you can watch the files change. Still beginner-friendly.
1. Go to **[code.visualstudio.com](https://code.visualstudio.com/)** and click the big download button.
2. Install it like any other program, then open it.

> 👉 The rest of this guide works the same either way. When we say "ask Claude Code," you do that in whichever app you picked. When we say "open a Terminal," VS Code users use the Terminal panel; Claude Desktop users can just ask Claude to run the command.

### Step 2 — Create a GitHub account (where your project lives)

GitHub is like Google Drive for code — it stores your project safely online and is what we use to put your website on the internet later.

1. Go to **[github.com/signup](https://github.com/signup)**.
2. Create an account and confirm your email.

### Step 3 — Set up Claude Code (your AI assistant)

This is the helper that actually writes the code.

1. Create a Claude account at **[claude.ai](https://claude.ai)**.
2. Claude Code needs a paid plan (Claude **Pro** or **Max**). Pick one at **[claude.ai/settings/billing](https://claude.ai/settings/billing)**.
3. Turn on Claude Code in the workspace you picked in Step 1:
   - **Claude Desktop (Option A):** sign in to the app — Claude Code is built in. You're ready to go.
   - **VS Code (Option B):** install the **Claude Code extension** — click the squares icon on the left (Extensions), search for **"Claude Code"**, click **Install**, then log in when prompted. [Direct link here.](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code)

> From now on, you can just *talk* to Claude Code. Ask it things in plain English like "build me a welcome page."

### Step 4 — Create an AWS account (your backend)

AWS is where your accounts and restaurant list will be stored online.

1. Go to **[aws.amazon.com](https://aws.amazon.com/)** and click **Create an AWS Account**.
2. You'll need to enter a credit card. **Don't panic** — this project is designed to stay within AWS's free tier, so you shouldn't be charged. (We'll clean everything up at the end so it stays that way.)
3. **Give your account permission to build the backend.** This is a one-time setting:
   - Sign in to AWS and search for **IAM** in the top search bar.
   - Go to **Users → your user → Add permissions → Attach policies directly**.
   - Search for **`AmplifyBackendDeployFullAccess`**, tick the box, and save.
   - *(In plain English: this lets our tools create the backend on your behalf. Without it, the backend steps will fail with a "permission denied" message.)*

> 🙋 Not sure how to do any AWS step? Ask Claude Code! Type: *"Walk me through attaching the AmplifyBackendDeployFullAccess policy in AWS, step by step."*

### Step 5 — Install the helper tools

These are two small programs our project needs. (VS Code users: open a Terminal with **Terminal → New Terminal**. Claude Desktop users: just ask Claude to run the commands for you.)

- **Node.js** — download the "LTS" version from **[nodejs.org](https://nodejs.org/)** and install it. (This lets the website run on your computer while you build it.)
- **AWS CLI** — follow the installer at **[aws.amazon.com/cli](https://aws.amazon.com/cli/)**. Then connect it to your AWS account by typing this in the Terminal and pressing Enter:

  ```bash
  aws configure --profile workshop
  ```

  It will ask for an "Access Key", "Secret Key", and "region". You get these from your AWS account (Claude Code can walk you through finding them — just ask!). The word `workshop` is just a nickname for your AWS account; remember it for later.

✅ **You also only need this if you're building the iPhone app (Part 4):** install **Xcode** from the Mac App Store. (Mac only.)

---

## Part 2 — Build the website (welcome page + login)

Now the fun part. Open your project folder in your workspace (VS Code: **File → Open Folder**; Claude Desktop: point Claude at the project folder), and get a Terminal ready (or let Claude run the commands for you).

### Step 1 — Start the backend

Type this and press Enter:

```bash
npm install
npx ampx sandbox --profile workshop
```

What this does: the first line gathers the building blocks the project needs. The second line creates your personal backend on AWS (your login system and database). **Leave this running** — it keeps watching for changes. Open a *second* Terminal for the next step (or, in Claude Desktop, just ask Claude to run the next commands).

### Step 2 — Start the website on your computer

In the **second** Terminal, type:

```bash
cd web
npm install
cp ../amplify_outputs.json src/amplify_outputs.json
npm run dev
```

When it finishes, it'll show a web address like **http://localhost:3000**. Hold Cmd (Mac) or Ctrl (Windows) and click it — your website opens in the browser! Right now it's mostly empty. That's where Claude Code comes in.

### Step 3 — Ask Claude Code to build it

This is the heart of the workshop. Talk to Claude Code and ask for what you want. Try these, one at a time:

- *"Build a clean, friendly welcome page for an app called NYC Restaurant Compass. Explain what it does and add a big Sign Up button."*
- *"Now create the Sign Up and Log In pages, connected to our backend so people can actually make accounts."*
- *"After someone logs in, show them a page that lists NYC restaurants and lets them add a new one."*

After each request, refresh your browser to see what changed. Don't like something? Just say so: *"Make the welcome page use warmer colors and a bigger headline."*

🎯 **You've finished Part 2 when:** the welcome page looks nice, a new person can sign up, confirm their email, log in, and add a restaurant that's still there when they come back.

---

## Part 3 — Put your website on the internet

Right now your website only runs on *your* computer. Let's make it public.

1. **Save your project to GitHub.** Ask Claude Code: *"Help me put this project on GitHub."* It'll walk you through it.
2. Go to the **AWS Amplify** service in your AWS account → **Host web app → Deploy from GitHub**, and choose your project.
3. AWS reads the included settings file and does the rest. After a few minutes, you get a real web address you can share with anyone! 🎉

> If something fails here, copy the error message and paste it to Claude Code — it'll tell you what to fix.

---

## Part 4 — Build the iPhone app (Mac only)

The app shares the *same* accounts and restaurants as your website — so anyone who signed up on the website can log in on the phone too.

1. Open the app project in **Xcode** (ask Claude Code: *"Open the iOS app in Xcode for me"* if you're unsure how).
2. Ask Claude Code to build the features, one at a time:
   - *"Add sign up and log in to the iPhone app, using the same backend as the website."*
   - *"Show a list of the restaurants from our backend."*
   - *"Let me add a new restaurant from the phone."*
   - *"Build the compass: point a needle at whichever restaurant I select, and keep it pointing as I turn around."*
3. Press the ▶️ Play button in Xcode to try it on the iPhone simulator.

---

## When you're done — clean up (avoid surprise charges) 🧹

To make sure AWS doesn't keep anything running:

1. In the Terminal that's running the backend, press **Ctrl + C** to stop it.
2. Then type:

   ```bash
   npx ampx sandbox delete --profile workshop
   ```

3. If you deployed your website in Part 3, delete the app in the **AWS Amplify** console too.

Not sure if everything's gone? Ask Claude Code: *"Help me confirm I've deleted all the AWS resources from this project so I won't be charged."*

---

## Tips for talking to Claude Code 💬

- **Ask for one thing at a time.** "Build the login page" works better than "build the whole app."
- **Be specific about what you want.** Colors, wording, layout — it can do all of it.
- **Paste any error messages** straight into the chat. Errors are normal and Claude Code is great at fixing them.
- **It's okay to say "I don't understand."** Ask it to explain anything in simpler terms.
- **Nothing is permanent.** If you don't like a change, just ask it to undo or redo it differently.

---

## 🆘 Stuck?

Almost every problem can be solved by copying what you see on screen (a command that didn't work, or a red error message) and pasting it to Claude Code with "I'm stuck — what do I do?" That's genuinely the intended way to use this — you're not cheating, you're working as designed.

---

<details>
<summary>🔧 For the curious — what's under the hood</summary>

This project is built from a template (`portrait_v2`): a Next.js web app + AWS Amplify Gen 2 backend, with a companion SwiftUI iOS app. The website and the app share one Cognito user pool and one GraphQL/DynamoDB backend, so accounts and data are interchangeable.

**Tech stack**

| Layer | Tech |
| --- | --- |
| Web | Next.js 16 (App Router, **SSR**), TypeScript, Tailwind CSS |
| iOS | SwiftUI + AWS Amplify Swift |
| Auth | Amazon Cognito (email login) |
| Data/API | AWS AppSync (GraphQL) → DynamoDB |
| Functions | AWS Lambda |
| Storage | Amazon S3 (restaurant photos) |
| Backend | AWS Amplify Gen 2 (`amplify/`, TypeScript) |
| Hosting | AWS Amplify Hosting (SSR) |

**This is a server-rendered (SSR) app, not a static export.** Two settings make that work:

- `web/next.config.js` — no `output: "export"`:
  ```js
  /** @type {import('next').NextConfig} */
  const nextConfig = { reactStrictMode: true };
  module.exports = nextConfig;
  ```
- `amplify.yml` — artifacts `baseDirectory` is `.next` (not `out`):
  ```yaml
  artifacts:
    baseDirectory: .next
    files:
      - '**/*'
  ```

**The data model** — a single `Restaurant`, owner-authorized so users manage their own:

```ts
// amplify/data/resource.ts
Restaurant: a
  .model({
    name: a.string().required(),
    address: a.string(),
    lat: a.float().required(),
    lng: a.float().required(),
    photoKey: a.string(),
  })
  .authorization((allow) => [allow.owner(), allow.authenticated().to(['read'])]),
```

**Deploying backend changes from the command line** (requires the `AmplifyBackendDeployFullAccess` policy):

```bash
npx ampx pipeline-deploy --branch main --app-id <your-amplify-app-id>
```

Regenerate the production backend config:

```bash
npx ampx generate outputs --profile workshop --branch main \
  --app-id <your-amplify-app-id> --out-dir /tmp \
  && mv /tmp/amplify_outputs.json amplify_outputs.main.json
```

**Project layout**

```
Workshop1/
├── amplify/                 # backend: auth, data, functions, storage
├── amplify_outputs.json     # generated backend config
├── web/                     # the website (Next.js)
│   └── src/app/             # welcome page, login, signup, dashboard…
└── <iOS Xcode project>/     # the iPhone app
```

</details>

---

*MIT — for educational use in the workshop.*
