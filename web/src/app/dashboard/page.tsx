"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Compass, LogOut, Plus, Navigation, MapPin } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { Input } from "@/components/ui/Input";
import { Spinner } from "@/components/ui/Spinner";
import { useAuth } from "@/lib/auth-context";
import {
  Restaurant,
  ORIGIN,
  bearing,
  distanceMiles,
  loadRestaurants,
  saveRestaurants,
} from "@/lib/restaurants";

export default function DashboardPage() {
  const router = useRouter();
  const { user, loading, signOut } = useAuth();

  const [restaurants, setRestaurants] = useState<Restaurant[]>([]);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [name, setName] = useState("");
  const [cuisine, setCuisine] = useState("");
  const [address, setAddress] = useState("");
  const [showForm, setShowForm] = useState(false);

  // Protect the page: bounce to login if there's no demo session.
  useEffect(() => {
    if (!loading && !user) router.replace("/login");
  }, [loading, user, router]);

  // Load the list once we're on the client.
  useEffect(() => {
    const list = loadRestaurants();
    setRestaurants(list);
    setSelectedId(list[0]?.id ?? null);
  }, []);

  const selected = useMemo(
    () => restaurants.find((r) => r.id === selectedId) ?? null,
    [restaurants, selectedId]
  );

  function handleAdd(e: React.FormEvent) {
    e.preventDefault();
    if (!name.trim()) return;
    // Beginners don't know GPS coordinates, so the demo drops new spots at a
    // random point around Manhattan — enough to make the compass move.
    const jitter = () => (Math.random() - 0.5) * 0.08;
    const next: Restaurant = {
      id: `r-${restaurants.length}-${name.trim().toLowerCase().replace(/\s+/g, "-")}`,
      name: name.trim(),
      cuisine: cuisine.trim() || "Restaurant",
      address: address.trim() || "New York, NY",
      lat: ORIGIN.lat + jitter(),
      lng: ORIGIN.lng + jitter(),
    };
    const updated = [...restaurants, next];
    setRestaurants(updated);
    saveRestaurants(updated);
    setSelectedId(next.id);
    setName("");
    setCuisine("");
    setAddress("");
    setShowForm(false);
  }

  if (loading || !user) {
    return (
      <div className="grid min-h-screen place-items-center bg-paper dark:bg-paper-dark">
        <Spinner />
      </div>
    );
  }

  const heading = selected ? bearing(ORIGIN, selected) : 0;
  const miles = selected ? distanceMiles(ORIGIN, selected) : 0;

  return (
    <div className="min-h-screen bg-paper dark:bg-paper-dark">
      {/* Top bar */}
      <header className="sticky top-0 z-40 border-b border-ink-100 bg-paper/80 backdrop-blur dark:border-ink-800 dark:bg-paper-dark/80">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-6 py-4">
          <Link href="/" className="flex items-center gap-2 text-lg font-semibold text-ink-900 dark:text-ink-50">
            <span className="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-ink-900 text-white dark:bg-ink-50 dark:text-ink-900">
              <Compass className="h-5 w-5" />
            </span>
            <span className="hidden sm:inline">NYC Restaurant Compass</span>
          </Link>
          <div className="flex items-center gap-4">
            <span className="hidden text-sm text-ink-500 sm:inline dark:text-ink-400">{user.email}</span>
            <button
              onClick={() => {
                signOut();
                router.push("/");
              }}
              className="btn-ghost"
            >
              <LogOut className="h-4 w-4" />
              Sign out
            </button>
          </div>
        </div>
      </header>

      <main className="mx-auto max-w-6xl px-6 py-10">
        <div className="flex flex-wrap items-end justify-between gap-4">
          <div>
            <h1 className="text-3xl font-semibold tracking-tight text-ink-900 dark:text-ink-50">
              Your restaurants
            </h1>
            <p className="mt-1 text-sm text-ink-600 dark:text-ink-300">
              Compass points from <span className="font-medium">{ORIGIN.label}</span>. Pick a spot to aim at it.
            </p>
          </div>
          <Button onClick={() => setShowForm((v) => !v)} variant={showForm ? "secondary" : "primary"}>
            <Plus className="h-4 w-4" />
            {showForm ? "Cancel" : "Add restaurant"}
          </Button>
        </div>

        {/* Add form */}
        {showForm && (
          <form
            onSubmit={handleAdd}
            className="mt-6 grid animate-slide-up gap-4 rounded-2xl border border-ink-100 bg-white p-6 sm:grid-cols-3 dark:border-ink-800 dark:bg-ink-900"
          >
            <Input name="name" label="Name" placeholder="Di Fara Pizza" value={name} onChange={(e) => setName(e.target.value)} />
            <Input name="cuisine" label="Cuisine" placeholder="Pizza" value={cuisine} onChange={(e) => setCuisine(e.target.value)} />
            <Input name="address" label="Address" placeholder="1424 Avenue J" value={address} onChange={(e) => setAddress(e.target.value)} />
            <div className="sm:col-span-3">
              <Button type="submit">Save restaurant</Button>
            </div>
          </form>
        )}

        <div className="mt-8 grid gap-8 lg:grid-cols-[1fr_360px]">
          {/* List */}
          <ul className="grid gap-4 sm:grid-cols-2">
            {restaurants.map((r) => {
              const active = r.id === selectedId;
              return (
                <li key={r.id}>
                  <button
                    onClick={() => setSelectedId(r.id)}
                    className={`w-full rounded-2xl border p-5 text-left transition ${
                      active
                        ? "border-accent-400 bg-accent-50 dark:border-accent-500 dark:bg-accent-900/20"
                        : "border-ink-100 bg-white hover:-translate-y-0.5 hover:shadow-md dark:border-ink-800 dark:bg-ink-900 dark:hover:bg-ink-800"
                    }`}
                  >
                    <div className="flex items-start justify-between gap-3">
                      <div>
                        <h3 className="font-semibold text-ink-900 dark:text-ink-50">{r.name}</h3>
                        <p className="mt-0.5 text-sm text-ink-500 dark:text-ink-400">{r.cuisine}</p>
                      </div>
                      {active && <Navigation className="h-5 w-5 shrink-0 fill-accent-500 text-accent-600" />}
                    </div>
                    <p className="mt-3 flex items-center gap-1.5 text-xs text-ink-500 dark:text-ink-400">
                      <MapPin className="h-3.5 w-3.5" />
                      {r.address}
                    </p>
                  </button>
                </li>
              );
            })}
          </ul>

          {/* Compass panel */}
          <aside className="lg:sticky lg:top-24 lg:self-start">
            <div className="card flex flex-col items-center text-center">
              <p className="text-sm font-semibold uppercase tracking-wider text-accent-600 dark:text-accent-400">
                Pointing to
              </p>
              <h2 className="mt-1 text-xl font-semibold text-ink-900 dark:text-ink-50">
                {selected ? selected.name : "Pick a restaurant"}
              </h2>

              <div className="relative my-6 grid h-56 w-56 place-items-center rounded-full border border-ink-100 bg-paper dark:border-ink-800 dark:bg-ink-950">
                <div className="absolute inset-5 rounded-full border border-dashed border-ink-200 dark:border-ink-700" />
                <span className="absolute top-3 text-xs font-semibold text-ink-400">N</span>
                <span className="absolute bottom-3 text-xs font-semibold text-ink-400">S</span>
                <span className="absolute left-3 text-xs font-semibold text-ink-400">W</span>
                <span className="absolute right-3 text-xs font-semibold text-ink-400">E</span>
                <Navigation
                  className="h-20 w-20 fill-accent-500 text-accent-600 transition-transform duration-700 ease-out"
                  style={{ transform: `rotate(${heading}deg)` }}
                />
              </div>

              {selected && (
                <div className="grid w-full grid-cols-2 gap-3">
                  <div className="rounded-xl bg-ink-50 px-3 py-2 dark:bg-ink-800">
                    <p className="text-xs text-ink-500 dark:text-ink-400">Heading</p>
                    <p className="text-lg font-semibold text-ink-900 dark:text-ink-50">{Math.round(heading)}°</p>
                  </div>
                  <div className="rounded-xl bg-ink-50 px-3 py-2 dark:bg-ink-800">
                    <p className="text-xs text-ink-500 dark:text-ink-400">Distance</p>
                    <p className="text-lg font-semibold text-ink-900 dark:text-ink-50">{miles.toFixed(1)} mi</p>
                  </div>
                </div>
              )}
            </div>
          </aside>
        </div>
      </main>
    </div>
  );
}
