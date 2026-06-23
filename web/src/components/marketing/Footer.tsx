import Link from "next/link";
import { Compass } from "lucide-react";

export function Footer() {
  return (
    <footer className="mt-24 border-t border-ink-100 bg-white/50 dark:border-ink-800 dark:bg-ink-900/50">
      <div className="mx-auto flex max-w-6xl flex-col items-start justify-between gap-3 px-6 py-10 sm:flex-row sm:items-center">
        <div className="flex items-center gap-2 text-sm font-semibold text-ink-900 dark:text-ink-50">
          <span className="inline-flex h-7 w-7 items-center justify-center rounded-lg bg-ink-900 text-white dark:bg-ink-50 dark:text-ink-900">
            <Compass className="h-4 w-4" />
          </span>
          NYC Restaurant Compass
        </div>
        <p className="text-xs text-ink-500 dark:text-ink-400">
          A workshop demo. Follow the needle to dinner. 🧭
        </p>
        <div className="flex gap-4 text-xs text-ink-500 dark:text-ink-400">
          <Link href="/login" className="hover:text-ink-800 dark:hover:text-ink-100">Log in</Link>
          <Link href="/dashboard" className="hover:text-ink-800 dark:hover:text-ink-100">Dashboard</Link>
        </div>
      </div>
    </footer>
  );
}
