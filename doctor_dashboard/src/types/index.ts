// ─── DOMAIN TYPES ─────────────────────────────────────────────────────────────

export type Severity = "high" | "medium" | "low";
export type MetricType = "bp" | "sugar" | "heart" | "weight" | "oxygen" | "temp";

export interface Patient {
  id: string;
  name: string;
  age: number;
  gender: string;
  bloodGroup: string;
  conditions: string[];
  compliance: number;
  weeklyTrend: number[];
  lastActive: string;
  alerts: Alert[];
  medicines: Medicine[];
  vitals: Record<MetricType, VitalReading[]>;
  phone: string;
  nextAppt: string;
  avatar: string;
}

export interface Alert {
  id: string;
  type: string;
  message: string;
  severity: Severity;
  time: string;
  isRead: boolean;
}

export interface AlertWithPatient extends Alert {
  patient: Patient;
}

export interface Medicine {
  name: string;
  dosage: string;
  frequency: string;
  adherence: number;
  color: string;
}

export interface VitalReading {
  date: string;
  value: number;
  secondary?: number;
}

export interface Doctor {
  name: string;
  initials: string;
  specialty: string;
  email: string;
}

export interface AuthState {
  isAuthenticated: boolean;
  doctor: Doctor | null;
}

export interface SentMessage {
  pid: string;
  text: string;
  time: string;
}

export interface Report {
  id: string;
  patient: string;
  patientId: string | null;
  title: string;
  type: "Compliance" | "Vitals" | "Adherence" | "Monitoring" | "Summary";
  date: string;
  status: "Ready" | "Pending" | "Generating";
  period: string;
}
