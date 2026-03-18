import { createContext, useContext, useState, useEffect, type ReactNode } from "react";
import type { Doctor } from "../types";
import { authService } from "../services/authService";

interface AuthContextType {
  isAuthenticated: boolean;
  doctor: Doctor | null;
  login: (email: string, password: string) => Promise<boolean>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [doctor, setDoctor] = useState<Doctor | null>(null);

  useEffect(() => {
    const session = authService.getSession();
    if (session) {
      setIsAuthenticated(true);
      setDoctor(session);
    }
  }, []);

  const login = async (email: string, password: string): Promise<boolean> => {
    const doc = await authService.login(email, password);
    if (doc) {
      setIsAuthenticated(true);
      setDoctor(doc);
      return true;
    }
    return false;
  };

  const logout = () => {
    authService.logout();
    setIsAuthenticated(false);
    setDoctor(null);
  };

  return (
    <AuthContext.Provider value={{ isAuthenticated, doctor, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be inside AuthProvider");
  return ctx;
}
