import { useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { useDashboard } from "../context/DashboardContext";
import { StatCard } from "../components/StatCard";
import { ComplianceRing } from "../components/ComplianceRing";
import { Sparkline } from "../components/Sparkline";
import { complianceColor, severityColor, severityBg, getGreeting, today } from "../data/helpers";

export function OverviewPage() {
  const navigate  = useNavigate();
  const { doctor } = useAuth();
  const { patients } = useDashboard();

  const allAlerts     = patients.flatMap(p => p.alerts.map(a => ({ ...a, patient: p })));
  const unreadAlerts  = allAlerts.filter(a => !a.isRead);
  const criticalCount = unreadAlerts.filter(a => a.severity === "high").length;
  const avgCompliance = Math.round(patients.reduce((s, p) => s + p.compliance, 0) / patients.length);
  const firstName     = doctor?.name?.split(" ").slice(-1)[0] ?? "Doctor";

  return (
    <div>
      {/* Greeting */}
      <div style={{ marginBottom: 26 }}>
        <h1 style={{ fontSize: 23, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>
          {getGreeting()}, Dr. {firstName} 👋
        </h1>
        <p style={{ color: "#64748b", fontSize: 14, marginTop: 4 }}>
          {today()} &nbsp;·&nbsp; {patients.length} patients monitored
        </p>
      </div>

      {/* KPI row */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 16, marginBottom: 26 }}>
        <StatCard label="Total Patients"  value={patients.length}   sub="Under monitoring" color="#1e40af" bg="#eff6ff"  icon="👥" />
        <StatCard label="Critical Alerts" value={criticalCount}      sub="Needs attention"  color="#dc2626" bg="#fef2f2"  icon="🚨" />
        <StatCard label="Avg Compliance"  value={`${avgCompliance}%`} sub="This week"        color="#059669" bg="#ecfdf5"  icon="📊" />
        <StatCard label="Appointments"    value={3}                  sub="This week"         color="#7c3aed" bg="#f5f3ff"  icon="📅" />
      </div>

      {/* Two-column layout */}
      <div style={{ display: "grid", gridTemplateColumns: "1.25fr 0.75fr", gap: 20 }}>

        {/* Patient list */}
        <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", overflow: "hidden" }}>
          <div style={{
            padding: "16px 20px", borderBottom: "1px solid #f1f5f9",
            display: "flex", justifyContent: "space-between", alignItems: "center",
          }}>
            <span style={{ fontSize: 15, fontWeight: 700, color: "#0f172a" }}>Patient Overview</span>
            <button
              onClick={() => navigate("/patients")}
              style={{
                background: "#eff6ff", color: "#1e40af",
                fontSize: 12, fontWeight: 700, padding: "5px 12px",
                borderRadius: 8, border: "none", cursor: "pointer",
              }}
            >
              View All →
            </button>
          </div>

          <div>
            {patients.map((p, i) => {
              const high = p.alerts.filter(a => a.severity === "high" && !a.isRead).length;
              return (
                <div
                  key={p.id}
                  onClick={() => navigate(`/patients/${p.id}`)}
                  style={{
                    padding: "14px 20px",
                    borderBottom: i < patients.length - 1 ? "1px solid #f8fafc" : "none",
                    display: "flex", alignItems: "center", gap: 14,
                    cursor: "pointer", transition: "background 0.15s",
                  }}
                  onMouseEnter={e => (e.currentTarget.style.background = "#f8fafc")}
                  onMouseLeave={e => (e.currentTarget.style.background = "white")}
                >
                  <div style={{
                    width: 40, height: 40, borderRadius: "50%", flexShrink: 0,
                    background: `linear-gradient(135deg, ${complianceColor(p.compliance)}22, ${complianceColor(p.compliance)}44)`,
                    border: `2px solid ${complianceColor(p.compliance)}`,
                    display: "flex", alignItems: "center", justifyContent: "center",
                    fontSize: 12, fontWeight: 800, color: complianceColor(p.compliance),
                  }}>
                    {p.avatar}
                  </div>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                      <span style={{ fontSize: 14, fontWeight: 700, color: "#0f172a" }}>{p.name}</span>
                      {high > 0 && (
                        <span style={{
                          background: "#fef2f2", color: "#dc2626",
                          fontSize: 10, fontWeight: 700, padding: "1px 7px", borderRadius: 10,
                        }}>
                          ⚠ {high} alert{high > 1 ? "s" : ""}
                        </span>
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
            <div style={{
              padding: "16px 20px", borderBottom: "1px solid #f1f5f9",
              display: "flex", justifyContent: "space-between", alignItems: "center",
            }}>
              <span style={{ fontSize: 15, fontWeight: 700, color: "#0f172a" }}>Recent Alerts</span>
              <button
                onClick={() => navigate("/alerts")}
                style={{
                  background: "#fef2f2", color: "#dc2626",
                  fontSize: 12, fontWeight: 700, padding: "5px 12px",
                  borderRadius: 8, border: "none", cursor: "pointer",
                }}
              >
                {unreadAlerts.length} unread
              </button>
            </div>

            {unreadAlerts.length === 0 ? (
              <div style={{ padding: "24px 16px", textAlign: "center", color: "#94a3b8", fontSize: 13 }}>
                🎉 All alerts cleared
              </div>
            ) : (
              unreadAlerts.slice(0, 5).map(a => (
                <div
                  key={a.id}
                  onClick={() => navigate(`/patients/${a.patient.id}`)}
                  style={{
                    padding: "11px 16px", borderBottom: "1px solid #f8fafc",
                    display: "flex", gap: 10, alignItems: "flex-start",
                    background: `${severityBg(a.severity)}60`,
                    cursor: "pointer",
                    transition: "background 0.15s",
                  }}
                  onMouseEnter={e => (e.currentTarget.style.background = severityBg(a.severity))}
                  onMouseLeave={e => (e.currentTarget.style.background = `${severityBg(a.severity)}60`)}
                >
                  <div style={{
                    width: 8, height: 8, borderRadius: "50%",
                    background: severityColor(a.severity),
                    marginTop: 4, flexShrink: 0,
                  }} />
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: 12, fontWeight: 700, color: "#0f172a" }}>{a.patient.name}</div>
                    <div style={{ fontSize: 11, color: "#64748b", marginTop: 1, lineHeight: 1.4 }}>{a.message}</div>
                  </div>
                  <div style={{ fontSize: 10, color: "#94a3b8", whiteSpace: "nowrap", paddingTop: 2 }}>{a.time}</div>
                </div>
              ))
            )}
          </div>

          {/* Upcoming appointments */}
          <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
            <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a", marginBottom: 14 }}>
              Upcoming Appointments
            </div>
            {patients.map(p => (
              <div
                key={p.id}
                onClick={() => navigate(`/patients/${p.id}`)}
                style={{
                  display: "flex", alignItems: "center", gap: 10, marginBottom: 10,
                  cursor: "pointer", padding: "4px 0",
                }}
              >
                <div style={{
                  width: 8, height: 8, borderRadius: 2,
                  background: "#1e40af", flexShrink: 0,
                }} />
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 12, fontWeight: 600, color: "#0f172a" }}>{p.name}</div>
                  <div style={{ fontSize: 11, color: "#64748b" }}>{p.nextAppt}</div>
                </div>
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#cbd5e1" strokeWidth="2.5">
                  <path d="M9 18l6-6-6-6"/>
                </svg>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
