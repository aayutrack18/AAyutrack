import { createContext, useContext, useState, useEffect, type ReactNode } from "react";
import type { Doctor } from "../types";
import { MOCK_DOCTOR } from "../data/mockData";

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
    const stored = sessionStorage.getItem("aayutrack_auth");
    if (stored) {
      setIsAuthenticated(true);
      setDoctor(MOCK_DOCTOR);
    }
  }, []);

  const login = async (email: string, password: string): Promise<boolean> => {
    // Mock auth — accept any non-empty credentials
    if (email.trim() && password.trim()) {
      sessionStorage.setItem("aayutrack_auth", "true");
      setIsAuthenticated(true);
      setDoctor(MOCK_DOCTOR);
      return true;
    }
    return false;
  };

  const logout = () => {
    sessionStorage.removeItem("aayutrack_auth");
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
