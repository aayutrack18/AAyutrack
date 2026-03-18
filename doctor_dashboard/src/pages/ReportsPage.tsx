import { useState } from "react";
import { useDashboard } from "../context/DashboardContext";
import { complianceColor } from "../data/helpers";
import { MOCK_REPORTS } from "../data/mockData";
import { WeeklyBar } from "../components/WeeklyBar";

export function ReportsPage() {
  const { patients } = useDashboard();
  const [selectedReport, setSelectedReport] = useState<string | null>(null);
  const [downloadMsg, setDownloadMsg] = useState<string | null>(null);

  const avgCompliance = Math.round(patients.reduce((s, p) => s + p.compliance, 0) / patients.length);
  const avgMedAdherence = Math.round(
    patients.flatMap(p => p.medicines.map(m => m.adherence)).reduce((a, b) => a + b, 0) /
    patients.flatMap(p => p.medicines).length
  );
  const highRisk = patients.filter(p => p.compliance < 70).length;

  const handleDownload = (_id: string, title: string) => {
    setDownloadMsg(`Downloading "${title}"...`);
    setTimeout(() => setDownloadMsg(null), 2500);
  };

  const typeColor: Record<string, string> = { Compliance: "#1e40af", Vitals: "#dc2626", Adherence: "#7c3aed", Monitoring: "#ec4899", Summary: "#059669" };
  const typeBg: Record<string, string> = { Compliance: "#eff6ff", Vitals: "#fef2f2", Adherence: "#f5f3ff", Monitoring: "#fdf2f8", Summary: "#ecfdf5" };
  const typeIcon: Record<string, string> = { Compliance: "📊", Vitals: "❤️", Adherence: "💊", Monitoring: "📈", Summary: "📋" };

  const BAR_H = 140;
  const barWidth = 48;
  const barGap = 20;
  const totalW = patients.length * (barWidth + barGap) + 40;

  return (
    <div>
      <div style={{ marginBottom: 24 }}>
        <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>Reports & Analytics</h1>
        <p style={{ color: "#64748b", fontSize: 14, marginTop: 3 }}>Compliance summary for your patient cohort</p>
      </div>

      {downloadMsg && (
        <div style={{
          position: "fixed", top: 80, right: 24, zIndex: 999,
          background: "#0f172a", color: "white",
          padding: "12px 20px", borderRadius: 12, fontSize: 13, fontWeight: 600,
          boxShadow: "0 8px 24px rgba(0,0,0,0.18)",
        }}>⬇ {downloadMsg}</div>
      )}

      {/* Summary stats */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 16, marginBottom: 24 }}>
        {[
          { label: "Avg Overall Compliance", value: `${avgCompliance}%`, sub: "All patients this week", color: "#1e40af", icon: "📊" },
          { label: "High Risk Patients", value: highRisk, sub: "Compliance < 70%", color: "#dc2626", icon: "⚠️" },
          { label: "Medicine Adherence", value: `${avgMedAdherence}%`, sub: "Average across all meds", color: "#059669", icon: "💊" },
        ].map((s, i) => (
          <div key={i} style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
            <div style={{ fontSize: 22, marginBottom: 8 }}>{s.icon}</div>
            <div style={{ fontSize: 34, fontWeight: 900, color: s.color }}>{s.value}</div>
            <div style={{ fontSize: 14, fontWeight: 700, color: "#0f172a", marginTop: 2 }}>{s.label}</div>
            <div style={{ fontSize: 12, color: "#64748b", marginTop: 2 }}>{s.sub}</div>
          </div>
        ))}
      </div>

      {/* Compliance Bar Chart */}
      <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 24, marginBottom: 24 }}>
        <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a", marginBottom: 20 }}>Patient Compliance Overview</div>
        <div style={{ overflowX: "auto" }}>
          <svg width={totalW} height={BAR_H + 50} style={{ display: "block", overflow: "visible" }}>
            {[25, 50, 75, 100].map(pct => {
              const y = BAR_H - (pct / 100) * BAR_H;
              return (
                <g key={pct}>
                  <line x1={20} y1={y} x2={totalW - 10} y2={y} stroke="#f1f5f9" strokeWidth="1" />
                  <text x={16} y={y + 4} textAnchor="end" fontSize="9" fill="#94a3b8" fontWeight="600">{pct}%</text>
                </g>
              );
            })}
            {patients.map((p, i) => {
              const x = 24 + i * (barWidth + barGap);
              const bh = (p.compliance / 100) * BAR_H;
              const y = BAR_H - bh;
              const color = complianceColor(p.compliance);
              return (
                <g key={p.id}>
                  <rect x={x} y={0} width={barWidth} height={BAR_H} fill="#f8fafc" rx="6" />
                  <rect x={x} y={y} width={barWidth} height={bh} fill={color} rx="6" opacity="0.9" />
                  <text x={x + barWidth / 2} y={y - 6} textAnchor="middle" fontSize="11" fill={color} fontWeight="800">{p.compliance}%</text>
                  <text x={x + barWidth / 2} y={BAR_H + 16} textAnchor="middle" fontSize="10" fill="#475569" fontWeight="600">{p.name.split(" ")[0]}</text>
                  <text x={x + barWidth / 2} y={BAR_H + 28} textAnchor="middle" fontSize="9" fill="#94a3b8">{p.name.split(" ")[1]}</text>
                </g>
              );
            })}
            <line
              x1={20} y1={BAR_H - (avgCompliance / 100) * BAR_H}
              x2={totalW - 10} y2={BAR_H - (avgCompliance / 100) * BAR_H}
              stroke="#1e40af" strokeWidth="1.5" strokeDasharray="5,4"
            />
            <text x={totalW - 8} y={BAR_H - (avgCompliance / 100) * BAR_H - 4} textAnchor="end" fontSize="9" fill="#1e40af" fontWeight="700">Avg {avgCompliance}%</text>
          </svg>
        </div>
        <div style={{ display: "flex", gap: 20, marginTop: 12, justifyContent: "center" }}>
          {[{ color: "#10b981", label: "≥85% Excellent" }, { color: "#f59e0b", label: "70–84% Good" }, { color: "#ef4444", label: "<70% At Risk" }].map(l => (
            <div key={l.label} style={{ display: "flex", alignItems: "center", gap: 6 }}>
              <div style={{ width: 10, height: 10, borderRadius: 2, background: l.color }} />
              <span style={{ fontSize: 11, color: "#64748b", fontWeight: 500 }}>{l.label}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Compliance table */}
      <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", overflow: "hidden", marginBottom: 24 }}>
        <div style={{ padding: "16px 20px", borderBottom: "1px solid #f1f5f9", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a" }}>Patient Compliance Report · March 2026</div>
          <button onClick={() => handleDownload("all", "All Patients Compliance Report")} style={{ background: "#eff6ff", color: "#1e40af", padding: "6px 14px", borderRadius: 8, fontSize: 12, fontWeight: 700, border: "none", cursor: "pointer" }}>
            ⬇ Export All
          </button>
        </div>
        <table style={{ width: "100%", borderCollapse: "collapse" }}>
          <thead>
            <tr style={{ background: "#f8fafc" }}>
              {["Patient", "Age", "Conditions", "Compliance", "Med Adherence", "Weekly Trend", "Status"].map(h => (
                <th key={h} style={{ padding: "10px 16px", textAlign: "left", fontSize: 11, fontWeight: 700, color: "#64748b", textTransform: "uppercase", letterSpacing: 0.5 }}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {patients.map(p => {
              const avgMed = Math.round(p.medicines.reduce((s, m) => s + m.adherence, 0) / p.medicines.length);
              const sc = complianceColor(p.compliance);
              const sl = p.compliance >= 85 ? "Excellent" : p.compliance >= 70 ? "Good" : "At Risk";
              const sb = p.compliance >= 85 ? "#ecfdf5" : p.compliance >= 70 ? "#fffbeb" : "#fef2f2";
              return (
                <tr key={p.id} style={{ borderTop: "1px solid #f1f5f9" }}>
                  <td style={{ padding: "12px 16px" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
                      <div style={{ width: 32, height: 32, borderRadius: "50%", background: `${sc}22`, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 11, fontWeight: 800, color: sc }}>{p.avatar}</div>
                      <span style={{ fontSize: 13, fontWeight: 700, color: "#0f172a" }}>{p.name}</span>
                    </div>
                  </td>
                  <td style={{ padding: "12px 16px", fontSize: 13, color: "#64748b" }}>{p.age}y</td>
                  <td style={{ padding: "12px 16px" }}>
                    <div style={{ display: "flex", gap: 4, flexWrap: "wrap" }}>
                      {p.conditions.map(c => <span key={c} style={{ background: "#f1f5f9", color: "#475569", fontSize: 10, fontWeight: 600, padding: "2px 7px", borderRadius: 10 }}>{c}</span>)}
                    </div>
                  </td>
                  <td style={{ padding: "12px 16px" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                      <div style={{ flex: 1, height: 6, background: "#f1f5f9", borderRadius: 3, minWidth: 60 }}>
                        <div style={{ height: "100%", width: `${p.compliance}%`, background: sc, borderRadius: 3 }} />
                      </div>
                      <span style={{ fontSize: 13, fontWeight: 800, color: sc, minWidth: 36 }}>{p.compliance}%</span>
                    </div>
                  </td>
                  <td style={{ padding: "12px 16px" }}>
                    <span style={{ fontSize: 13, fontWeight: 700, color: complianceColor(avgMed) }}>{avgMed}%</span>
                  </td>
                  <td style={{ padding: "12px 16px" }}>
                    <WeeklyBar data={p.weeklyTrend} />
                  </td>
                  <td style={{ padding: "12px 16px" }}>
                    <span style={{ background: sb, color: sc, fontSize: 11, fontWeight: 700, padding: "3px 10px", borderRadius: 20 }}>{sl}</span>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      {/* Report documents list */}
      <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", overflow: "hidden" }}>
        <div style={{ padding: "16px 20px", borderBottom: "1px solid #f1f5f9" }}>
          <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a" }}>Generated Reports</div>
        </div>
        {MOCK_REPORTS.map((r, i) => {
          const color = typeColor[r.type] || "#1e40af";
          const bg = typeBg[r.type] || "#eff6ff";
          const isSelected = selectedReport === r.id;
          return (
            <div key={r.id} style={{ padding: "16px 20px", borderBottom: i < MOCK_REPORTS.length - 1 ? "1px solid #f1f5f9" : "none", display: "flex", alignItems: "center", gap: 16, background: isSelected ? "#f8fafc" : "white", transition: "background 0.15s" }}>
              <div style={{ width: 40, height: 40, borderRadius: 10, background: bg, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0, fontSize: 18 }}>
                {typeIcon[r.type]}
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 13, fontWeight: 700, color: "#0f172a" }}>{r.title}</div>
                <div style={{ display: "flex", gap: 12, marginTop: 3, fontSize: 11, color: "#64748b" }}>
                  <span>{r.patient}</span><span>·</span><span>{r.date}</span>
                </div>
              </div>
              <span style={{ background: bg, color, fontSize: 10, fontWeight: 700, padding: "3px 10px", borderRadius: 20 }}>{r.type}</span>
              <div style={{ display: "flex", gap: 8 }}>
                <button onClick={() => setSelectedReport(isSelected ? null : r.id)} style={{ background: "#f1f5f9", color: "#475569", padding: "6px 12px", borderRadius: 8, fontSize: 12, fontWeight: 600, border: "none", cursor: "pointer" }}>
                  {isSelected ? "Close" : "Preview"}
                </button>
                <button onClick={() => handleDownload(r.id, r.title)} style={{ background: "#eff6ff", color: "#1e40af", padding: "6px 12px", borderRadius: 8, fontSize: 12, fontWeight: 600, border: "none", cursor: "pointer" }}>
                  ⬇ Download
                </button>
              </div>
            </div>
          );
        })}
      </div>

      {/* Report preview panel */}
      {selectedReport && (() => {
        const report = MOCK_REPORTS.find(r => r.id === selectedReport);
        const patient = report?.patientId ? patients.find(p => p.id === report.patientId) : null;
        if (!report) return null;
        return (
          <div style={{ marginTop: 20, background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 28 }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 24 }}>
              <div>
                <div style={{ fontSize: 18, fontWeight: 800, color: "#0f172a" }}>{report.title}</div>
                <div style={{ fontSize: 13, color: "#64748b", marginTop: 4 }}>{report.date} · {report.patient}</div>
              </div>
              <button onClick={() => handleDownload(report.id, report.title)} style={{ background: "#1e40af", color: "white", padding: "8px 18px", borderRadius: 10, fontSize: 13, fontWeight: 700, border: "none", cursor: "pointer" }}>
                ⬇ Download PDF
              </button>
            </div>

            {patient ? (
              <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 24 }}>
                <div>
                  <div style={{ fontSize: 12, fontWeight: 700, color: "#64748b", marginBottom: 12, textTransform: "uppercase", letterSpacing: 0.5 }}>Patient Info</div>
                  {[["Name", patient.name], ["Age / Gender", `${patient.age}y · ${patient.gender}`], ["Blood Group", patient.bloodGroup], ["Conditions", patient.conditions.join(", ")], ["Phone", patient.phone], ["Next Appointment", patient.nextAppt]].map(([k, v]) => (
                    <div key={k} style={{ display: "flex", gap: 12, marginBottom: 8, fontSize: 13 }}>
                      <span style={{ color: "#64748b", minWidth: 140 }}>{k}</span>
                      <span style={{ fontWeight: 600, color: "#0f172a" }}>{v}</span>
                    </div>
                  ))}
                </div>
                <div>
                  <div style={{ fontSize: 12, fontWeight: 700, color: "#64748b", marginBottom: 12, textTransform: "uppercase", letterSpacing: 0.5 }}>Compliance Summary</div>
                  <div style={{ fontSize: 48, fontWeight: 900, color: complianceColor(patient.compliance), lineHeight: 1 }}>{patient.compliance}%</div>
                  <div style={{ fontSize: 13, color: "#64748b", marginTop: 4 }}>Overall compliance this week</div>
                  <div style={{ marginTop: 16 }}>
                    <div style={{ fontSize: 11, color: "#94a3b8", marginBottom: 6, fontWeight: 600 }}>WEEKLY TREND</div>
                    <WeeklyBar data={patient.weeklyTrend} />
                  </div>
                  <div style={{ marginTop: 16 }}>
                    <div style={{ fontSize: 11, color: "#94a3b8", marginBottom: 8, fontWeight: 600 }}>MEDICINE ADHERENCE</div>
                    {patient.medicines.map((m, mi) => (
                      <div key={mi} style={{ marginBottom: 8 }}>
                        <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 3 }}>
                          <span style={{ fontSize: 12, color: "#0f172a", fontWeight: 600 }}>{m.name} {m.dosage}</span>
                          <span style={{ fontSize: 12, fontWeight: 800, color: complianceColor(m.adherence) }}>{m.adherence}%</span>
                        </div>
                        <div style={{ height: 5, background: "#f1f5f9", borderRadius: 3 }}>
                          <div style={{ height: "100%", width: `${m.adherence}%`, background: m.color, borderRadius: 3 }} />
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            ) : (
              <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 16 }}>
                {patients.map(p => (
                  <div key={p.id} style={{ background: "#f8fafc", borderRadius: 12, padding: 16, border: `1px solid ${complianceColor(p.compliance)}22` }}>
                    <div style={{ fontSize: 12, fontWeight: 800, color: "#0f172a" }}>{p.name}</div>
                    <div style={{ fontSize: 24, fontWeight: 900, color: complianceColor(p.compliance), marginTop: 4 }}>{p.compliance}%</div>
                    <div style={{ fontSize: 11, color: "#64748b", marginTop: 2 }}>{p.conditions[0]}</div>
                  </div>
                ))}
              </div>
            )}
          </div>
        );
      })()}
    </div>
  );
}
