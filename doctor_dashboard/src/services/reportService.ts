/**
 * reportService.ts
 * Backend-ready abstraction for report generation and download.
 * Mock implementation — swap with Firebase Storage / Cloud Functions.
 */
import type { Report } from "../types";
import { MOCK_REPORTS } from "../data/mockData";

export const reportService = {
  getAll: async (): Promise<Report[]> => {
    return Promise.resolve([...MOCK_REPORTS]);
  },

  getById: async (id: string): Promise<Report | null> => {
    return Promise.resolve(MOCK_REPORTS.find(r => r.id === id) ?? null);
  },

  getForPatient: async (patientId: string): Promise<Report[]> => {
    return Promise.resolve(MOCK_REPORTS.filter(r => r.patientId === patientId));
  },

  download: async (reportId: string): Promise<{ success: boolean; filename: string }> => {
    // TODO: Replace with Cloud Function call that streams a PDF from Firebase Storage
    const report = MOCK_REPORTS.find(r => r.id === reportId);
    if (!report) return { success: false, filename: "" };
    const filename = `${report.title.replace(/\s+/g, "_")}.pdf`;
    // Simulate generation delay
    await new Promise(r => setTimeout(r, 900));
    return { success: true, filename };
  },
};
