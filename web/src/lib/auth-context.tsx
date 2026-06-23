"use client";

// Real authentication, backed by Amazon Cognito (set up in amplify/auth).
// Sign up → confirm with an emailed code → log in. The user "session" is a real
// Cognito token managed by the Amplify libraries, not a fake localStorage flag.

import { createContext, useCallback, useContext, useEffect, useState } from "react";
import {
  getCurrentUser,
  fetchAuthSession,
  signUp as amplifySignUp,
  confirmSignUp as amplifyConfirmSignUp,
  resendSignUpCode,
  signIn as amplifySignIn,
  signOut as amplifySignOut,
} from "aws-amplify/auth";
import { configureAmplify } from "./amplify-config";

configureAmplify();

interface User {
  userId: string;
  email: string | null;
}

interface AuthValue {
  user: User | null;
  loading: boolean;
  signUp: (email: string, password: string) => Promise<{ needsConfirmation: boolean }>;
  confirmSignUp: (email: string, code: string) => Promise<void>;
  resendCode: (email: string) => Promise<void>;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthValue | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  // Ask Cognito who's currently signed in (if anyone).
  const refresh = useCallback(async () => {
    try {
      const current = await getCurrentUser();
      const session = await fetchAuthSession();
      const email = (session.tokens?.idToken?.payload?.email as string | undefined) ?? null;
      setUser({ userId: current.userId, email });
    } catch {
      setUser(null);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    refresh();
  }, [refresh]);

  const signUp = useCallback(async (email: string, password: string) => {
    const result = await amplifySignUp({
      username: email,
      password,
      options: { userAttributes: { email } },
    });
    return { needsConfirmation: !result.isSignUpComplete };
  }, []);

  const confirmSignUp = useCallback(async (email: string, code: string) => {
    await amplifyConfirmSignUp({ username: email, confirmationCode: code });
  }, []);

  const resendCode = useCallback(async (email: string) => {
    await resendSignUpCode({ username: email });
  }, []);

  const signIn = useCallback(
    async (email: string, password: string) => {
      const { isSignedIn, nextStep } = await amplifySignIn({ username: email, password });
      if (!isSignedIn) {
        throw new Error(`Additional step required: ${nextStep.signInStep}`);
      }
      await refresh();
    },
    [refresh]
  );

  const signOut = useCallback(async () => {
    await amplifySignOut();
    setUser(null);
  }, []);

  return (
    <AuthContext.Provider
      value={{ user, loading, signUp, confirmSignUp, resendCode, signIn, signOut }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth(): AuthValue {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used inside <AuthProvider>");
  return ctx;
}
