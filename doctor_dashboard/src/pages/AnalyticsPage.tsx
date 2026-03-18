import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useDashboard } from "../context/DashboardContext";
import { complianceColor, complianceBg, complianceLabel } from "../data/helpers";
import { ComplianceRing } from "../components/ComplianceRing";
import { WeeklyBar } from "../components/WeeklyBar";

// ── Trend line chart (SVG) ────────────────────────────────────────────────────
function TrendLine({
  data, color, height = 60, showDots = true,
}: { data: number[]; color: string; height?: number; showDots?: boolean }) {
  if (data.length < 2) return null;
  const W = 100; // percentage-based via viewBox
  const min = Math.min(...data) - 5;
  const max = Math.max(...data) + 5;
  const range = max - min || 1;
  const pts = data.map((v, i) => ({
    x: (i / (data.length - 1)) * (W - 4) + 2,
    y: height - ((v - min) / range) * (height - 8) - 4,
  }));
  const pathD  = pts.map((p, i) => (i === 0 ? `M ${p.x} ${p.y}` : `L ${p.x} ${p.y}`)).join(" ");
  const areaD  = `${pathD} L ${pts[pts.length - 1].x} ${height} L ${pts[0].x} ${height} Z`;
  const gradId = `tl-${color.replace("#", "")}`;
  return (
    <svg viewBox={`0 0 ${W} ${height}`} preserveAspectRatio="none" style={{ width: "100%", height }}>
      <defs>
        <linearGradient id={gradId} x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor={color} stopOpacity="0.18" />
          <stop offset="100%" stopColor={color} stopOpacity="0" />
        </linearGradient>
      </defs>
      <path d={areaD} fill={`url(#${gradId})`} />
      <polyline points={pts.map(p => `${p.x},${p.y}`).join(" ")} fill="none" stroke={color} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" />
      {showDots && pts.map((p, i) => (
        <circle key={i} cx={p.x} cy={p.y} r="2.5" fill="white" stroke={color} strokeWidth="1.5" />
      ))}
    </svg>
  );
}

// ── Small metric tile ─────────────────────────────────────────────────────────
function MetricTile({ label, value, unit, trend, color }: {
  label: string; value: number; unit: string; trend: number[]; color: string;
}) {
  const last   = trend[trend.length - 1];
  const prev   = trend[trend.length - 2] ?? last;
  const delta  = last - prev;
  const up     = delta > 0;
  const stable = delta === 0;

  return (
    <div style={{
      background: "white", borderRadius: 14, border: "1px solid #e2e8f0",
      padding: "16px 18px", overflow: "hidden",
    }}>
      <div style={{ fontSize: 11, fontWeight: 700, color: "#94a3b8", textTransform: "uppercase", letterSpacing: 0.5, marginBottom: 6 }}>
        {label}
      </div>
      <div style={{ display: "flex", alignItems: "flex-end", gap: 8, marginBottom: 10 }}>
        <span style={{ fontSize: 26, fontWeight: 900, color: "#0f172a", lineHeight: 1 }}>{value}</span>
        <span style={{ fontSize: 12, color: "#94a3b8", marginBottom: 2 }}>{unit}</span>
        {!stable && (
          <span style={{
            fontSize: 11, fontWeight: 700,
            color: up ? "#dc2626" : "#059669",
            marginBottom: 2,
          }}>
            {up ? "↑" : "↓"} {Math.abs(delta).toFixed(1)}
          </span>
        )}
      </div>
      <TrendLine data={trend} color={color} height={44} showDots={false} />
    </div>
  );
}

// ── Cohort compliance bar ─────────────────────────────────────────────────────
function CohortBar({ value, label, color, max }: { value: number; label: string; color: string; max: number }) {
  return (
    <div style={{ marginBottom: 10 }}>
      <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 4 }}>
        <span style={{ fontSize: 12, fontWeight: 600, color: "#475569" }}>{label}</span>
        <span style={{ fontSize: 12, fontWeight: 800, color }}>{value}%</span>
      </div>
      <div style={{ height: 8, background: "#f1f5f9", borderRadius: 4, overflow: "hidden" }}>
        <div style={{
          height: "100%", width: `${(value / max) * 100}%`,
          background: color, borderRadius: 4,
          transition: "width 0.8s ease",
        }} />
      </div>
    </div>
  );
}

// ── Weekly heatmap grid ───────────────────────────────────────────────────────
function AdherenceHeatmap({ patients }: { patients: { name: string; weeklyTrend: number[] }[] }) {
  const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  return (
    <div style={{ overflowX: "auto" }}>
      <table style={{ borderCollapse: "separate", borderSpacing: 4, width: "100%" }}>
        <thead>
          <tr>
            <th style={{ width: 100, textAlign: "left", fontSize: 10, color: "#94a3b8", fontWeight: 600, paddingBottom: 4 }}>Patient</th>
            {days.map(d => (
              <th key={d} style={{ fontSize: 10, color: "#94a3b8", fontWeight: 600, textAlign: "center", paddingBottom: 4 }}>{d}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {patients.map(p => (
            <tr key={p.name}>
              <td style={{ fontSize: 11, fontWeight: 600, color: "#475569", paddingRight: 8, whiteSpace: "nowrap", paddingBottom: 4 }}>
                {p.name.split(" ")[0]}
              </td>
              {p.weeklyTrend.map((v, i) => {
                const bg = v >= 90 ? "#10b981" : v >= 60 ? "#f59e0b" : "#ef4444";
                return (
                  <td key={i} style={{ textAlign: "center", paddingBottom: 4 }}>
                    <div title={`${v}%`} style={{
                      width: "100%", minWidth: 28, height: 28, borderRadius: 6,
                      background: `${bg}${v >= 90 ? "dd" : v >= 60 ? "cc" : "bb"}`,
                      display: "flex", alignItems: "center", justifyContent: "center",
                      fontSize: 9, fontWeight: 700, color: "white",
                    }}>
                      {v}
                    </div>
                  </td>
                );
              })}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

// ── Main page ─────────────────────────────────────────────────────────────────
export function AnalyticsPage() {
  const navigate = useNavigate();
  const { patients } = useDashboard();
  const [selectedMetric, setSelectedMetric] = useState<"compliance" | "adherence" | "alerts">("compliance");

  // Aggregate stats
  const avgCompliance   = Math.round(patients.reduce((s, p) => s + p.compliance, 0) / patients.length);
  const allMeds         = patients.flatMap(p => p.medicines);
  const avgAdherence    = Math.round(allMeds.reduce((s, m) => s + m.adherence, 0) / allMeds.length);
  const totalAlerts     = patients.flatMap(p => p.alerts).filter(a => !a.isRead).length;
  const criticalAlerts  = patients.flatMap(p => p.alerts).filter(a => a.severity === "high" && !a.isRead).length;
  const stableCount     = patients.filter(p => p.compliance >= 85).length;
  const atRiskCount     = patients.filter(p => p.compliance < 70).length;

  // Simulated 7-day cohort trend (mock aggregate)
  const cohortTrend = [72, 75, 74, 78, 76, 79, avgCompliance];

  // Per-patient latest vitals for metric tiles
  const getLatestVital = (patientId: string, key: "bp" | "sugar" | "heart" | "oxygen") => {
    const p = patients.find(pt => pt.id === patientId);
    if (!p) return { value: 0, trend: [] };
    const readings = p.vitals[key];
    return {
      value: readings[readings.length - 1]?.value ?? 0,
      trend: readings.map(r => r.value),
    };
  };

  const bpTrends    = patients.map(p => ({ name: p.name, ...getLatestVital(p.id, "bp") }));
  const sugarTrends = patients.map(p => ({ name: p.name, ...getLatestVital(p.id, "sugar") }));

  const METRIC_TABS = [
    { key: "compliance" as const, label: "Compliance" },
    { key: "adherence"  as const, label: "Adherence" },
    { key: "alerts"     as const, label: "Alerts" },
  ];

  return (
    <div>
      {/* Header */}
      <div style={{ marginBottom: 26 }}>
        <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>
          Analytics
        </h1>
        <p style={{ color: "#64748b", fontSize: 14, marginTop: 4 }}>
          Cohort-wide health trends and clinical insights · {patients.length} patients
        </p>
      </div>

      {/* KPI row */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(5, 1fr)", gap: 14, marginBottom: 24 }}>
        {[
          { label: "Avg Compliance",  value: `${avgCompliance}%`,  color: complianceColor(avgCompliance), bg: complianceBg(avgCompliance), icon: "📊" },
          { label: "Avg Adherence",   value: `${avgAdherence}%`,   color: complianceColor(avgAdherence),  bg: complianceBg(avgAdherence),  icon: "💊" },
          { label: "Stable Patients", value: stableCount,           color: "#059669", bg: "#ecfdf5",       icon: "✅" },
          { label: "At Risk",         value: atRiskCount,           color: "#dc2626", bg: "#fef2f2",       icon: "⚠️" },
          { label: "Unread Alerts",   value: totalAlerts,           color: totalAlerts > 0 ? "#dc2626" : "#059669", bg: totalAlerts > 0 ? "#fef2f2" : "#ecfdf5", icon: "🔔" },
        ].map((s, i) => (
          <div key={i} style={{
            background: "white", borderRadius: 14, border: "1px solid #e2e8f0", padding: "16px 18px",
          }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 8 }}>
              <span style={{ fontSize: 18 }}>{s.icon}</span>
              <span style={{ fontSize: 10, fontWeight: 700, padding: "2px 7px", borderRadius: 20, background: s.bg, color: s.color }}>
                {s.label}
              </span>
            </div>
            <div style={{ fontSize: 26, fontWeight: 900, color: s.color }}>{s.value}</div>
          </div>
        ))}
      </div>

      {/* Cohort compliance trend + donut ring row */}
      <div style={{ display: "grid", gridTemplateColumns: "1.4fr 0.6fr", gap: 20, marginBottom: 20 }}>

        {/* Cohort trend chart */}
        <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
            <div>
              <div style={{ fontSize: 14, fontWeight: 700, color: "#0f172a" }}>Cohort Compliance Trend</div>
              <div style={{ fontSize: 12, color: "#94a3b8", marginTop: 2 }}>7-day rolling average across all patients</div>
            </div>
            <div style={{ display: "flex", gap: 6 }}>
              {METRIC_TABS.map(t => (
                <button
                  key={t.key}
                  onClick={() => setSelectedMetric(t.key)}
                  style={{
                    padding: "5px 12px", borderRadius: 20, border: "none",
                    fontSize: 11, fontWeight: 600, cursor: "pointer",
                    background: selectedMetric === t.key ? "#1e40af" : "#f1f5f9",
                    color: selectedMetric === t.key ? "white" : "#64748b",
                    transition: "all 0.15s",
                  }}
                >
                  {t.label}
                </button>
              ))}
            </div>
          </div>

          {selectedMetric === "compliance" && (
            <>
              <TrendLine data={cohortTrend} color="#1e40af" height={100} />
              <div style={{ display: "flex", justifyContent: "space-between", marginTop: 8 }}>
                {["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Today"].map((d, i) => (
                  <span key={i} style={{ fontSize: 10, color: "#94a3b8" }}>{d}</span>
                ))}
              </div>
            </>
          )}
          {selectedMetric === "adherence" && (
            <>
              <TrendLine data={[78, 80, 79, 82, 81, 83, avgAdherence]} color="#059669" height={100} />
              <div style={{ display: "flex", justifyContent: "space-between", marginTop: 8 }}>
                {["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Today"].map((d, i) => (
                  <span key={i} style={{ fontSize: 10, color: "#94a3b8" }}>{d}</span>
                ))}
              </div>
            </>
          )}
          {selectedMetric === "alerts" && (
            <>
              <TrendLine data={[8, 6, 9, 5, 7, 6, totalAlerts]} color="#ef4444" height={100} />
              <div style={{ display: "flex", justifyContent: "space-between", marginTop: 8 }}>
                {["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Today"].map((d, i) => (
                  <span key={i} style={{ fontSize: 10, color: "#94a3b8" }}>{d}</span>
                ))}
              </div>
            </>
          )}
        </div>

        {/* Risk distribution */}
        <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
          <div style={{ fontSize: 14, fontWeight: 700, color: "#0f172a", marginBottom: 4 }}>Risk Distribution</div>
          <div style={{ fontSize: 12, color: "#94a3b8", marginBottom: 20 }}>Patient compliance tiers</div>
          <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>
            {[
              { label: "Excellent (≥85%)", value: patients.filter(p => p.compliance >= 85).length, color: "#10b981", total: patients.length },
              { label: "Good (70–84%)",    value: patients.filter(p => p.compliance >= 70 && p.compliance < 85).length, color: "#f59e0b", total: patients.length },
              { label: "At Risk (<70%)",   value: patients.filter(p => p.compliance < 70).length,  color: "#ef4444", total: patients.length },
            ].map(tier => (
              <div key={tier.label}>
                <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 5 }}>
                  <span style={{ fontSize: 11, fontWeight: 600, color: "#475569" }}>{tier.label}</span>
                  <span style={{ fontSize: 11, fontWeight: 800, color: tier.color }}>{tier.value} patients</span>
                </div>
                <div style={{ height: 6, background: "#f1f5f9", borderRadius: 3, overflow: "hidden" }}>
                  <div style={{
                    height: "100%", width: `${(tier.value / tier.total) * 100}%`,
                    background: tier.color, borderRadius: 3,
                    transition: "width 0.8s ease",
                  }} />
                </div>
              </div>
            ))}
          </div>
          <div style={{ marginTop: 20, paddingTop: 16, borderTop: "1px solid #f1f5f9" }}>
            <div style={{ fontSize: 11, color: "#94a3b8", marginBottom: 8 }}>Critical alerts breakdown</div>
            <div style={{ display: "flex", gap: 10 }}>
              {[
                { label: "High",   count: criticalAlerts,                  color: "#ef4444", bg: "#fef2f2" },
                { label: "Medium", count: patients.flatMap(p => p.alerts).filter(a => a.severity === "medium" && !a.isRead).length, color: "#f59e0b", bg: "#fffbeb" },
                { label: "Low",    count: patients.flatMap(p => p.alerts).filter(a => a.severity === "low"    && !a.isRead).length, color: "#3b82f6", bg: "#eff6ff" },
              ].map(b => (
                <div key={b.label} style={{ flex: 1, background: b.bg, borderRadius: 8, padding: "8px 10px", textAlign: "center" }}>
                  <div style={{ fontSize: 18, fontWeight: 900, color: b.color }}>{b.count}</div>
                  <div style={{ fontSize: 10, color: b.color, fontWeight: 600 }}>{b.label}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Per-patient compliance bars + rings */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 20, marginBottom: 20 }}>

        {/* Compliance bars */}
        <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
          <div style={{ fontSize: 14, fontWeight: 700, color: "#0f172a", marginBottom: 4 }}>Per-Patient Compliance</div>
          <div style={{ fontSize: 12, color: "#94a3b8", marginBottom: 16 }}>Individual scores vs cohort average ({avgCompliance}%)</div>
          {[...patients].sort((a, b) => b.compliance - a.compliance).map(p => (
            <CohortBar
              key={p.id}
              label={p.name}
              value={p.compliance}
              color={complianceColor(p.compliance)}
              max={100}
            />
          ))}
        </div>

        {/* Weekly adherence heatmap */}
        <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
          <div style={{ fontSize: 14, fontWeight: 700, color: "#0f172a", marginBottom: 4 }}>Weekly Adherence Heatmap</div>
          <div style={{ fontSize: 12, color: "#94a3b8", marginBottom: 16 }}>Daily compliance per patient this week</div>
          <AdherenceHeatmap patients={patients} />
          <div style={{ display: "flex", gap: 12, marginTop: 14 }}>
            {[{ color: "#10b981", label: "≥90%" }, { color: "#f59e0b", label: "60–89%" }, { color: "#ef4444", label: "<60%" }].map(l => (
              <div key={l.label} style={{ display: "flex", alignItems: "center", gap: 5 }}>
                <div style={{ width: 10, height: 10, borderRadius: 3, background: l.color }} />
                <span style={{ fontSize: 10, color: "#94a3b8" }}>{l.label}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Vital sign metrics */}
      <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20, marginBottom: 20 }}>
        <div style={{ fontSize: 14, fontWeight: 700, color: "#0f172a", marginBottom: 4 }}>Vital Sign Trends by Patient</div>
        <div style={{ fontSize: 12, color: "#94a3b8", marginBottom: 18 }}>Latest readings with recent trend</div>
        <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 14 }}>
          {bpTrends.filter(p => p.trend.length > 0).map(p => (
            <MetricTile key={p.name} label={`${p.name.split(" ")[0]} — BP`} value={p.value} unit="mmHg" trend={p.trend} color="#dc2626" />
          ))}
        </div>
        <div style={{ borderTop: "1px solid #f1f5f9", margin: "18px 0" }} />
        <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 14 }}>
          {sugarTrends.filter(p => p.trend.length > 0).map(p => (
            <MetricTile key={p.name} label={`${p.name.split(" ")[0]} — Sugar`} value={p.value} unit="mg/dL" trend={p.trend} color="#f59e0b" />
          ))}
        </div>
      </div>

      {/* Patient quick grid */}
      <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
          <div>
            <div style={{ fontSize: 14, fontWeight: 700, color: "#0f172a" }}>Patient Compliance At a Glance</div>
            <div style={{ fontSize: 12, color: "#94a3b8", marginTop: 2 }}>Click any patient to view full detail</div>
          </div>
        </div>
        <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 14 }}>
          {patients.map(p => (
            <div
              key={p.id}
              onClick={() => navigate(`/patients/${p.id}`)}
              style={{
                border: "1px solid #e2e8f0", borderRadius: 12, padding: "14px 16px",
                cursor: "pointer", transition: "all 0.15s",
                display: "flex", alignItems: "center", gap: 12,
              }}
              onMouseEnter={e => { e.currentTarget.style.background = "#f8fafc"; e.currentTarget.style.borderColor = "#1e40af"; }}
              onMouseLeave={e => { e.currentTarget.style.background = "white"; e.currentTarget.style.borderColor = "#e2e8f0"; }}
            >
              <ComplianceRing score={p.compliance} size={52} />
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 13, fontWeight: 700, color: "#0f172a", marginBottom: 2 }}>{p.name}</div>
                <div style={{ fontSize: 11, color: "#64748b", marginBottom: 4 }}>{p.conditions[0]}</div>
                <WeeklyBar data={p.weeklyTrend} />
              </div>
              {p.alerts.some(a => a.severity === "high" && !a.isRead) && (
                <div style={{ width: 8, height: 8, borderRadius: "50%", background: "#ef4444", flexShrink: 0 }} />
              )}
            </div>
          ))}
        </div>
        <div style={{ marginTop: 16, textAlign: "center" }}>
          <div style={{ fontSize: 12, color: "#64748b" }}>
            <span style={{ fontWeight: 700, color: complianceColor(avgCompliance) }}>{complianceLabel(avgCompliance)}</span>
            {" "}— cohort average compliance is{" "}
            <span style={{ fontWeight: 700 }}>{avgCompliance}%</span>
          </div>
        </div>
      </div>
    </div>
  );
}
