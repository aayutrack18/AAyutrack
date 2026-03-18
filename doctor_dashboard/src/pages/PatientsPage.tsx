import type { TabId, MetricType } from "../types";
import { useDashboard } from "../context/DashboardContext";
import { ComplianceRing } from "../components/ComplianceRing";
import { WeeklyBar } from "../components/WeeklyBar";
import { VitalChart } from "../components/VitalChart";
import { complianceColor, severityColor, severityBg } from "../data/helpers";

interface PatientsPageProps {
  setActiveTab: (tab: TabId) => void;
}

export function PatientsPage({ setActiveTab }: PatientsPageProps) {
  const { patients, selectedPatient, setSelectedPatient, searchQuery, setSearchQuery, markAlertRead } = useDashboard();

  const filteredPatients = patients.filter(p =>
    p.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    p.conditions.some(c => c.toLowerCase().includes(searchQuery.toLowerCase()))
  );

  return (
    <div>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 20 }}>
        <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>
          {selectedPatient ? selectedPatient.name : "Patients"}
        </h1>
        {selectedPatient && (
          <button onClick={() => setSelectedPatient(null)} style={{
            background: "#f1f5f9", color: "#475569",
            padding: "8px 16px", borderRadius: 8, fontSize: 13, fontWeight: 600,
            border: "none", cursor: "pointer",
          }}>← Back to List</button>
        )}
      </div>

      {!selectedPatient ? (
        <div>
          {/* Search */}
          <div style={{ marginBottom: 16 }}>
            <input
              value={searchQuery}
              onChange={e => setSearchQuery(e.target.value)}
              placeholder="Search by name or condition..."
              style={{
                width: "100%", maxWidth: 400,
                padding: "10px 16px", borderRadius: 10,
                border: "1px solid #e2e8f0", fontSize: 13,
                outline: "none", background: "white",
                boxShadow: "0 1px 3px rgba(0,0,0,0.05)",
              }}
              onFocus={e => (e.target.style.borderColor = "#1e40af")}
              onBlur={e => (e.target.style.borderColor = "#e2e8f0")}
            />
          </div>

          <div style={{ display: "grid", gridTemplateColumns: "repeat(2, 1fr)", gap: 16 }}>
            {filteredPatients.map(p => {
              const critical = p.alerts.filter(a => a.severity === "high" && !a.isRead).length;
              return (
                <div key={p.id}
                  onClick={() => setSelectedPatient(p)}
                  style={{
                    background: "white", borderRadius: 16,
                    border: `1px solid ${critical > 0 ? "#fecaca" : "#e2e8f0"}`,
                    padding: 20, cursor: "pointer",
                    transition: "all 0.2s",
                    boxShadow: critical > 0 ? "0 0 0 3px #fef2f2" : "0 1px 4px rgba(0,0,0,0.04)",
                  }}
                  onMouseEnter={e => (e.currentTarget.style.transform = "translateY(-2px)")}
                  onMouseLeave={e => (e.currentTarget.style.transform = "none")}
                >
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 14 }}>
                    <div style={{ display: "flex", gap: 12, alignItems: "center" }}>
                      <div style={{
                        width: 48, height: 48, borderRadius: "50%",
                        background: `linear-gradient(135deg, ${complianceColor(p.compliance)}22, ${complianceColor(p.compliance)}44)`,
                        border: `2px solid ${complianceColor(p.compliance)}`,
                        display: "flex", alignItems: "center", justifyContent: "center",
                        fontSize: 14, fontWeight: 800, color: complianceColor(p.compliance),
                      }}>{p.avatar}</div>
                      <div>
                        <div style={{ fontSize: 16, fontWeight: 800, color: "#0f172a" }}>{p.name}</div>
                        <div style={{ fontSize: 12, color: "#64748b" }}>{p.age}y · {p.gender} · {p.bloodGroup}</div>
                      </div>
                    </div>
                    <ComplianceRing score={p.compliance} size={52} />
                  </div>

                  <div style={{ display: "flex", flexWrap: "wrap", gap: 6, marginBottom: 14 }}>
                    {p.conditions.map(c => (
                      <span key={c} style={{
                        background: "#f1f5f9", color: "#475569",
                        fontSize: 11, fontWeight: 600, padding: "3px 10px", borderRadius: 20,
                      }}>{c}</span>
                    ))}
                  </div>

                  <div style={{ marginBottom: 14 }}>
                    <div style={{ fontSize: 11, color: "#94a3b8", marginBottom: 4, fontWeight: 600 }}>WEEKLY ADHERENCE</div>
                    <WeeklyBar data={p.weeklyTrend} />
                  </div>

                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", fontSize: 12, color: "#64748b" }}>
                    <span>Last active: {p.lastActive}</span>
                    {critical > 0 ? (
                      <span style={{
                        background: "#fef2f2", color: "#dc2626",
                        fontSize: 11, fontWeight: 700, padding: "3px 10px", borderRadius: 20,
                      }}>⚠ {critical} critical</span>
                    ) : (
                      <span style={{
                        background: "#ecfdf5", color: "#059669",
                        fontSize: 11, fontWeight: 700, padding: "3px 10px", borderRadius: 20,
                      }}>✓ Stable</span>
                    )}
                  </div>
                </div>
              );
            })}
          </div>

          {filteredPatients.length === 0 && (
            <div style={{ textAlign: "center", padding: "60px 0", color: "#94a3b8" }}>
              <div style={{ fontSize: 40, marginBottom: 12 }}>🔍</div>
              <div style={{ fontSize: 16, fontWeight: 700, color: "#475569" }}>No patients found</div>
              <div style={{ fontSize: 13, marginTop: 4 }}>Try a different name or condition</div>
            </div>
          )}
        </div>
      ) : (
        /* ── PATIENT DETAIL ── */
        <div>
          {/* Header card */}
          <div style={{
            background: "linear-gradient(135deg, #1e40af 0%, #1e3a8a 50%, #06b6d4 100%)",
            borderRadius: 20, padding: 28, color: "white", marginBottom: 20,
            display: "flex", gap: 24, alignItems: "center",
          }}>
            <div style={{
              width: 72, height: 72, borderRadius: "50%",
              background: "rgba(255,255,255,0.2)",
              display: "flex", alignItems: "center", justifyContent: "center",
              fontSize: 24, fontWeight: 900, border: "2px solid rgba(255,255,255,0.4)",
            }}>{selectedPatient.avatar}</div>

            <div style={{ flex: 1 }}>
              <h2 style={{ fontSize: 22, fontWeight: 900 }}>{selectedPatient.name}</h2>
              <p style={{ opacity: 0.8, fontSize: 13, marginTop: 2 }}>
                {selectedPatient.age}y · {selectedPatient.gender} · {selectedPatient.bloodGroup} · {selectedPatient.conditions.join(", ")}
              </p>
              <div style={{ display: "flex", gap: 16, marginTop: 10, fontSize: 12, opacity: 0.85 }}>
                <span>📞 {selectedPatient.phone}</span>
                <span>📅 Next: {selectedPatient.nextAppt}</span>
                <span>🕐 Active: {selectedPatient.lastActive}</span>
              </div>
            </div>

            <div style={{ textAlign: "center" }}>
              <div style={{ fontSize: 40, fontWeight: 900 }}>{selectedPatient.compliance}%</div>
              <div style={{ fontSize: 11, opacity: 0.8 }}>Compliance</div>
              <div style={{
                marginTop: 6, padding: "3px 12px",
                background: `rgba(${selectedPatient.compliance >= 85 ? "16,185,129" : selectedPatient.compliance >= 70 ? "245,158,11" : "239,68,68"},0.3)`,
                borderRadius: 20, fontSize: 11, fontWeight: 700,
              }}>
                {selectedPatient.compliance >= 85 ? "Excellent" : selectedPatient.compliance >= 70 ? "Good" : "Needs Attention"}
              </div>
            </div>

            <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
              <button onClick={() => setActiveTab("messages")} style={{
                background: "rgba(255,255,255,0.2)", color: "white",
                padding: "8px 16px", borderRadius: 10, fontSize: 12, fontWeight: 700,
                border: "1px solid rgba(255,255,255,0.3)", cursor: "pointer",
              }}>💬 Message</button>
              <button onClick={() => setActiveTab("reports")} style={{
                background: "white", color: "#1e40af",
                padding: "8px 16px", borderRadius: 10, fontSize: 12, fontWeight: 700,
                border: "none", cursor: "pointer",
              }}>📋 Report</button>
            </div>
          </div>

          {/* Content grid */}
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 20 }}>

            {/* Vitals */}
            <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
              <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a", marginBottom: 16 }}>Vital Signs</div>
              {([
                { key: "bp", label: "Blood Pressure", unit: "mmHg", color: "#dc2626" },
                { key: "sugar", label: "Blood Sugar", unit: "mg/dL", color: "#f59e0b" },
                { key: "heart", label: "Heart Rate", unit: "bpm", color: "#ec4899" },
                { key: "oxygen", label: "SpO₂", unit: "%", color: "#14b8a6" },
              ] as { key: MetricType; label: string; unit: string; color: string }[]).map(v => (
                <div key={v.key} style={{ marginBottom: 20 }}>
                  <div style={{ fontSize: 12, fontWeight: 700, color: v.color, marginBottom: 8, display: "flex", alignItems: "center", gap: 6 }}>
                    <div style={{ width: 8, height: 8, borderRadius: "50%", background: v.color }} />
                    {v.label}
                  </div>
                  <VitalChart readings={selectedPatient.vitals[v.key]} color={v.color} unit={v.unit} />
                  {v.key !== "oxygen" && <div style={{ borderBottom: "1px solid #f1f5f9", marginTop: 12 }} />}
                </div>
              ))}
            </div>

            {/* Right column */}
            <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>

              {/* Medicines */}
              <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
                <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a", marginBottom: 14 }}>Medicines</div>
                {selectedPatient.medicines.map((m, i) => (
                  <div key={i} style={{ marginBottom: 14 }}>
                    <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 6 }}>
                      <div>
                        <div style={{ fontSize: 13, fontWeight: 700, color: "#0f172a" }}>{m.name}</div>
                        <div style={{ fontSize: 11, color: "#64748b" }}>{m.dosage} · {m.frequency}</div>
                      </div>
                      <span style={{
                        fontSize: 14, fontWeight: 800,
                        color: m.adherence >= 85 ? "#059669" : m.adherence >= 70 ? "#d97706" : "#dc2626",
                      }}>{m.adherence}%</span>
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
              </div>

              {/* Active alerts */}
              <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
                <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a", marginBottom: 14 }}>Active Alerts</div>
                {selectedPatient.alerts.length === 0 ? (
                  <div style={{ fontSize: 13, color: "#94a3b8", textAlign: "center", padding: "12px 0" }}>No alerts 🎉</div>
                ) : selectedPatient.alerts.map(a => (
                  <div key={a.id} style={{
                    padding: "10px 14px", borderRadius: 10,
                    background: severityBg(a.severity),
                    border: `1px solid ${severityColor(a.severity)}22`,
                    marginBottom: 8, opacity: a.isRead ? 0.6 : 1,
                  }}>
                    <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
                      <div style={{ flex: 1 }}>
                        <div style={{ fontSize: 12, fontWeight: 700, color: severityColor(a.severity) }}>
                          {a.type} · {a.severity.toUpperCase()}
                        </div>
                        <div style={{ fontSize: 12, color: "#475569", marginTop: 2, lineHeight: 1.4 }}>{a.message}</div>
                        <div style={{ fontSize: 10, color: "#94a3b8", marginTop: 4 }}>{a.time}</div>
                      </div>
                      {!a.isRead && (
                        <button
                          onClick={() => markAlertRead(selectedPatient.id, a.id)}
                          style={{
                            background: severityColor(a.severity), color: "white",
                            fontSize: 10, fontWeight: 700, padding: "3px 8px", borderRadius: 6,
                            marginLeft: 8, flexShrink: 0, border: "none", cursor: "pointer",
                          }}>✓ Read</button>
                      )}
                    </div>
                  </div>
                ))}
              </div>

              {/* Weekly trend */}
              <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
                <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a", marginBottom: 14 }}>Weekly Adherence Trend</div>
                <WeeklyBar data={selectedPatient.weeklyTrend} />
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
