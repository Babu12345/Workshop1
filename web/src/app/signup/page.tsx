"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Compass } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { Input } from "@/components/ui/Input";
import { useAuth } from "@/lib/auth-context";

export default function SignupPage() {
  const router = useRouter();
  const { signUp } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    setLoading(true);
    try {
      const { needsConfirmation } = await signUp(email.trim(), password);
      if (needsConfirmation) {
        router.push(`/confirm?email=${encodeURIComponent(email.trim())}`);
      } else {
        router.push("/login");
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not sign up.");
      setLoading(false);
    }
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
              Create your account
            </h1>
            <p className="mt-1 text-sm text-ink-600 dark:text-ink-300">
              We&apos;ll email you a 6-digit code to confirm it&apos;s you.
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
                required
              />
              <Input
                name="password"
                type="password"
                label="Password"
                placeholder="At least 8 characters"
                hint="Cognito's default: 8+ chars with upper, lower, and a number."
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                autoComplete="new-password"
                error={error}
                required
              />
              <Button type="submit" fullWidth loading={loading} loadingText="Creating…">
                Sign up
              </Button>
            </form>
          </div>

          <p className="mt-6 text-center text-sm text-ink-500 dark:text-ink-400">
            Already have an account?{" "}
            <Link href="/login" className="font-medium text-ink-700 hover:text-ink-900 dark:text-ink-200 dark:hover:text-ink-50">
              Log in
            </Link>
          </p>
        </div>
      </main>
    </div>
  );
}
