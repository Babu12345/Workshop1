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
