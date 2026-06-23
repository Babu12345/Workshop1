"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Compass } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { Input } from "@/components/ui/Input";
import { useAuth } from "@/lib/auth-context";

export default function LoginPage() {
  const router = useRouter();
  const { signIn } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    if (!email.trim()) {
      setError("Enter any email to continue.");
      return;
    }
    setLoading(true);
    // Demo: accept any credentials and head to the dashboard.
    signIn(email.trim());
    router.push("/dashboard");
  }

  return (
    <div className="flex min-h-screen flex-col bg-paper dark:bg-paper-dark">
      <header className="px-6 py-5">
        <Link href="/" className="inline-flex items-center gap-2 text-lg font-semibold text-ink-900 dark:text-ink-50">
          <span className="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-ink-900 text-white dark:bg-ink-50 dark:text-ink-900">
            <Compass className="h-5 w-5" />
          </span>
          NYC Restaurant Compass
        </Link>
      </header>

      <main className="flex flex-1 items-center justify-center px-6 py-12">
        <div className="w-full max-w-md animate-slide-up">
          <div className="card">
            <h1 className="text-2xl font-semibold tracking-tight text-ink-900 dark:text-ink-50">
              Welcome back
            </h1>
            <p className="mt-1 text-sm text-ink-600 dark:text-ink-300">
              Log in to see your restaurants and the compass.
            </p>

            <form onSubmit={handleSubmit} className="mt-6 flex flex-col gap-4">
              <Input
                name="email"
                type="email"
                label="Email"
                placeholder="you@example.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                autoComplete="email"
              />
              <Input
                name="password"
                type="password"
                label="Password"
                placeholder="••••••••"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                autoComplete="current-password"
                error={error}
              />
              <Button type="submit" fullWidth loading={loading} loadingText="Signing in…">
                Log in
              </Button>
            </form>

            <p className="mt-5 rounded-xl bg-accent-50 px-4 py-3 text-xs text-accent-800 dark:bg-accent-900/30 dark:text-accent-200">
              This is a demo — there&apos;s no real account. Type any email and password and press
              <span className="font-semibold"> Log in</span>.
            </p>
          </div>

          <p className="mt-6 text-center text-sm text-ink-500 dark:text-ink-400">
            <Link href="/" className="font-medium text-ink-700 hover:text-ink-900 dark:text-ink-200 dark:hover:text-ink-50">
              ← Back home
            </Link>
          </p>
        </div>
      </main>
    </div>
  );
}
