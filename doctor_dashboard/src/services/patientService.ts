/**
 * patientService.ts
 * Backend-ready abstraction for patient data.
 * Currently uses mock data. Replace implementations with Firebase/Firestore calls.
 */
import type { Patient } from "../types";
import { PATIENTS } from "../data/mockData";

export const patientService = {
  getAll: async (): Promise<Patient[]> => {
    return Promise.resolve([...PATIENTS]);
  },

  getById: async (id: string): Promise<Patient | null> => {
    return Promise.resolve(PATIENTS.find(p => p.id === id) ?? null);
  },

  search: async (query: string): Promise<Patient[]> => {
    const q = query.toLowerCase();
    return Promise.resolve(
      PATIENTS.filter(p =>
        p.name.toLowerCase().includes(q) ||
        p.conditions.some(c => c.toLowerCase().includes(q))
      )
    );
  },

  markAlertRead: async (_patientId: string, _alertId: string): Promise<boolean> => {
    // TODO: Replace with Firestore document update
    return Promise.resolve(true);
  },
};
