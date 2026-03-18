import type { ReactNode } from "react";
import { useAuth } from "../context/AuthContext";
import { LoginPage } from "../pages/LoginPage";

export function ProtectedRoute({ children }: { children: ReactNode }) {
  const { isAuthenticated } = useAuth();
  if (!isAuthenticated) return <LoginPage />;
  return <>{children}</>;
}
