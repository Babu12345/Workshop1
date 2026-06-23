import { defineAuth } from "@aws-amplify/backend";

/**
 * Sign-up / sign-in with email. Cognito emails a 6-digit code to confirm a new
 * account (handled by the /confirm page in the web app).
 * @see https://docs.amplify.aws/gen2/build-a-backend/auth
 */
export const auth = defineAuth({
  loginWith: {
    email: true,
  },
});
