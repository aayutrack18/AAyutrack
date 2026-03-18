import { useState } from "react";
import { useNavigate } from "react-router-dom";
import type { Severity } from "../types";
import { useDashboard } from "../context/DashboardContext";
import { severityColor, severityBg } from "../data/helpers";

const FILTER_OPTIONS = [
  { key: "all",    label: "All" },
  { key: "high",   label: "🚨 Critical" },
  { key: "medium", label: "⚠ Warning" },
  { key: "low",    label: "ℹ Info" },
] as const;

export function AlertsPage() {
  const navigate = useNavigate();
  const { patients, markAlertRead } = useDashboard();
  const [severityFilter, setSeverityFilter] = useState<"all" | Severity>("all");
  const [showRead, setShowRead] = useState(false);

  const allAlerts = patients.flatMap(p =>
    p.alerts.map(a => ({ ...a, patient: p }))
  );

  const filtered = allAlerts
    .filter(a => severityFilter === "all" || a.severity === severityFilter)
    .filter(a => showRead || !a.isRead)
    .sort((a, b) => {
      if (a.isRead !== b.isRead) return a.isRead ? 1 : -1;
      const ord: Record<Severity, number> = { high: 0, medium: 1, low: 2 };
      return ord[a.severity] - ord[b.severity];
    });

  const unreadCount = allAlerts.filter(a => !a.isRead).length;

  return (
    <div>
      {/* Header */}
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 24 }}>
        <div>
          <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>
            Risk Alerts
          </h1>
          <p style={{ color: "#64748b", fontSize: 14, marginTop: 4 }}>
            {unreadCount > 0
              ? `${unreadCount} unread alert${unreadCount > 1 ? "s" : ""} require attention`
              : "All alerts have been reviewed"}
          </p>
        </div>

        <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
          {/* Show read toggle */}
          <label style={{
            display: "flex", alignItems: "center", gap: 6,
            fontSize: 12, color: "#64748b", cursor: "pointer", fontWeight: 500,
          }}>
            <input
              type="checkbox"
              checked={showRead}
              onChange={e => setShowRead(e.target.checked)}
              style={{ width: 14, height: 14, cursor: "pointer" }}
            />
            Show read
          </label>

          {/* Severity filters */}
          <div style={{ display: "flex", gap: 6 }}>
            {FILTER_OPTIONS.map(f => (
              <button
                key={f.key}
                onClick={() => setSeverityFilter(f.key)}
                style={{
                  padding: "6px 14px", borderRadius: 20, border: "none",
                  fontSize: 12, fontWeight: 700, cursor: "pointer",
                  background: severityFilter === f.key
                    ? (f.key === "all" ? "#1e40af" : severityColor(f.key as Severity))
                    : "#f1f5f9",
                  color: severityFilter === f.key ? "white" : "#64748b",
                  transition: "all 0.15s",
                }}
              >
                {f.label}
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* Alert list */}
      {filtered.length === 0 ? (
        <div style={{
          textAlign: "center", padding: "80px 0",
          background: "white", borderRadius: 16, border: "1px solid #e2e8f0",
        }}>
          <div style={{ fontSize: 48, marginBottom: 16 }}>
            {showRead ? "📭" : "✅"}
          </div>
          <div style={{ fontSize: 16, fontWeight: 700, color: "#475569", marginBottom: 6 }}>
            {showRead ? "No alerts match this filter" : "No unread alerts"}
          </div>
          <div style={{ fontSize: 13, color: "#94a3b8" }}>
            {showRead
              ? "Try changing the severity filter"
              : "All alerts have been reviewed — great work!"}
          </div>
        </div>
      ) : (
        <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
          {filtered.map(a => (
            <div key={a.id} style={{
              background: "white", borderRadius: 14,
              border: `1px solid ${a.isRead ? "#e2e8f0" : `${severityColor(a.severity)}44`}`,
              padding: "16px 20px",
              display: "flex", gap: 16, alignItems: "flex-start",
              opacity: a.isRead ? 0.6 : 1,
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

              {/* Content */}
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 4, flexWrap: "wrap" }}>
                  <span style={{
                    fontSize: 10, fontWeight: 700, padding: "2px 8px", borderRadius: 10,
                    background: severityBg(a.severity), color: severityColor(a.severity),
                    textTransform: "uppercase", letterSpacing: 0.5,
                  }}>
                    {a.severity}
                  </span>
                  <span style={{ fontSize: 13, fontWeight: 800, color: "#0f172a" }}>{a.patient.name}</span>
                  <span style={{ fontSize: 12, color: "#94a3b8" }}>· {a.type}</span>
                  {!a.isRead && (
                    <span style={{
                      width: 7, height: 7, borderRadius: "50%",
                      background: severityColor(a.severity), display: "inline-block",
                    }} />
                  )}
                </div>
                <p style={{ fontSize: 13, color: "#475569", lineHeight: 1.5, marginBottom: 6 }}>
                  {a.message}
                </p>
                <div style={{ fontSize: 11, color: "#94a3b8" }}>
                  {a.time} · {a.patient.conditions[0]}
                </div>
              </div>

              {/* Actions */}
              <div style={{ display: "flex", gap: 8, flexShrink: 0 }}>
                {!a.isRead && (
                  <button
                    onClick={() => markAlertRead(a.patient.id, a.id)}
                    style={{
                      background: "#f1f5f9", color: "#475569",
                      padding: "6px 12px", borderRadius: 8, fontSize: 12, fontWeight: 600,
                      border: "none", cursor: "pointer", transition: "all 0.15s",
                    }}
                    onMouseEnter={e => { e.currentTarget.style.background = "#e2e8f0"; }}
                    onMouseLeave={e => { e.currentTarget.style.background = "#f1f5f9"; }}
                  >
                    ✓ Mark Read
                  </button>
                )}
                <button
                  onClick={() => navigate(`/patients/${a.patient.id}`)}
                  style={{
                    background: "#eff6ff", color: "#1e40af",
                    padding: "6px 12px", borderRadius: 8, fontSize: 12, fontWeight: 600,
                    border: "none", cursor: "pointer",
                  }}
                >
                  View Patient →
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
