import type { TabId } from "../types";
import { useDashboard } from "../context/DashboardContext";
import { useAuth } from "../context/AuthContext";
import { StatCard } from "../components/StatCard";
import { ComplianceRing } from "../components/ComplianceRing";
import { Sparkline } from "../components/Sparkline";
import { complianceColor, severityColor, severityBg } from "../data/helpers";

interface OverviewPageProps {
  setActiveTab: (tab: TabId) => void;
  allAlerts: ReturnType<typeof import("../context/DashboardContext")["useDashboard"]>["patients"][number]["alerts"] & { patient: any }[];
  unreadCount: number;
}

export function OverviewPage({ setActiveTab, allAlerts, unreadCount }: {
  setActiveTab: (tab: TabId) => void;
  allAlerts: any[];
  unreadCount: number;
}) {
  const { patients, setSelectedPatient } = useDashboard();
  const { doctor } = useAuth();

  const avgCompliance = Math.round(patients.reduce((s, p) => s + p.compliance, 0) / patients.length);
  const criticalCount = allAlerts.filter((a: any) => a.severity === "high" && !a.isRead).length;

  const firstName = doctor?.name?.split(" ").slice(-1)[0] ?? "Doctor";

  return (
    <div>
      {/* Greeting */}
      <div style={{ marginBottom: 24 }}>
        <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>
          Good morning, Dr. {firstName} 👋
        </h1>
        <p style={{ color: "#64748b", fontSize: 14, marginTop: 3 }}>
          Wednesday, March 18, 2026 · {patients.length} patients monitored
        </p>
      </div>

      {/* Stats row */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 16, marginBottom: 24 }}>
        <StatCard label="Total Patients" value={patients.length} sub="Under monitoring" color="#1e40af" bg="#eff6ff" icon="👥" />
        <StatCard label="Critical Alerts" value={criticalCount} sub="Needs attention" color="#dc2626" bg="#fef2f2" icon="🚨" />
        <StatCard label="Avg Compliance" value={`${avgCompliance}%`} sub="This week" color="#059669" bg="#ecfdf5" icon="📊" />
        <StatCard label="Appointments" value={3} sub="This week" color="#7c3aed" bg="#f5f3ff" icon="📅" />
      </div>

      {/* Two-column layout */}
      <div style={{ display: "grid", gridTemplateColumns: "1.2fr 0.8fr", gap: 20 }}>

        {/* Patient list */}
        <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", overflow: "hidden" }}>
          <div style={{ padding: "16px 20px", borderBottom: "1px solid #f1f5f9", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
            <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a" }}>Patient Overview</div>
            <button onClick={() => setActiveTab("patients")} style={{
              background: "#eff6ff", color: "#1e40af",
              fontSize: 12, fontWeight: 700, padding: "5px 12px", borderRadius: 8,
              border: "none", cursor: "pointer",
            }}>View All →</button>
          </div>
          <div>
            {patients.map((p, i) => {
              const highAlerts = p.alerts.filter(a => a.severity === "high" && !a.isRead).length;
              return (
                <div key={p.id}
                  onClick={() => { setSelectedPatient(p); setActiveTab("patients"); }}
                  style={{
                    padding: "14px 20px",
                    borderBottom: i < patients.length - 1 ? "1px solid #f8fafc" : "none",
                    display: "flex", alignItems: "center", gap: 14,
                    cursor: "pointer",
                    transition: "background 0.15s",
                  }}
                  onMouseEnter={e => (e.currentTarget.style.background = "#f8fafc")}
                  onMouseLeave={e => (e.currentTarget.style.background = "white")}
                >
                  <div style={{
                    width: 40, height: 40, borderRadius: "50%",
                    background: `linear-gradient(135deg, ${complianceColor(p.compliance)}22, ${complianceColor(p.compliance)}44)`,
                    border: `2px solid ${complianceColor(p.compliance)}`,
                    display: "flex", alignItems: "center", justifyContent: "center",
                    fontSize: 12, fontWeight: 800, color: complianceColor(p.compliance),
                    flexShrink: 0,
                  }}>{p.avatar}</div>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                      <span style={{ fontSize: 14, fontWeight: 700, color: "#0f172a" }}>{p.name}</span>
                      {highAlerts > 0 && (
                        <span style={{
                          background: "#fef2f2", color: "#dc2626",
                          fontSize: 10, fontWeight: 700, padding: "1px 7px", borderRadius: 10,
                        }}>⚠ {highAlerts} alert{highAlerts > 1 ? "s" : ""}</span>
                      )}
                    </div>
                    <div style={{ fontSize: 12, color: "#64748b", marginTop: 2 }}>
                      {p.age}y · {p.conditions[0]}{p.conditions.length > 1 ? ` +${p.conditions.length - 1}` : ""}
                    </div>
                  </div>
                  <ComplianceRing score={p.compliance} size={44} />
                  <Sparkline data={p.weeklyTrend} color={complianceColor(p.compliance)} />
                </div>
              );
            })}
          </div>
        </div>

        {/* Right column */}
        <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>

          {/* Recent alerts */}
          <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", overflow: "hidden" }}>
            <div style={{ padding: "16px 20px", borderBottom: "1px solid #f1f5f9", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
              <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a" }}>Recent Alerts</div>
              <button onClick={() => setActiveTab("alerts")} style={{
                background: "#fef2f2", color: "#dc2626",
                fontSize: 12, fontWeight: 700, padding: "5px 12px", borderRadius: 8,
                border: "none", cursor: "pointer",
              }}>{unreadCount} unread</button>
            </div>
            <div>
              {allAlerts.filter((a: any) => !a.isRead).slice(0, 5).map((a: any) => (
                <div key={a.id} style={{
                  padding: "12px 16px",
                  borderBottom: "1px solid #f8fafc",
                  display: "flex", gap: 10, alignItems: "flex-start",
                  background: `${severityBg(a.severity)}80`,
                }}>
                  <div style={{
                    width: 8, height: 8, borderRadius: "50%",
                    background: severityColor(a.severity),
                    marginTop: 5, flexShrink: 0,
                  }} />
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: 12, fontWeight: 700, color: "#0f172a" }}>{a.patient.name}</div>
                    <div style={{ fontSize: 11, color: "#64748b", marginTop: 1, lineHeight: 1.4 }}>{a.message}</div>
                  </div>
                  <div style={{ fontSize: 10, color: "#94a3b8", whiteSpace: "nowrap" }}>{a.time}</div>
                </div>
              ))}
              {allAlerts.filter((a: any) => !a.isRead).length === 0 && (
                <div style={{ padding: "20px 16px", textAlign: "center", color: "#94a3b8", fontSize: 13 }}>
                  🎉 All alerts cleared
                </div>
              )}
            </div>
          </div>

          {/* Upcoming appointments */}
          <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
            <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a", marginBottom: 14 }}>Upcoming Appointments</div>
            {patients.map(p => (
              <div key={p.id} style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 10 }}>
                <div style={{ width: 8, height: 8, borderRadius: 2, background: "#1e40af", flexShrink: 0 }} />
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 12, fontWeight: 600, color: "#0f172a" }}>{p.name}</div>
                  <div style={{ fontSize: 11, color: "#64748b" }}>{p.nextAppt}</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
