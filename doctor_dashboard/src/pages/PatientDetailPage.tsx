import type { ReactNode } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useDashboard } from "../context/DashboardContext";
import { ComplianceRing } from "../components/ComplianceRing";
import { WeeklyBar } from "../components/WeeklyBar";
import { VitalChart } from "../components/VitalChart";
import {
  complianceColor, complianceBg, complianceLabel,
  severityColor, severityBg,
} from "../data/helpers";
import type { MetricType } from "../types";

const VITALS_CONFIG: { key: MetricType; label: string; unit: string; color: string; icon: string }[] = [
  { key: "bp",     label: "Blood Pressure", unit: "mmHg",  color: "#dc2626", icon: "🫀" },
  { key: "sugar",  label: "Blood Sugar",    unit: "mg/dL", color: "#f59e0b", icon: "🩸" },
  { key: "heart",  label: "Heart Rate",     unit: "bpm",   color: "#ec4899", icon: "💓" },
  { key: "oxygen", label: "SpO₂",           unit: "%",     color: "#14b8a6", icon: "🫁" },
  { key: "weight", label: "Weight",         unit: "kg",    color: "#6366f1", icon: "⚖️" },
  { key: "temp",   label: "Temperature",    unit: "°C",    color: "#f97316", icon: "🌡️" },
];

// ── Reusable section card ─────────────────────────────────────────────────────
function SectionCard({ title, children }: { title: string; children: ReactNode }) {
  return (
    <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", overflow: "hidden" }}>
      <div style={{ padding: "14px 20px", borderBottom: "1px solid #f1f5f9" }}>
        <span style={{ fontSize: 14, fontWeight: 700, color: "#0f172a" }}>{title}</span>
      </div>
      <div style={{ padding: 20 }}>{children}</div>
    </div>
  );
}

export function PatientDetailPage() {
  const { id }   = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { patients, markAlertRead } = useDashboard();

  const patient = patients.find(p => p.id === id);

  // ── Not found state ───────────────────────────────────────────────────────
  if (!patient) {
    return (
      <div style={{
        display: "flex", flexDirection: "column",
        alignItems: "center", justifyContent: "center",
        minHeight: "60vh", textAlign: "center",
      }}>
        <div style={{ fontSize: 64, marginBottom: 20 }}>🔍</div>
        <h2 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", marginBottom: 8 }}>
          Patient Not Found
        </h2>
        <p style={{ color: "#64748b", fontSize: 14, marginBottom: 28 }}>
          No patient with ID{" "}
          <code style={{ background: "#f1f5f9", padding: "2px 8px", borderRadius: 4, fontSize: 12, color: "#1e40af" }}>
            {id}
          </code>{" "}
          exists in your roster.
        </p>
        <button
          onClick={() => navigate("/patients")}
          style={{
            background: "#1e40af", color: "white",
            padding: "10px 24px", borderRadius: 10,
            fontSize: 14, fontWeight: 700, border: "none", cursor: "pointer",
            boxShadow: "0 4px 12px rgba(30,64,175,0.3)",
          }}
        >
          ← Back to Patients
        </button>
      </div>
    );
  }

  const unreadAlerts    = patient.alerts.filter(a => !a.isRead);
  const avgMedAdherence = Math.round(
    patient.medicines.reduce((s, m) => s + m.adherence, 0) / patient.medicines.length
  );

  return (
    <div>
      {/* Breadcrumb nav */}
      <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 20, fontSize: 13, color: "#64748b" }}>
        <button
          onClick={() => navigate("/patients")}
          style={{
            background: "none", border: "none", cursor: "pointer",
            color: "#1e40af", fontWeight: 600, fontSize: 13, padding: 0,
            display: "flex", alignItems: "center", gap: 4,
          }}
        >
          ← Patients
        </button>
        <span style={{ color: "#cbd5e1" }}>/</span>
        <span style={{ fontWeight: 600, color: "#0f172a" }}>{patient.name}</span>
      </div>

      {/* Hero banner */}
      <div style={{
        background: "linear-gradient(135deg, #1e40af 0%, #1e3a8a 50%, #0369a1 100%)",
        borderRadius: 20, padding: "28px 32px", color: "white",
        marginBottom: 24, display: "flex", gap: 24, alignItems: "center", flexWrap: "wrap",
      }}>
        {/* Avatar */}
        <div style={{
          width: 76, height: 76, borderRadius: "50%", flexShrink: 0,
          background: "rgba(255,255,255,0.18)",
          border: "2.5px solid rgba(255,255,255,0.4)",
          display: "flex", alignItems: "center", justifyContent: "center",
          fontSize: 26, fontWeight: 900,
        }}>
          {patient.avatar}
        </div>

        {/* Info */}
        <div style={{ flex: 1, minWidth: 220 }}>
          <h2 style={{ fontSize: 24, fontWeight: 900, marginBottom: 4 }}>{patient.name}</h2>
          <p style={{ opacity: 0.8, fontSize: 13 }}>
            {patient.age}y · {patient.gender} · {patient.bloodGroup} · {patient.conditions.join(", ")}
          </p>
          <div style={{ display: "flex", gap: 18, marginTop: 12, fontSize: 12, opacity: 0.85, flexWrap: "wrap" }}>
            <span>📞 {patient.phone}</span>
            <span>📅 Next: {patient.nextAppt}</span>
            <span>🕐 Active: {patient.lastActive}</span>
          </div>
        </div>

        {/* Compliance score */}
        <div style={{ textAlign: "center", flexShrink: 0 }}>
          <div style={{ fontSize: 44, fontWeight: 900, lineHeight: 1 }}>{patient.compliance}%</div>
          <div style={{ fontSize: 11, opacity: 0.7, marginTop: 4 }}>Overall Compliance</div>
          <div style={{
            marginTop: 8, padding: "3px 14px",
            background: `rgba(${patient.compliance >= 85 ? "16,185,129" : patient.compliance >= 70 ? "245,158,11" : "239,68,68"},0.3)`,
            borderRadius: 20, fontSize: 11, fontWeight: 700, display: "inline-block",
          }}>
            {complianceLabel(patient.compliance)}
          </div>
        </div>

        {/* CTA buttons */}
        <div style={{ display: "flex", flexDirection: "column", gap: 8, flexShrink: 0 }}>
          <button
            onClick={() => navigate("/messages", { state: { patientId: patient.id } })}
            style={{
              background: "rgba(255,255,255,0.18)", color: "white",
              padding: "8px 18px", borderRadius: 10, fontSize: 12, fontWeight: 700,
              border: "1px solid rgba(255,255,255,0.3)", cursor: "pointer",
              transition: "background 0.15s",
            }}
            onMouseEnter={e => (e.currentTarget.style.background = "rgba(255,255,255,0.28)")}
            onMouseLeave={e => (e.currentTarget.style.background = "rgba(255,255,255,0.18)")}
          >
            💬 Message
          </button>
          <button
            onClick={() => navigate("/reports")}
            style={{
              background: "white", color: "#1e40af",
              padding: "8px 18px", borderRadius: 10, fontSize: 12, fontWeight: 700,
              border: "none", cursor: "pointer",
            }}
          >
            📋 Reports
          </button>
        </div>
      </div>

      {/* Summary KPI strip */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 14, marginBottom: 24 }}>
        {[
          {
            label: "Overall Compliance", value: `${patient.compliance}%`,
            color: complianceColor(patient.compliance), bg: complianceBg(patient.compliance), icon: "📊",
          },
          {
            label: "Med Adherence", value: `${avgMedAdherence}%`,
            color: complianceColor(avgMedAdherence), bg: complianceBg(avgMedAdherence), icon: "💊",
          },
          {
            label: "Active Alerts", value: unreadAlerts.length,
            color: unreadAlerts.length > 0 ? "#dc2626" : "#059669",
            bg: unreadAlerts.length > 0 ? "#fef2f2" : "#ecfdf5", icon: "🔔",
          },
          {
            label: "Medicines", value: patient.medicines.length,
            color: "#1e40af", bg: "#eff6ff", icon: "🏥",
          },
        ].map((s, i) => (
          <div key={i} style={{
            background: "white", borderRadius: 14,
            border: "1px solid #e2e8f0", padding: "16px 18px",
          }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 8 }}>
              <span style={{ fontSize: 20 }}>{s.icon}</span>
              <span style={{
                fontSize: 10, fontWeight: 700, padding: "2px 8px",
                borderRadius: 20, background: s.bg, color: s.color,
              }}>
                {s.label}
              </span>
            </div>
            <div style={{ fontSize: 28, fontWeight: 900, color: s.color, lineHeight: 1 }}>{s.value}</div>
          </div>
        ))}
      </div>

      {/* Main content — two columns */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 20 }}>

        {/* LEFT: Vitals */}
        <SectionCard title="Vital Signs">
          {VITALS_CONFIG.map((v, i) => {
            const readings = patient.vitals[v.key];
            if (!readings.length) return null;
            return (
              <div key={v.key} style={{ marginBottom: i < VITALS_CONFIG.length - 1 ? 22 : 0 }}>
                <div style={{
                  display: "flex", alignItems: "center", gap: 6,
                  fontSize: 12, fontWeight: 700, color: v.color, marginBottom: 8,
                }}>
                  <span>{v.icon}</span>
                  <span>{v.label}</span>
                </div>
                <VitalChart readings={readings} color={v.color} unit={v.unit} />
                {i < VITALS_CONFIG.length - 1 && (
                  <div style={{ borderBottom: "1px solid #f1f5f9", marginTop: 14 }} />
                )}
              </div>
            );
          })}
        </SectionCard>

        {/* RIGHT: Medicine + Alerts + Trend + Compliance */}
        <div style={{ display: "flex", flexDirection: "column", gap: 18 }}>

          {/* Medicines */}
          <SectionCard title="Medicine Schedule">
            {patient.medicines.map((m, i) => (
              <div key={i} style={{ marginBottom: i < patient.medicines.length - 1 ? 16 : 0 }}>
                <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 6 }}>
                  <div>
                    <div style={{ fontSize: 13, fontWeight: 700, color: "#0f172a" }}>{m.name}</div>
                    <div style={{ fontSize: 11, color: "#64748b" }}>{m.dosage} · {m.frequency}</div>
                  </div>
                  <span style={{ fontSize: 15, fontWeight: 800, color: complianceColor(m.adherence) }}>
                    {m.adherence}%
                  </span>
                </div>
                <div style={{ height: 6, background: "#f1f5f9", borderRadius: 3, overflow: "hidden" }}>
                  <div style={{
                    height: "100%", width: `${m.adherence}%`,
                    background: m.color, borderRadius: 3,
                    transition: "width 0.8s ease",
                  }} />
                </div>
              </div>
            ))}
          </SectionCard>

          {/* Alerts */}
          <SectionCard title={`Active Alerts${unreadAlerts.length > 0 ? ` (${unreadAlerts.length} unread)` : ""}`}>
            {patient.alerts.length === 0 ? (
              <div style={{ textAlign: "center", padding: "12px 0", color: "#94a3b8", fontSize: 13 }}>
                🎉 No alerts — patient is stable
              </div>
            ) : (
              patient.alerts.map(a => (
                <div key={a.id} style={{
                  padding: "10px 12px", borderRadius: 10,
                  background: severityBg(a.severity),
                  border: `1px solid ${severityColor(a.severity)}22`,
                  marginBottom: 8, opacity: a.isRead ? 0.5 : 1,
                  transition: "opacity 0.2s",
                }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
                    <div style={{ flex: 1 }}>
                      <div style={{ fontSize: 11, fontWeight: 700, color: severityColor(a.severity), marginBottom: 2 }}>
                        {a.type} · {a.severity.toUpperCase()}{a.isRead ? " · Read" : ""}
                      </div>
                      <div style={{ fontSize: 12, color: "#475569", lineHeight: 1.45 }}>{a.message}</div>
                      <div style={{ fontSize: 10, color: "#94a3b8", marginTop: 4 }}>{a.time}</div>
                    </div>
                    {!a.isRead && (
                      <button
                        onClick={() => markAlertRead(patient.id, a.id)}
                        style={{
                          background: severityColor(a.severity), color: "white",
                          fontSize: 10, fontWeight: 700, padding: "3px 8px",
                          borderRadius: 6, marginLeft: 8, flexShrink: 0,
                          border: "none", cursor: "pointer",
                        }}
                      >
                        ✓ Read
                      </button>
                    )}
                  </div>
                </div>
              ))
            )}
          </SectionCard>

          {/* Weekly adherence trend */}
          <SectionCard title="Weekly Adherence Trend">
            <WeeklyBar data={patient.weeklyTrend} />
            <div style={{ display: "flex", gap: 14, marginTop: 14, flexWrap: "wrap" }}>
              {[
                { color: "#10b981", label: "≥90% Excellent" },
                { color: "#f59e0b", label: "60–89% Good" },
                { color: "#ef4444", label: "<60% Poor" },
              ].map(l => (
                <div key={l.label} style={{ display: "flex", alignItems: "center", gap: 5 }}>
                  <div style={{ width: 8, height: 8, borderRadius: 2, background: l.color, flexShrink: 0 }} />
                  <span style={{ fontSize: 10, color: "#94a3b8" }}>{l.label}</span>
                </div>
              ))}
            </div>
          </SectionCard>

          {/* Compliance ring + assessment */}
          <SectionCard title="Compliance Assessment">
            <div style={{ display: "flex", alignItems: "center", gap: 20 }}>
              <ComplianceRing score={patient.compliance} size={80} />
              <div>
                <div style={{ fontSize: 20, fontWeight: 900, color: complianceColor(patient.compliance) }}>
                  {complianceLabel(patient.compliance)}
                </div>
                <div style={{ fontSize: 12, color: "#64748b", marginTop: 6, lineHeight: 1.5, maxWidth: 200 }}>
                  {patient.compliance >= 85
                    ? "Patient is consistently following their care plan."
                    : patient.compliance >= 70
                    ? "Minor adherence gaps detected — monitor closely."
                    : "Significant adherence issues — clinical intervention advised."}
                </div>
              </div>
            </div>
          </SectionCard>

        </div>
      </div>
    </div>
  );
}
