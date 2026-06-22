# NYC Restaurant Compass — Claude Code Workshop

Build a full-stack web **and** mobile app with an **AWS backend**, using [Claude Code](https://claude.com/claude-code) as your pair programmer.

In this workshop you'll ship **NYC Restaurant Compass**: pick any restaurant in New York City and your phone becomes a compass that points you straight at it. Users can register, log in, and add their own stores to the map.

---

## What you'll build

A two-surface app sharing one AWS backend:

- **Web app** — browse and search NYC restaurants, register/login, add new stores.
- **Mobile app** — the live compass. Select a restaurant and follow the needle.
- **AWS backend** — authentication, a restaurant database, and a REST API.

### The demo: how the compass works

1. The app reads your device's **GPS location** and **heading** (magnetometer).
2. You **select a restaurant** from the list/map.
3. The app computes the **bearing** from you to the restaurant and rotates a needle to point at it, updating live as you turn and walk.

---

## What you'll learn

- Driving real feature work with **Claude Code** — planning, generating, and iterating on code.
- Standing up an **AWS serverless backend** (auth, API, database).
- Wiring a **frontend to a cloud API** with login-protected requests.
- Using device sensors (**geolocation + compass heading**) in a mobile app.

---

## Architecture

```
┌─────────────┐     ┌─────────────┐
│   Web App   │     │ Mobile App  │
│  (React)    │     │(React Native)│
└──────┬──────┘     └──────┬──────┘
       │                   │
       │  HTTPS (JWT auth) │
       └─────────┬─────────┘
                 ▼
        ┌────────────────┐
        │  API Gateway   │
        └────────┬───────┘
                 ▼
        ┌────────────────┐      ┌──────────────────┐
        │  Lambda (API)  │◀────▶│  Amazon Cognito  │
        │  functions     │      │  (auth / users)  │
        └────────┬───────┘      └──────────────────┘
                 ▼
        ┌────────────────┐
        │   DynamoDB     │  ← restaurants / stores
        └────────────────┘
```

### AWS services used

| Service | Role |
|---|---|
| **Amazon Cognito** | User registration, login, and JWT issuance |
| **API Gateway** | Public REST endpoint for the apps |
| **AWS Lambda** | Business logic (list / add restaurants) |
| **DynamoDB** | Stores restaurant + store records |
| **S3 + CloudFront** *(optional)* | Hosting for the web app |

---

## Tech stack

- **Web:** React + Vite
- **Mobile:** React Native (Expo) — for `expo-location` and the magnetometer
- **Backend:** AWS (Cognito, API Gateway, Lambda, DynamoDB)
- **Infra/tooling:** AWS CLI (or AWS SAM / CDK)
- **AI pair programmer:** Claude Code

---

## Prerequisites

Before the workshop, please install and set up:

- [ ] [Node.js](https://nodejs.org/) 18+ and npm
- [ ] [Claude Code](https://claude.com/claude-code) (`npm install -g @anthropic-ai/claude-code`)
- [ ] An **AWS account** with billing enabled (this demo stays within the free tier)
- [ ] [AWS CLI](https://aws.amazon.com/cli/) installed and configured (`aws configure`)
- [ ] A phone with [Expo Go](https://expo.dev/go), or a simulator/emulator
- [ ] A code editor (VS Code recommended)

---

## Workshop flow

> Each step is driven through Claude Code. Ask it to plan first, then implement.

### 1. Project setup
Scaffold the web and mobile apps and a backend folder.

### 2. Backend — auth
Stand up **Cognito** for register/login and verify you can get a JWT.

### 3. Backend — data + API
Create the **DynamoDB** table, **Lambda** handlers, and **API Gateway** routes:
- `GET /restaurants` — list NYC restaurants
- `POST /restaurants` — add a store *(auth required)*

### 4. Web app — auth + stores
Build register/login screens and a form to **add a store**, calling the API with the user's token.

### 5. Mobile app — the compass
Read location + heading, select a restaurant, and render the **live compass** pointing at it.

### 6. Polish & deploy
Seed sample NYC restaurants, handle errors, and (optionally) deploy the web app to **S3 + CloudFront**.

---

## API reference (target)

| Method | Path | Auth | Description |
|---|---|---|---|
| `POST` | `/auth/register` | — | Register a new user |
| `POST` | `/auth/login` | — | Log in, returns JWT |
| `GET` | `/restaurants` | — | List all NYC restaurants |
| `POST` | `/restaurants` | ✅ | Add a new store |

**Restaurant record**

```json
{
  "id": "rest_123",
  "name": "Joe's Pizza",
  "address": "7 Carmine St, New York, NY",
  "lat": 40.7305,
  "lng": -74.0027,
  "addedBy": "user_abc"
}
```

---

## Working with Claude Code

A few prompts to get you moving:

- *"Plan the AWS backend for a restaurant app with Cognito auth and a DynamoDB-backed REST API."*
- *"Create a Lambda function and API Gateway route to list restaurants from DynamoDB."*
- *"Build a React login form that authenticates against Cognito and stores the JWT."*
- *"In the React Native app, compute the bearing from my location to a selected restaurant and rotate a compass needle to point at it."*

Tip: ask Claude Code to **explain the AWS resources it creates** so you understand what's running in your account.

---

## Cleanup

To avoid charges after the workshop, tear down AWS resources:

- Delete the **Cognito** user pool
- Delete the **DynamoDB** table
- Delete the **Lambda** functions and **API Gateway** API
- Empty and delete the **S3** bucket / **CloudFront** distribution (if used)

You can ask Claude Code to generate the AWS CLI commands to remove everything it created.

---

## License

MIT — for educational use in the workshop.
