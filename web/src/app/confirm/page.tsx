"use client";

import { Suspense, useState } from "react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { Compass } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { Input } from "@/components/ui/Input";
import { useAuth } from "@/lib/auth-context";

function ConfirmForm() {
  const router = useRouter();
  const params = useSearchParams();
  const { confirmSignUp, resendCode } = useAuth();
  const [email, setEmail] = useState(params.get("email") ?? "");
  const [code, setCode] = useState("");
  const [error, setError] = useState("");
  const [note, setNote] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    setNote("");
    setLoading(true);
    try {
      await confirmSignUp(email.trim(), code.trim());
      router.push("/login");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not confirm the code.");
      setLoading(false);
    }
  }

  async function handleResend() {
    setError("");
    setNote("");
    try {
      await resendCode(email.trim());
      setNote("A fresh code is on its way.");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not resend the code.");
    }
  }

  return (
    <div className="card">
      <h1 className="text-2xl font-semibold tracking-tight text-ink-900 dark:text-ink-50">
        Confirm your email
      </h1>
      <p className="mt-1 text-sm text-ink-600 dark:text-ink-300">
        Enter the 6-digit code we emailed you.
      </p>

      <form onSubmit={handleSubmit} className="mt-6 flex flex-col gap-4">
        <Input
          name="email"
          type="email"
          label="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          autoComplete="email"
          required
        />
        <Input
          name="code"
          inputMode="numeric"
          label="Confirmation code"
          placeholder="123456"
          value={code}
          onChange={(e) => setCode(e.target.value)}
          error={error}
          hint={note || undefined}
          required
        />
        <Button type="submit" fullWidth loading={loading} loadingText="Confirming…">
          Confirm & continue
        </Button>
      </form>

      <button
        onClick={handleResend}
        className="mt-4 text-sm font-medium text-accent-700 hover:underline dark:text-accent-400"
      >
        Resend code
      </button>
    </div>
  );
}

export default function ConfirmPage() {
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
          <Suspense fallback={<div className="card">Loading…</div>}>
            <ConfirmForm />
          </Suspense>
          <p className="mt-6 text-center text-sm text-ink-500 dark:text-ink-400">
            <Link href="/login" className="font-medium text-ink-700 hover:text-ink-900 dark:text-ink-200 dark:hover:text-ink-50">
              ← Back to log in
            </Link>
          </p>
        </div>
      </main>
    </div>
  );
}
