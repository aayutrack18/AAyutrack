import { useState } from "react";
import type { Severity, TabId } from "../types";
import { useDashboard } from "../context/DashboardContext";
import { severityColor, severityBg } from "../data/helpers";

interface AlertsPageProps {
  setActiveTab: (tab: TabId) => void;
  allAlerts: any[];
}

export function AlertsPage({ setActiveTab, allAlerts }: AlertsPageProps) {
  const { setSelectedPatient, markAlertRead } = useDashboard();
  const [severityFilter, setSeverityFilter] = useState<"all" | Severity>("all");

  const filtered = allAlerts
    .filter(a => severityFilter === "all" || a.severity === severityFilter)
    .sort((a: any, b: any) => {
      const sOrder = { high: 0, medium: 1, low: 2 };
      if (a.isRead !== b.isRead) return a.isRead ? 1 : -1;
      return sOrder[a.severity as Severity] - sOrder[b.severity as Severity];
    });

  return (
    <div>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 20 }}>
        <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>Risk Alerts</h1>
        <div style={{ display: "flex", gap: 8 }}>
          {(["all", "high", "medium", "low"] as const).map(f => (
            <button key={f} onClick={() => setSeverityFilter(f)} style={{
              padding: "6px 14px", borderRadius: 20,
              fontSize: 12, fontWeight: 700, border: "none", cursor: "pointer",
              background: severityFilter === f
                ? (f === "all" ? "#1e40af" : severityColor(f as Severity))
                : "#f1f5f9",
              color: severityFilter === f ? "white" : "#64748b",
              transition: "all 0.15s", textTransform: "capitalize",
            }}>{f}</button>
          ))}
        </div>
      </div>

      <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
        {filtered.map((a: any) => (
          <div key={a.id} style={{
            background: "white", borderRadius: 14,
            border: `1px solid ${a.isRead ? "#e2e8f0" : severityColor(a.severity) + "44"}`,
            padding: "16px 20px",
            display: "flex", gap: 16, alignItems: "flex-start",
            opacity: a.isRead ? 0.65 : 1,
            boxShadow: !a.isRead && a.severity === "high" ? "0 0 0 3px #fef2f2" : "none",
            transition: "all 0.2s",
          }}>
            {/* Severity icon */}
            <div style={{
              width: 40, height: 40, borderRadius: 12, flexShrink: 0,
              background: severityBg(a.severity),
              display: "flex", alignItems: "center", justifyContent: "center",
              fontSize: 18,
            }}>
              {a.severity === "high" ? "🚨" : a.severity === "medium" ? "⚠️" : "ℹ️"}
            </div>

            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 4 }}>
                <span style={{
                  fontSize: 11, fontWeight: 700, padding: "2px 8px", borderRadius: 10,
                  background: severityBg(a.severity), color: severityColor(a.severity),
                  textTransform: "uppercase",
                }}>{a.severity}</span>
                <span style={{ fontSize: 13, fontWeight: 800, color: "#0f172a" }}>{a.patient.name}</span>
                <span style={{ fontSize: 12, color: "#94a3b8" }}>· {a.type}</span>
                {!a.isRead && (
                  <span style={{
                    width: 7, height: 7, borderRadius: "50%",
                    background: severityColor(a.severity), display: "inline-block",
                  }} />
                )}
              </div>
              <p style={{ fontSize: 13, color: "#475569", lineHeight: 1.5 }}>{a.message}</p>
              <div style={{ display: "flex", gap: 10, marginTop: 8, alignItems: "center" }}>
                <span style={{ fontSize: 11, color: "#94a3b8" }}>{a.time}</span>
                <span style={{ fontSize: 11, color: "#94a3b8" }}>·</span>
                <span style={{ fontSize: 11, color: "#94a3b8" }}>{a.patient.conditions[0]}</span>
              </div>
            </div>

            <div style={{ display: "flex", gap: 8, flexShrink: 0 }}>
              {!a.isRead && (
                <button onClick={() => markAlertRead(a.patient.id, a.id)} style={{
                  background: "#f1f5f9", color: "#475569",
                  padding: "6px 12px", borderRadius: 8, fontSize: 12, fontWeight: 600,
                  border: "none", cursor: "pointer",
                }}>✓ Mark Read</button>
              )}
              <button onClick={() => { setSelectedPatient(a.patient); setActiveTab("patients"); }} style={{
                background: "#eff6ff", color: "#1e40af",
                padding: "6px 12px", borderRadius: 8, fontSize: 12, fontWeight: 600,
                border: "none", cursor: "pointer",
              }}>View Patient →</button>
            </div>
          </div>
        ))}

        {filtered.length === 0 && (
          <div style={{ textAlign: "center", padding: "60px 0", color: "#94a3b8" }}>
            <div style={{ fontSize: 40, marginBottom: 12 }}>✅</div>
            <div style={{ fontSize: 16, fontWeight: 700, color: "#475569" }}>No alerts</div>
            <div style={{ fontSize: 13, marginTop: 4 }}>All clear for this severity level</div>
          </div>
        )}
      </div>
    </div>
  );
}
