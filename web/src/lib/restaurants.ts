"use client";

// The Restaurant data layer. Reads and writes go to the real backend (AppSync +
// DynamoDB) through the typed Amplify Data client. The compass math at the bottom
// is plain geometry and has no backend dependency.

import { generateClient } from "aws-amplify/data";
import type { Schema } from "../../amplify/data/resource";
import { configureAmplify } from "./amplify-config";

configureAmplify();

const client = generateClient<Schema>();

// The shape the UI works with. (The backend row also has id/owner/timestamps.)
export type Restaurant = Schema["Restaurant"]["type"];
export type NewRestaurant = {
  name: string;
  cuisine?: string;
  address?: string;
  lat: number;
  lng: number;
};

// A few real NYC spots to fill the shared list the first time anyone signs in.
const SEED: NewRestaurant[] = [
  { name: "Katz's Delicatessen", cuisine: "Deli", address: "205 E Houston St", lat: 40.7223, lng: -73.9874 },
  { name: "Lombardi's Pizza", cuisine: "Pizza", address: "32 Spring St", lat: 40.7216, lng: -73.9956 },
  { name: "Balthazar", cuisine: "French", address: "80 Spring St", lat: 40.7225, lng: -73.9981 },
  { name: "Joe's Shanghai", cuisine: "Chinese", address: "46 Bowery", lat: 40.7148, lng: -73.9967 },
  { name: "Shake Shack (Madison Sq)", cuisine: "Burgers", address: "Madison Square Park", lat: 40.7414, lng: -73.9882 },
  { name: "Levain Bakery", cuisine: "Bakery", address: "167 W 74th St", lat: 40.7794, lng: -73.9803 },
];

export async function listRestaurants(): Promise<Restaurant[]> {
  const { data } = await client.models.Restaurant.list();
  return data;
}

export async function createRestaurant(input: NewRestaurant): Promise<Restaurant | null> {
  const { data } = await client.models.Restaurant.create(input);
  return data;
}

// On a brand-new backend the table is empty, which makes for a sad demo. The
// first signed-in user seeds the shared list; everyone else just reads it.
export async function seedIfEmpty(): Promise<Restaurant[]> {
  const existing = await listRestaurants();
  if (existing.length > 0) return existing;
  await Promise.all(SEED.map((r) => createRestaurant(r)));
  return listRestaurants();
}

// Where the "compass" points from. In a real phone app this is your live GPS
// location; here we stand in the middle of Times Square.
export const ORIGIN = { lat: 40.758, lng: -73.9855, label: "Times Square" };

const toRad = (d: number) => (d * Math.PI) / 180;
const toDeg = (r: number) => (r * 180) / Math.PI;

// Compass bearing (0° = north, 90° = east) from origin to a restaurant.
export function bearing(from: { lat: number; lng: number }, to: { lat: number; lng: number }): number {
  const dLng = toRad(to.lng - from.lng);
  const y = Math.sin(dLng) * Math.cos(toRad(to.lat));
  const x =
    Math.cos(toRad(from.lat)) * Math.sin(toRad(to.lat)) -
    Math.sin(toRad(from.lat)) * Math.cos(toRad(to.lat)) * Math.cos(dLng);
  return (toDeg(Math.atan2(y, x)) + 360) % 360;
}

// Straight-line distance in miles (Haversine).
export function distanceMiles(from: { lat: number; lng: number }, to: { lat: number; lng: number }): number {
  const R = 3958.8;
  const dLat = toRad(to.lat - from.lat);
  const dLng = toRad(to.lng - from.lng);
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(toRad(from.lat)) * Math.cos(toRad(to.lat)) * Math.sin(dLng / 2) ** 2;
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}
