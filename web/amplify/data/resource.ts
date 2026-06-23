import { type ClientSchema, a, defineData } from "@aws-amplify/backend";

/**
 * The Restaurant data model — backed by DynamoDB via AppSync.
 *
 * Authorization:
 *  - allow.owner()                         → you can create/update/delete your own
 *  - allow.authenticated().to(['read'])    → any signed-in user can see the whole list
 *
 * So everyone browses one shared list of NYC restaurants, but you can only edit
 * the ones you added.
 */
const schema = a.schema({
  Restaurant: a
    .model({
      name: a.string().required(),
      cuisine: a.string(),
      address: a.string(),
      lat: a.float().required(),
      lng: a.float().required(),
    })
    .authorization((allow) => [allow.owner(), allow.authenticated().to(["read"])]),
});

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: "userPool",
  },
});
