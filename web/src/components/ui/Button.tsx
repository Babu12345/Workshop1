import { cn } from "@/lib/utils";
import { forwardRef } from "react";
import { Spinner } from "@/components/ui/Spinner";

type Variant = "primary" | "secondary" | "ghost" | "danger";

interface Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
  fullWidth?: boolean;
  loading?: boolean;
  loadingText?: string;
}

const spinnerStyles: Record<Variant, string> = {
  primary: "h-4 w-4 border-2 border-white/30 border-t-white dark:border-ink-900/30 dark:border-t-ink-900",
  secondary: "h-4 w-4 border-2 border-ink-300 border-t-ink-900 dark:border-ink-600 dark:border-t-ink-50",
  ghost: "h-4 w-4 border-2 border-ink-300 border-t-ink-900 dark:border-ink-600 dark:border-t-ink-50",
  danger: "h-4 w-4 border-2 border-white/30 border-t-white",
};

export const Button = forwardRef<HTMLButtonElement, Props>(function Button(
  { className, variant = "primary", fullWidth, disabled, loading, loadingText, children, ...props },
  ref
) {
  const base =
    "relative inline-flex items-center justify-center gap-2 rounded-full px-6 py-3 text-sm font-semibold transition disabled:opacity-50 disabled:cursor-not-allowed";
  const styles: Record<Variant, string> = {
    primary: "bg-ink-900 text-white hover:bg-ink-700 dark:bg-ink-50 dark:text-ink-900 dark:hover:bg-white",
    secondary:
      "border border-ink-200 bg-white text-ink-800 hover:bg-ink-50 dark:border-ink-700 dark:bg-ink-900 dark:text-ink-100 dark:hover:bg-ink-800",
    ghost: "text-ink-700 hover:bg-ink-100 dark:text-ink-200 dark:hover:bg-ink-800",
    danger: "bg-red-600 text-white hover:bg-red-700",
  };
  return (
    <button
      ref={ref}
      disabled={disabled || loading}
      className={cn(base, styles[variant], fullWidth && "w-full", className)}
      {...props}
    >
      <span className={cn("inline-flex items-center justify-center gap-2", loading && "invisible")}>
        {children}
      </span>
      {loading && (
        <span className="absolute inset-0 inline-flex items-center justify-center gap-2">
          <Spinner className={spinnerStyles[variant]} />
          {loadingText}
        </span>
      )}
    </button>
  );
});
