import type { Severity } from "../types";

export function complianceColor(score: number): string {
  if (score >= 85) return "#10b981";
  if (score >= 70) return "#f59e0b";
  return "#ef4444";
}

export function complianceBg(score: number): string {
  if (score >= 85) return "#ecfdf5";
  if (score >= 70) return "#fffbeb";
  return "#fef2f2";
}

export function complianceLabel(score: number): string {
  if (score >= 85) return "Excellent";
  if (score >= 70) return "Good";
  return "Needs Attention";
}

export function severityColor(s: Severity): string {
  return s === "high" ? "#ef4444" : s === "medium" ? "#f59e0b" : "#3b82f6";
}

export function severityBg(s: Severity): string {
  return s === "high" ? "#fef2f2" : s === "medium" ? "#fffbeb" : "#eff6ff";
}

export function severityLabel(s: Severity): string {
  return s === "high" ? "Critical" : s === "medium" ? "Warning" : "Info";
}

export function getGreeting(): string {
  const h = new Date().getHours();
  if (h < 12) return "Good morning";
  if (h < 17) return "Good afternoon";
  return "Good evening";
}

export function today(): string {
  return new Date().toLocaleDateString("en-IN", {
    weekday: "long", year: "numeric", month: "long", day: "numeric",
  });
}
