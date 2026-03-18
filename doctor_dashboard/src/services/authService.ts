/**
 * authService.ts
 * Backend-ready auth abstraction.
 * Currently: sessionStorage mock.
 * TODO: Replace with Firebase Auth — firebase.auth().signInWithEmailAndPassword()
 */
import type { Doctor } from "../types";
import { MOCK_DOCTOR } from "../data/mockData";

const SESSION_KEY = "aayutrack_auth";

export const authService = {
  login: async (email: string, password: string): Promise<Doctor | null> => {
    // Validate inputs — in production this goes to Firebase Auth
    if (!email.trim() || !password.trim()) return null;
    sessionStorage.setItem(SESSION_KEY, JSON.stringify({ email }));
    return Promise.resolve(MOCK_DOCTOR);
  },

  logout: async (): Promise<void> => {
    sessionStorage.removeItem(SESSION_KEY);
    return Promise.resolve();
  },

  getSession: (): Doctor | null => {
    const stored = sessionStorage.getItem(SESSION_KEY);
    return stored ? MOCK_DOCTOR : null;
  },
};
