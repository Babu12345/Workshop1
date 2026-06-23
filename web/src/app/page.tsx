import Link from "next/link";
import { ArrowRight, Compass, MapPin, ListPlus, Navigation } from "lucide-react";
import { MarketingNav } from "@/components/marketing/Nav";
import { Footer } from "@/components/marketing/Footer";

const features = [
  { icon: MapPin, title: "Pick a restaurant", body: "Choose any spot in New York City from your list." },
  { icon: Navigation, title: "Follow the needle", body: "Your phone becomes a compass that points straight at it." },
  { icon: ListPlus, title: "Add your own", body: "Drop in a new favorite and it shows up for next time." },
];

export default function HomePage() {
  return (
    <div className="min-h-screen bg-paper dark:bg-paper-dark">
      <MarketingNav />

      {/* Hero */}
      <section className="relative overflow-hidden">
        <div className="mx-auto grid max-w-6xl gap-12 px-6 py-20 lg:grid-cols-2 lg:items-center">
          <div className="animate-fade-in">
            <div className="inline-flex items-center gap-2 rounded-full border border-ink-200 bg-white px-3 py-1 text-xs font-medium text-ink-700 dark:border-ink-700 dark:bg-ink-900 dark:text-ink-200">
              <Compass className="h-3.5 w-3.5" />
              Build-a-website workshop demo
            </div>
            <h1 className="mt-6 text-5xl font-semibold leading-[1.05] tracking-tight text-ink-900 sm:text-6xl dark:text-ink-50">
              Follow the needle
              <br />
              to <span className="font-display italic text-accent-600 dark:text-accent-400">dinner</span>.
            </h1>
            <p className="mt-6 max-w-xl text-lg text-ink-600 dark:text-ink-300">
              NYC Restaurant Compass turns your phone into a compass that points straight at the
              restaurant you choose. Sign in, pick a spot, and just walk toward the arrow.
            </p>
            <div className="mt-8 flex flex-wrap items-center gap-4">
              <Link href="/login" className="btn-primary">
                Try the demo
                <ArrowRight className="h-4 w-4" />
              </Link>
              <a href="#how" className="btn-secondary">
                How it works
              </a>
            </div>
            <p className="mt-4 text-xs text-ink-500 dark:text-ink-400">
              No sign-up needed — it&apos;s a demo. Any email and password will get you in.
            </p>
          </div>

          {/* Decorative compass */}
          <div className="relative flex justify-center">
            <div className="relative grid aspect-square w-full max-w-sm place-items-center rounded-full border border-ink-100 bg-white shadow-sm dark:border-ink-800 dark:bg-ink-900">
              <div className="absolute inset-6 rounded-full border border-dashed border-ink-200 dark:border-ink-700" />
              <span className="absolute top-4 text-xs font-semibold text-ink-400">N</span>
              <span className="absolute bottom-4 text-xs font-semibold text-ink-400">S</span>
              <span className="absolute left-4 text-xs font-semibold text-ink-400">W</span>
              <span className="absolute right-4 text-xs font-semibold text-ink-400">E</span>
              <Navigation className="h-24 w-24 -rotate-12 fill-accent-500 text-accent-600" />
            </div>
          </div>
        </div>
      </section>

      {/* How it works */}
      <section id="how" className="border-y border-ink-100 bg-white py-24 dark:border-ink-800 dark:bg-ink-900/40">
        <div className="mx-auto max-w-6xl px-6">
          <div className="max-w-2xl">
            <p className="text-sm font-semibold uppercase tracking-wider text-accent-600 dark:text-accent-400">
              How it works
            </p>
            <h2 className="mt-2 text-4xl font-semibold tracking-tight text-ink-900 dark:text-ink-50">
              Three steps to your table.
            </h2>
          </div>
          <div className="mt-12 grid gap-6 sm:grid-cols-3">
            {features.map((f, idx) => (
              <div
                key={f.title}
                className="relative rounded-2xl border border-ink-100 bg-paper p-6 dark:border-ink-800 dark:bg-ink-900"
              >
                <div className="flex items-center gap-3">
                  <span className="inline-flex h-8 w-8 items-center justify-center rounded-full bg-ink-900 text-sm font-semibold text-white dark:bg-ink-50 dark:text-ink-900">
                    {idx + 1}
                  </span>
                  <f.icon className="h-5 w-5 text-ink-600 dark:text-ink-300" />
                </div>
                <h3 className="mt-4 font-semibold text-ink-900 dark:text-ink-50">{f.title}</h3>
                <p className="mt-2 text-sm text-ink-600 dark:text-ink-300">{f.body}</p>
              </div>
            ))}
          </div>
          <div className="mt-12">
            <Link href="/login" className="btn-primary">
              Open the dashboard
              <ArrowRight className="h-4 w-4" />
            </Link>
          </div>
        </div>
      </section>

      <Footer />
    </div>
  );
}
