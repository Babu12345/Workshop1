# NYC Restaurant Compass — Demo Website

A small, self-contained demo of what workshop participants build: a welcome page,
a login page, and a dashboard that lists NYC restaurants and points a compass needle
at the one you pick.

**No AWS account needed.** Login is faked and the restaurant list lives in your
browser (localStorage), so it runs anywhere with just Node.

## Run it

```bash
cd web
npm install
npm run dev
# open http://localhost:3000
```

Then: click **Try the demo** → type **any** email/password → **Log in** → you land on the
dashboard. Pick a restaurant to swing the compass needle, or **Add restaurant** to grow the list.

## What's inside

| Page | File | What it shows |
| --- | --- | --- |
| Welcome | `src/app/page.tsx` | Marketing hero + "how it works" |
| Login | `src/app/login/page.tsx` | Email/password form (demo: accepts anything) |
| Dashboard | `src/app/dashboard/page.tsx` | Restaurant list + live compass + add form |

- **The Restaurant object** lives in `src/lib/restaurants.ts` (type, seed data, save/load,
  plus the compass `bearing()` + `distanceMiles()` math).
- **The pretend login** lives in `src/lib/auth-context.tsx`.
- UI components (`Button`, `Input`, `Card`, `Spinner`) and the ink/accent/paper theme mirror
  the production Paper Portrait site so the look is consistent.

## How this maps to the real workshop

This demo deliberately swaps the two hard parts for fakes so it runs instantly:

| Demo | Real workshop (Part 2+) |
| --- | --- |
| `auth-context.tsx` accepts any login | AWS Amplify (Cognito) — real accounts + email confirmation |
| `restaurants.ts` saves to localStorage | Amplify Data (`Restaurant` model) backed by DynamoDB |
| Origin fixed at Times Square | The phone's live GPS location |

Use it as the "here's where we're headed" reference at the start of the workshop.

---

## 🚀 Putting it on the real internet

Everything above runs only on your own computer, with the pretend login. When you're ready
to give your site a **real web address** that anyone can open — with **real sign-ups**
instead of the fake one — you deploy it to **AWS Amplify**. Amplify builds the website *and*
its behind-the-scenes backend (the part that remembers accounts and restaurants) for you,
straight from GitHub. No commands to type — it's all clicks.

You only do this once. After that, every time you save changes to GitHub, your live site
updates itself.

### Before you start
- A **GitHub** account with this project pushed to it. Not sure? Ask Claude Code:
  *"Help me put this project on GitHub."*
- An **AWS** account with the one-time permission turned on (see the main workshop guide,
  **Part 1 → Create an AWS account**).

### Steps (all on the AWS Amplify website)
1. Open the **AWS Amplify** console and click **Create new app**.
2. Choose **GitHub**, sign in when asked, then pick your **Workshop1** repository and the
   **main** branch.
3. Tick **"My app is a monorepo"** and set the folder to **`web`**. Click **Next**.
4. On the **App settings** screen, tick **"My monorepo uses Amplify Gen2 Backend"**.
   ⚠️ **Don't skip this** — it's the box that tells AWS to build your accounts system and
   database. Without it the site goes live with a broken login.
5. Ticking that box reveals a **service role** option (permission to build the backend) —
   let it create/allow one. That's the same AWS permission from Part 1. Leave the detected
   build settings (`npm run build` → `.next`) as they are.
6. Click **Next → Save and deploy**.

The first build takes a few minutes — Amplify is setting up your accounts system and
database for the very first time. When it's done, you get a real link like
`https://main.xxxxxx.amplifyapp.com` you can share with anyone. 🎉

### From now on
Made a change you like? Save it to GitHub (ask Claude Code: *"push my changes to GitHub"*)
and your live site rebuilds itself automatically.

> 🆘 If a build turns red, copy the error message and paste it to Claude Code with
> *"my Amplify build failed — what do I do?"* — that's the intended way to get unstuck.

### Build notes (for whoever maintains this)

- **The build uses `npm install`, not `npm ci`** (see `amplify.yml`). `npm ci` does a strict
  lockfile check and fails on this project because `@aws-amplify/backend-cli`'s CDK/WASM
  optional dependencies (`cdk-from-cfn`, `@aws-cdk/toolkit-lib`, some `@smithy/*` packages)
  aren't recorded in `package-lock.json` in the exact shape `npm ci` demands. The symptom is
  a first-step failure like `npm error Missing: @aws-cdk/toolkit-lib@… from lock file`.
  `npm install` reconciles the lockfile and installs cleanly, so both the backend and
  frontend phases in `amplify.yml` use it.
- `amplify_outputs.json` is generated during the build (`ampx generate outputs … --out-dir
  src`) and is gitignored — never commit it.
