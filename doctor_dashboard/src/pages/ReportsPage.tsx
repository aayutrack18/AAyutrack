import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useDashboard } from "../context/DashboardContext";
import { complianceColor } from "../data/helpers";
import { MOCK_REPORTS } from "../data/mockData";
import { reportService } from "../services/reportService";
import { WeeklyBar } from "../components/WeeklyBar";
import { ComplianceRing } from "../components/ComplianceRing";
import { Sparkline } from "../components/Sparkline";
import type { Report } from "../types";

// ── Inline SVG bar chart ───────────────────────────────────────────────────────
function ComplianceBarChart({ patients }: { patients: { id: string; name: string; avatar: string; compliance: number }[] }) {
  const BAR_W = 48, GAP = 28, H = 120;
  const totalW = patients.length * (BAR_W + GAP);

  return (
    <div style={{ overflowX: "auto", paddingBottom: 4 }}>
      <svg width={Math.max(totalW, 300)} height={H + 44} style={{ display: "block" }}>
        {[25, 50, 75, 100].map(v => {
          const y = H - (v / 100) * H;
          return (
            <g key={v}>
              <line x1={0} y1={y} x2={totalW} y2={y} stroke="#f1f5f9" strokeWidth="1" strokeDasharray="4 4" />
              <text x={-4} y={y + 4} textAnchor="end" fontSize="9" fill="#94a3b8">{v}%</text>
            </g>
          );
        })}
        {patients.map((p, i) => {
          const x     = i * (BAR_W + GAP) + GAP / 2;
          const barH  = (p.compliance / 100) * H;
          const color = complianceColor(p.compliance);
          return (
            <g key={p.id}>
              <rect x={x} y={0} width={BAR_W} height={H} fill="#f8fafc" rx={6} />
              <rect x={x} y={H - barH} width={BAR_W} height={barH} fill={color} rx={6} opacity={0.85} />
              <text x={x + BAR_W / 2} y={H - barH - 6} textAnchor="middle" fontSize="11" fontWeight="700" fill={color}>
                {p.compliance}%
              </text>
              <text x={x + BAR_W / 2} y={H + 16} textAnchor="middle" fontSize="11" fontWeight="700" fill="#475569">
                {p.avatar}
              </text>
              <text x={x + BAR_W / 2} y={H + 30} textAnchor="middle" fontSize="9" fill="#94a3b8">
                {p.name.split(" ")[0]}
              </text>
            </g>
          );
        })}
      </svg>
    </div>
  );
}

// ── Report type badge ──────────────────────────────────────────────────────────
const TYPE_COLORS: Record<Report["type"], { bg: string; color: string }> = {
  Compliance: { bg: "#eff6ff", color: "#1e40af" },
  Vitals:     { bg: "#fdf4ff", color: "#7c3aed" },
  Adherence:  { bg: "#ecfdf5", color: "#059669" },
  Monitoring: { bg: "#fef2f2", color: "#dc2626" },
  Summary:    { bg: "#fffbeb", color: "#d97706" },
};

export function ReportsPage() {
  const navigate  = useNavigate();
  const { patients } = useDashboard();
  const [selectedId,  setSelectedId]  = useState<string | null>(null);
  const [downloading, setDownloading] = useState<string | null>(null);
  const [downloaded,  setDownloaded]  = useState<Set<string>>(new Set());
  const [typeFilter,  setTypeFilter]  = useState<Report["type"] | "All">("All");

  const avgCompliance   = Math.round(patients.reduce((s, p) => s + p.compliance, 0) / patients.length);
  const highRisk        = patients.filter(p => p.compliance < 70).length;
  const allMeds         = patients.flatMap(p => p.medicines);
  const avgAdherence    = Math.round(allMeds.reduce((s, m) => s + m.adherence, 0) / allMeds.length);

  const selectedReport  = MOCK_REPORTS.find(r => r.id === selectedId) ?? null;
  const selectedPatient = selectedReport?.patientId
    ? patients.find(p => p.id === selectedReport.patientId) ?? null
    : null;

  const filteredReports = MOCK_REPORTS.filter(r =>
    typeFilter === "All" || r.type === typeFilter
  );

  const handleDownload = async (reportId: string) => {
    setDownloading(reportId);
    const result = await reportService.download(reportId);
    setDownloading(null);
    if (result.success) {
      setDownloaded(prev => new Set([...prev, reportId]));
      setTimeout(() => setDownloaded(prev => {
        const next = new Set(prev);
        next.delete(reportId);
        return next;
      }), 3000);
    }
  };

  return (
    <div>
      {/* Header */}
      <div style={{ marginBottom: 24 }}>
        <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>
          Reports & Analytics
        </h1>
        <p style={{ color: "#64748b", fontSize: 14, marginTop: 4 }}>
          Compliance and monitoring summary for your patient cohort
        </p>
      </div>

      {/* KPI row */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 16, marginBottom: 24 }}>
        {[
          { label: "Avg Compliance",    value: `${avgCompliance}%`, sub: "All patients this week", color: "#1e40af", icon: "📊" },
          { label: "High Risk Patients", value: highRisk,            sub: "Compliance < 70%",       color: "#dc2626", icon: "⚠️" },
          { label: "Medicine Adherence", value: `${avgAdherence}%`,  sub: "Avg across all meds",    color: "#059669", icon: "💊" },
        ].map((s, i) => (
          <div key={i} style={{
            background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20,
          }}>
            <div style={{ fontSize: 22, marginBottom: 8 }}>{s.icon}</div>
            <div style={{ fontSize: 34, fontWeight: 900, color: s.color }}>{s.value}</div>
            <div style={{ fontSize: 14, fontWeight: 700, color: "#0f172a", marginTop: 2 }}>{s.label}</div>
            <div style={{ fontSize: 12, color: "#64748b", marginTop: 2 }}>{s.sub}</div>
          </div>
        ))}
      </div>

      {/* Charts row */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 20, marginBottom: 24 }}>

        {/* Compliance bar chart */}
        <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
          <div style={{ fontSize: 14, fontWeight: 700, color: "#0f172a", marginBottom: 4 }}>
            Patient Compliance
          </div>
          <div style={{ fontSize: 12, color: "#94a3b8", marginBottom: 16 }}>
            Overall compliance score per patient this week
          </div>
          <ComplianceBarChart patients={patients} />
        </div>

        {/* Per-patient rings */}
        <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
          <div style={{ fontSize: 14, fontWeight: 700, color: "#0f172a", marginBottom: 4 }}>
            Compliance At A Glance
          </div>
          <div style={{ fontSize: 12, color: "#94a3b8", marginBottom: 16 }}>
            Click a patient to view their full detail
          </div>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(2, 1fr)", gap: 16 }}>
            {patients.map(p => (
              <div
                key={p.id}
                onClick={() => navigate(`/patients/${p.id}`)}
                style={{
                  display: "flex", alignItems: "center", gap: 12,
                  padding: "10px 12px", borderRadius: 12,
                  border: "1px solid #f1f5f9", cursor: "pointer",
                  transition: "all 0.15s",
                }}
                onMouseEnter={e => { e.currentTarget.style.background = "#f8fafc"; e.currentTarget.style.borderColor = "#e2e8f0"; }}
                onMouseLeave={e => { e.currentTarget.style.background = "white"; e.currentTarget.style.borderColor = "#f1f5f9"; }}
              >
                <ComplianceRing score={p.compliance} size={48} />
                <div style={{ minWidth: 0 }}>
                  <div style={{ fontSize: 12, fontWeight: 700, color: "#0f172a", whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
                    {p.name}
                  </div>
                  <Sparkline data={p.weeklyTrend} color={complianceColor(p.compliance)} />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Compliance table */}
      <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", overflow: "hidden", marginBottom: 24 }}>
        <div style={{ padding: "16px 20px", borderBottom: "1px solid #f1f5f9", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <div style={{ fontSize: 14, fontWeight: 700, color: "#0f172a" }}>
            Patient Compliance Report · March 2026
          </div>
          <span style={{ fontSize: 12, color: "#94a3b8" }}>{patients.length} patients</span>
        </div>
        <table style={{ width: "100%", borderCollapse: "collapse" }}>
          <thead>
            <tr style={{ background: "#f8fafc" }}>
              {["Patient", "Age", "Conditions", "Compliance", "Med Adherence", "Trend", "Status"].map(h => (
                <th key={h} style={{
                  padding: "10px 16px", textAlign: "left",
                  fontSize: 10, fontWeight: 700, color: "#64748b",
                  textTransform: "uppercase", letterSpacing: 0.5,
                }}>
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {patients.map(p => {
              const avgMed = Math.round(p.medicines.reduce((s, m) => s + m.adherence, 0) / p.medicines.length);
              return (
                <tr
                  key={p.id}
                  style={{ borderTop: "1px solid #f1f5f9", cursor: "pointer" }}
                  onClick={() => navigate(`/patients/${p.id}`)}
                  onMouseEnter={e => (e.currentTarget.style.background = "#f8fafc")}
                  onMouseLeave={e => (e.currentTarget.style.background = "white")}
                >
                  <td style={{ padding: "12px 16px" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
                      <div style={{
                        width: 32, height: 32, borderRadius: "50%",
                        background: `${complianceColor(p.compliance)}22`,
                        display: "flex", alignItems: "center", justifyContent: "center",
                        fontSize: 11, fontWeight: 800, color: complianceColor(p.compliance),
                        flexShrink: 0,
                      }}>
                        {p.avatar}
                      </div>
                      <span style={{ fontSize: 13, fontWeight: 700, color: "#0f172a" }}>{p.name}</span>
                    </div>
                  </td>
                  <td style={{ padding: "12px 16px", fontSize: 13, color: "#64748b" }}>{p.age}y</td>
                  <td style={{ padding: "12px 16px" }}>
                    <div style={{ display: "flex", gap: 4, flexWrap: "wrap" }}>
                      {p.conditions.map(c => (
                        <span key={c} style={{
                          background: "#f1f5f9", color: "#475569",
                          fontSize: 10, fontWeight: 600, padding: "2px 7px", borderRadius: 10,
                        }}>
                          {c}
                        </span>
                      ))}
                    </div>
                  </td>
                  <td style={{ padding: "12px 16px" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                      <div style={{ flex: 1, height: 6, background: "#f1f5f9", borderRadius: 3, minWidth: 60 }}>
                        <div style={{ height: "100%", width: `${p.compliance}%`, background: complianceColor(p.compliance), borderRadius: 3 }} />
                      </div>
                      <span style={{ fontSize: 13, fontWeight: 800, color: complianceColor(p.compliance), minWidth: 36 }}>
                        {p.compliance}%
                      </span>
                    </div>
                  </td>
                  <td style={{ padding: "12px 16px" }}>
                    <span style={{ fontSize: 13, fontWeight: 700, color: complianceColor(avgMed) }}>{avgMed}%</span>
                  </td>
                  <td style={{ padding: "12px 16px" }}>
                    <Sparkline data={p.weeklyTrend} color={complianceColor(p.compliance)} />
                  </td>
                  <td style={{ padding: "12px 16px" }}>
                    <span style={{
                      fontSize: 11, fontWeight: 700, padding: "3px 10px", borderRadius: 20,
                      background: p.compliance >= 85 ? "#ecfdf5" : p.compliance >= 70 ? "#fffbeb" : "#fef2f2",
                      color: p.compliance >= 85 ? "#059669" : p.compliance >= 70 ? "#d97706" : "#dc2626",
                    }}>
                      {p.compliance >= 85 ? "✓ Excellent" : p.compliance >= 70 ? "~ Good" : "⚠ At Risk"}
                    </span>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      {/* Report files */}
      <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", overflow: "hidden" }}>
        <div style={{
          padding: "16px 20px", borderBottom: "1px solid #f1f5f9",
          display: "flex", justifyContent: "space-between", alignItems: "center", gap: 12, flexWrap: "wrap",
        }}>
          <div>
            <div style={{ fontSize: 14, fontWeight: 700, color: "#0f172a" }}>Generated Reports</div>
            <div style={{ fontSize: 12, color: "#94a3b8", marginTop: 2 }}>Click to preview · Download as PDF</div>
          </div>
          <div style={{ display: "flex", gap: 6 }}>
            {(["All", "Compliance", "Vitals", "Adherence", "Monitoring", "Summary"] as const).map(t => (
              <button
                key={t}
                onClick={() => setTypeFilter(t)}
                style={{
                  padding: "5px 12px", borderRadius: 20, border: "none",
                  fontSize: 11, fontWeight: 600, cursor: "pointer",
                  background: typeFilter === t ? "#1e40af" : "#f1f5f9",
                  color: typeFilter === t ? "white" : "#475569",
                  transition: "all 0.15s",
                }}
              >
                {t}
              </button>
            ))}
          </div>
        </div>

        {/* Two-column: list + preview */}
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1.4fr" }}>

          {/* Report list */}
          <div style={{ borderRight: "1px solid #f1f5f9" }}>
            {filteredReports.map(r => (
              <div
                key={r.id}
                onClick={() => setSelectedId(r.id === selectedId ? null : r.id)}
                style={{
                  padding: "14px 20px", borderBottom: "1px solid #f8fafc",
                  display: "flex", alignItems: "center", gap: 14, cursor: "pointer",
                  background: selectedId === r.id ? "#eff6ff" : "white",
                  borderLeft: selectedId === r.id ? "3px solid #1e40af" : "3px solid transparent",
                  transition: "all 0.15s",
                }}
                onMouseEnter={e => { if (selectedId !== r.id) e.currentTarget.style.background = "#f8fafc"; }}
                onMouseLeave={e => { if (selectedId !== r.id) e.currentTarget.style.background = "white"; }}
              >
                <div style={{
                  width: 36, height: 36, borderRadius: 10, flexShrink: 0,
                  background: TYPE_COLORS[r.type].bg,
                  display: "flex", alignItems: "center", justifyContent: "center",
                  fontSize: 16,
                }}>
                  📄
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 12, fontWeight: 700, color: "#0f172a", lineHeight: 1.3 }}>{r.title}</div>
                  <div style={{ display: "flex", alignItems: "center", gap: 6, marginTop: 4 }}>
                    <span style={{
                      fontSize: 10, fontWeight: 700, padding: "1px 7px", borderRadius: 20,
                      background: TYPE_COLORS[r.type].bg, color: TYPE_COLORS[r.type].color,
                    }}>
                      {r.type}
                    </span>
                    <span style={{ fontSize: 10, color: "#94a3b8" }}>{r.date}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>

          {/* Preview panel */}
          <div style={{ padding: 24 }}>
            {!selectedReport ? (
              <div style={{
                display: "flex", flexDirection: "column",
                alignItems: "center", justifyContent: "center",
                height: "100%", minHeight: 240, color: "#94a3b8",
              }}>
                <div style={{ fontSize: 44, marginBottom: 14 }}>📂</div>
                <div style={{ fontSize: 14, fontWeight: 600, color: "#475569" }}>Select a report to preview</div>
                <div style={{ fontSize: 12, marginTop: 6, textAlign: "center" }}>
                  Click any report on the left to view its summary
                </div>
              </div>
            ) : (
              <div>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 20 }}>
                  <div>
                    <div style={{
                      fontSize: 10, fontWeight: 700, padding: "2px 8px", borderRadius: 20, display: "inline-block",
                      background: TYPE_COLORS[selectedReport.type].bg, color: TYPE_COLORS[selectedReport.type].color,
                      marginBottom: 8,
                    }}>
                      {selectedReport.type}
                    </div>
                    <h3 style={{ fontSize: 15, fontWeight: 800, color: "#0f172a", lineHeight: 1.3 }}>
                      {selectedReport.title}
                    </h3>
                    <p style={{ fontSize: 12, color: "#64748b", marginTop: 4 }}>
                      {selectedReport.patient} · {selectedReport.period}
                    </p>
                  </div>
                  <button
                    onClick={() => handleDownload(selectedReport.id)}
                    disabled={downloading === selectedReport.id}
                    style={{
                      background: downloaded.has(selectedReport.id) ? "#ecfdf5"
                        : downloading === selectedReport.id ? "#f1f5f9" : "#1e40af",
                      color: downloaded.has(selectedReport.id) ? "#059669"
                        : downloading === selectedReport.id ? "#94a3b8" : "white",
                      padding: "8px 16px", borderRadius: 10, fontSize: 12, fontWeight: 700,
                      border: "none", cursor: downloading === selectedReport.id ? "not-allowed" : "pointer",
                      transition: "all 0.25s", flexShrink: 0,
                    }}
                  >
                    {downloaded.has(selectedReport.id) ? "✓ Downloaded"
                      : downloading === selectedReport.id ? "Generating…"
                      : "⬇ Download PDF"}
                  </button>
                </div>

                {/* Report preview content */}
                {selectedPatient ? (
                  <div>
                    <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16, marginBottom: 16 }}>
                      <div style={{ background: "#f8fafc", borderRadius: 10, padding: 14 }}>
                        <div style={{ fontSize: 10, fontWeight: 700, color: "#94a3b8", marginBottom: 8, textTransform: "uppercase", letterSpacing: 0.5 }}>
                          Patient
                        </div>
                        {[
                          ["Name", selectedPatient.name],
                          ["Age / Gender", `${selectedPatient.age}y · ${selectedPatient.gender}`],
                          ["Blood Group", selectedPatient.bloodGroup],
                          ["Phone", selectedPatient.phone],
                        ].map(([k, v]) => (
                          <div key={k} style={{ display: "flex", gap: 8, marginBottom: 5, fontSize: 12 }}>
                            <span style={{ color: "#64748b", minWidth: 100, flexShrink: 0 }}>{k}</span>
                            <span style={{ fontWeight: 600, color: "#0f172a" }}>{v}</span>
                          </div>
                        ))}
                      </div>
                      <div style={{ background: "#f8fafc", borderRadius: 10, padding: 14 }}>
                        <div style={{ fontSize: 10, fontWeight: 700, color: "#94a3b8", marginBottom: 8, textTransform: "uppercase", letterSpacing: 0.5 }}>
                          Compliance
                        </div>
                        <div style={{ fontSize: 36, fontWeight: 900, color: complianceColor(selectedPatient.compliance), lineHeight: 1 }}>
                          {selectedPatient.compliance}%
                        </div>
                        <div style={{ fontSize: 12, color: "#64748b", margin: "6px 0 10px" }}>
                          Overall compliance this week
                        </div>
                        <WeeklyBar data={selectedPatient.weeklyTrend} />
                      </div>
                    </div>
                    <div style={{ background: "#f8fafc", borderRadius: 10, padding: 14 }}>
                      <div style={{ fontSize: 10, fontWeight: 700, color: "#94a3b8", marginBottom: 10, textTransform: "uppercase", letterSpacing: 0.5 }}>
                        Medicine Adherence
                      </div>
                      {selectedPatient.medicines.map((m, i) => (
                        <div key={i} style={{ marginBottom: 10 }}>
                          <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 4 }}>
                            <span style={{ fontSize: 12, color: "#0f172a", fontWeight: 600 }}>{m.name} {m.dosage}</span>
                            <span style={{ fontSize: 12, fontWeight: 800, color: complianceColor(m.adherence) }}>{m.adherence}%</span>
                          </div>
                          <div style={{ height: 5, background: "#e2e8f0", borderRadius: 3 }}>
                            <div style={{ height: "100%", width: `${m.adherence}%`, background: m.color, borderRadius: 3 }} />
                          </div>
                        </div>
                      ))}
                    </div>
                    <div style={{ marginTop: 14, display: "flex", gap: 8 }}>
                      <button
                        onClick={() => navigate(`/patients/${selectedPatient.id}`)}
                        style={{
                          background: "#eff6ff", color: "#1e40af",
                          padding: "7px 14px", borderRadius: 8, fontSize: 12, fontWeight: 600,
                          border: "none", cursor: "pointer",
                        }}
                      >
                        View Patient →
                      </button>
                    </div>
                  </div>
                ) : (
                  // Cohort summary
                  <div style={{ background: "#f8fafc", borderRadius: 10, padding: 16 }}>
                    <div style={{ fontSize: 10, fontWeight: 700, color: "#94a3b8", marginBottom: 12, textTransform: "uppercase", letterSpacing: 0.5 }}>
                      Cohort Summary
                    </div>
                    <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 12 }}>
                      {[
                        { label: "Avg Compliance", value: `${avgCompliance}%`, color: "#1e40af" },
                        { label: "High Risk",      value: highRisk,             color: "#dc2626" },
                        { label: "Med Adherence",  value: `${avgAdherence}%`,   color: "#059669" },
                      ].map(s => (
                        <div key={s.label} style={{ background: "white", borderRadius: 8, padding: 12, textAlign: "center" }}>
                          <div style={{ fontSize: 22, fontWeight: 900, color: s.color }}>{s.value}</div>
                          <div style={{ fontSize: 11, color: "#64748b", marginTop: 2 }}>{s.label}</div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
