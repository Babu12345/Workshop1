"use client";

// A pretend login system for the demo. It does NOT check passwords or talk to a
// server — any email/password is accepted and the "session" is just saved in the
// browser. In the real workshop this gets swapped for AWS Amplify (Cognito),
// which gives you real accounts, email confirmation, and password reset.

import { createContext, useContext, useEffect, useState } from "react";

interface User {
  email: string;
}

interface AuthValue {
  user: User | null;
  loading: boolean;
  signIn: (email: string) => void;
  signOut: () => void;
}

const STORAGE_KEY = "compass.user.v1";
const AuthContext = createContext<AuthValue | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    try {
      const raw = window.localStorage.getItem(STORAGE_KEY);
      if (raw) setUser(JSON.parse(raw) as User);
    } catch {
      /* ignore */
    }
    setLoading(false);
  }, []);

  function signIn(email: string) {
    const next = { email };
    setUser(next);
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(next));
  }

  function signOut() {
    setUser(null);
    window.localStorage.removeItem(STORAGE_KEY);
  }

  return (
    <AuthContext.Provider value={{ user, loading, signIn, signOut }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth(): AuthValue {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used inside <AuthProvider>");
  return ctx;
}
