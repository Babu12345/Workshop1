// The core data object for the whole app: a Restaurant.
// In the real workshop this lives in an AWS Amplify database. For this demo we
// keep the list in the browser (localStorage) so it works with zero setup —
// add a restaurant and it's still there when you come back.

export interface Restaurant {
  id: string;
  name: string;
  cuisine: string;
  address: string;
  lat: number;
  lng: number;
}

// A few real NYC spots to start the list with.
const SEED: Restaurant[] = [
  { id: "katz", name: "Katz's Delicatessen", cuisine: "Deli", address: "205 E Houston St", lat: 40.7223, lng: -73.9874 },
  { id: "lombardis", name: "Lombardi's Pizza", cuisine: "Pizza", address: "32 Spring St", lat: 40.7216, lng: -73.9956 },
  { id: "balthazar", name: "Balthazar", cuisine: "French", address: "80 Spring St", lat: 40.7225, lng: -73.9981 },
  { id: "joes", name: "Joe's Shanghai", cuisine: "Chinese", address: "46 Bowery", lat: 40.7148, lng: -73.9967 },
  { id: "shake-shack", name: "Shake Shack (Madison Sq)", cuisine: "Burgers", address: "Madison Square Park", lat: 40.7414, lng: -73.9882 },
  { id: "levain", name: "Levain Bakery", cuisine: "Bakery", address: "167 W 74th St", lat: 40.7794, lng: -73.9803 },
];

const STORAGE_KEY = "compass.restaurants.v1";

export function loadRestaurants(): Restaurant[] {
  if (typeof window === "undefined") return SEED;
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) {
      window.localStorage.setItem(STORAGE_KEY, JSON.stringify(SEED));
      return SEED;
    }
    return JSON.parse(raw) as Restaurant[];
  } catch {
    return SEED;
  }
}

export function saveRestaurants(list: Restaurant[]): void {
  if (typeof window === "undefined") return;
  window.localStorage.setItem(STORAGE_KEY, JSON.stringify(list));
}

// Where the "compass" points from. In the real app this is your live GPS
// location; for the demo we stand in the middle of Times Square.
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
