"use client";

import { AuthProvider } from "@/lib/auth-context";
import { configureAmplify } from "@/lib/amplify-config";

configureAmplify();

export function Providers({ children }: { children: React.ReactNode }) {
  return <AuthProvider>{children}</AuthProvider>;
}
