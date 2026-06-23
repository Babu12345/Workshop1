import { defineBackend } from "@aws-amplify/backend";
import { auth } from "./auth/resource";
import { data } from "./data/resource";

/**
 * The whole backend for NYC Restaurant Compass: email auth + the Restaurant
 * database. Amplify turns this into Cognito + AppSync + DynamoDB.
 * @see https://docs.amplify.aws/gen2/build-a-backend
 */
defineBackend({
  auth,
  data,
});
