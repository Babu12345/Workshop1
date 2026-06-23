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
3. When it asks about the project layout, tick **"My app is a monorepo"** and set the
   folder to **`web`**.
4. If it mentions a **service role** (permission to build the backend), click to
   create/allow it — that's the same AWS permission from Part 1.
5. Click **Save and deploy**.

The first build takes a few minutes — Amplify is setting up your accounts system and
database for the very first time. When it's done, you get a real link like
`https://main.xxxxxx.amplifyapp.com` you can share with anyone. 🎉

### From now on
Made a change you like? Save it to GitHub (ask Claude Code: *"push my changes to GitHub"*)
and your live site rebuilds itself automatically.

> 🆘 If a build turns red, copy the error message and paste it to Claude Code with
> *"my Amplify build failed — what do I do?"* — that's the intended way to get unstuck.
