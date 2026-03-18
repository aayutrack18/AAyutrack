import { createContext, useContext, useState, type ReactNode } from "react";
import type { Patient, SentMessage } from "../types";
import { PATIENTS } from "../data/mockData";

interface DashboardContextType {
  patients: Patient[];
  setPatients: (p: Patient[]) => void;
  selectedPatient: Patient | null;
  setSelectedPatient: (p: Patient | null) => void;
  searchQuery: string;
  setSearchQuery: (q: string) => void;
  sentMsgs: SentMessage[];
  addSentMsg: (m: SentMessage) => void;
  markAlertRead: (patientId: string, alertId: string) => void;
}

const DashboardContext = createContext<DashboardContextType | null>(null);

export function DashboardProvider({ children }: { children: ReactNode }) {
  const [patients, setPatients] = useState<Patient[]>(PATIENTS);
  const [selectedPatient, setSelectedPatient] = useState<Patient | null>(null);
  const [searchQuery, setSearchQuery] = useState("");
  const [sentMsgs, setSentMsgs] = useState<SentMessage[]>([]);

  const markAlertRead = (patientId: string, alertId: string) => {
    setPatients(prev =>
      prev.map(p =>
        p.id === patientId
          ? { ...p, alerts: p.alerts.map(a => (a.id === alertId ? { ...a, isRead: true } : a)) }
          : p
      )
    );
    if (selectedPatient?.id === patientId) {
      setSelectedPatient(prev =>
        prev
          ? { ...prev, alerts: prev.alerts.map(a => (a.id === alertId ? { ...a, isRead: true } : a)) }
          : null
      );
    }
  };

  const addSentMsg = (m: SentMessage) => setSentMsgs(prev => [...prev, m]);

  return (
    <DashboardContext.Provider value={{
      patients, setPatients,
      selectedPatient, setSelectedPatient,
      searchQuery, setSearchQuery,
      sentMsgs, addSentMsg,
      markAlertRead,
    }}>
      {children}
    </DashboardContext.Provider>
  );
}

export function useDashboard() {
  const ctx = useContext(DashboardContext);
  if (!ctx) throw new Error("useDashboard must be inside DashboardProvider");
  return ctx;
}
