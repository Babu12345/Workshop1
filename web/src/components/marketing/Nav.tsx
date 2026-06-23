"use client";

import Link from "next/link";
import { Compass } from "lucide-react";
import { useAuth } from "@/lib/auth-context";

export function MarketingNav() {
  const { user, loading } = useAuth();
  return (
    <header className="sticky top-0 z-40 border-b border-ink-100 bg-paper/80 backdrop-blur dark:border-ink-800 dark:bg-paper-dark/80">
      <nav className="mx-auto flex max-w-6xl items-center justify-between px-6 py-4">
        <Link href="/" className="flex items-center gap-2 text-lg font-semibold text-ink-900 dark:text-ink-50">
          <span className="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-ink-900 text-white dark:bg-ink-50 dark:text-ink-900">
            <Compass className="h-5 w-5" />
          </span>
          NYC Restaurant Compass
        </Link>
        <div className="flex items-center justify-end gap-3">
          {loading ? (
            <div aria-hidden className="h-10 w-32 animate-pulse rounded-full bg-ink-100 dark:bg-ink-800" />
          ) : user ? (
            <Link href="/dashboard" className="btn-primary">
              Open dashboard
            </Link>
          ) : (
            <>
              <Link
                href="/login"
                className="hidden text-sm font-medium text-ink-700 hover:text-ink-900 sm:inline dark:text-ink-200 dark:hover:text-ink-50"
              >
                Log in
              </Link>
              <Link href="/signup" className="btn-primary">
                Get started
              </Link>
            </>
          )}
        </div>
      </nav>
    </header>
  );
}
