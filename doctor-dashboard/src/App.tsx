import { useState, useEffect, useRef } from "react";

// ─── TYPES ────────────────────────────────────────────────────────────────────

type Severity = "high" | "medium" | "low";
type MetricType = "bp" | "sugar" | "heart" | "weight" | "oxygen" | "temp";
type TabId = "overview" | "patients" | "alerts" | "reports" | "messages";

interface Patient {
  id: string;
  name: string;
  age: number;
  gender: string;
  bloodGroup: string;
  conditions: string[];
  compliance: number;
  weeklyTrend: number[];
  lastActive: string;
  alerts: Alert[];
  medicines: Medicine[];
  vitals: Record<MetricType, VitalReading[]>;
  phone: string;
  nextAppt: string;
  avatar: string;
}

interface Alert {
  id: string;
  type: string;
  message: string;
  severity: Severity;
  time: string;
  isRead: boolean;
}

interface Medicine {
  name: string;
  dosage: string;
  frequency: string;
  adherence: number;
  color: string;
}

interface VitalReading {
  date: string;
  value: number;
  secondary?: number;
}

// ─── MOCK DATA ─────────────────────────────────────────────────────────────────

const PATIENTS: Patient[] = [
  {
    id: "p1",
    name: "Rahul Sharma",
    age: 45,
    gender: "Male",
    bloodGroup: "B+",
    conditions: ["Type 2 Diabetes", "Hypertension"],
    compliance: 78,
    weeklyTrend: [100, 75, 100, 50, 100, 75, 83],
    lastActive: "2h ago",
    phone: "+91 98765 43210",
    nextAppt: "Mar 18, 2026",
    avatar: "RS",
    alerts: [
      { id: "a1", type: "BP", message: "Blood pressure elevated: 145/92 mmHg — last 2 readings above threshold", severity: "high", time: "3h ago", isRead: false },
      { id: "a2", type: "DOSE", message: "Missed evening Metformin dose yesterday", severity: "medium", time: "14h ago", isRead: false },
      { id: "a3", type: "LOG", message: "No blood sugar log today", severity: "low", time: "6h ago", isRead: true },
    ],
    medicines: [
      { name: "Metformin", dosage: "500mg", frequency: "Twice Daily", adherence: 85, color: "#1D4ED8" },
      { name: "Amlodipine", dosage: "5mg", frequency: "Once Daily", adherence: 91, color: "#14B8A6" },
      { name: "Aspirin", dosage: "75mg", frequency: "Once Daily", adherence: 96, color: "#7C3AED" },
    ],
    vitals: {
      bp: [
        { date: "Mar 6", value: 128, secondary: 82 },
        { date: "Mar 8", value: 132, secondary: 84 },
        { date: "Mar 10", value: 140, secondary: 90 },
        { date: "Mar 11", value: 145, secondary: 92 },
      ],
      sugar: [
        { date: "Mar 6", value: 108 },
        { date: "Mar 8", value: 114 },
        { date: "Mar 10", value: 122 },
        { date: "Mar 11", value: 118 },
      ],
      heart: [{ date: "Mar 11", value: 78 }],
      weight: [{ date: "Mar 11", value: 72.5 }],
      oxygen: [{ date: "Mar 11", value: 98 }],
      temp: [{ date: "Mar 11", value: 36.6 }],
    },
  },
  {
    id: "p2",
    name: "Sunita Patel",
    age: 58,
    gender: "Female",
    bloodGroup: "O+",
    conditions: ["Asthma", "Hypothyroidism"],
    compliance: 92,
    weeklyTrend: [100, 100, 83, 100, 100, 83, 100],
    lastActive: "30m ago",
    phone: "+91 90001 11223",
    nextAppt: "Mar 22, 2026",
    avatar: "SP",
    alerts: [
      { id: "a4", type: "INHALER", message: "Inhaler usage increased — 3 puffs in 24h", severity: "medium", time: "5h ago", isRead: false },
    ],
    medicines: [
      { name: "Levothyroxine", dosage: "50mcg", frequency: "Once Daily", adherence: 98, color: "#F59E0B" },
      { name: "Montelukast", dosage: "10mg", frequency: "Once Daily", adherence: 94, color: "#EC4899" },
    ],
    vitals: {
      bp: [{ date: "Mar 10", value: 118, secondary: 76 }, { date: "Mar 11", value: 120, secondary: 78 }],
      sugar: [{ date: "Mar 11", value: 94 }],
      heart: [{ date: "Mar 11", value: 72 }],
      weight: [{ date: "Mar 11", value: 61.2 }],
      oxygen: [{ date: "Mar 10", value: 94 }, { date: "Mar 11", value: 96 }],
      temp: [{ date: "Mar 11", value: 36.8 }],
    },
  },
  {
    id: "p3",
    name: "Arjun Menon",
    age: 34,
    gender: "Male",
    bloodGroup: "A-",
    conditions: ["Rheumatoid Arthritis"],
    compliance: 61,
    weeklyTrend: [75, 50, 75, 25, 75, 50, 75],
    lastActive: "2d ago",
    phone: "+91 88001 55678",
    nextAppt: "Mar 15, 2026",
    avatar: "AM",
    alerts: [
      { id: "a5", type: "DOSE", message: "Only 60% medicine adherence this week — multiple missed doses", severity: "high", time: "1d ago", isRead: false },
      { id: "a6", type: "LOG", message: "No health logs for 2 days", severity: "high", time: "2d ago", isRead: false },
    ],
    medicines: [
      { name: "Methotrexate", dosage: "15mg", frequency: "Weekly", adherence: 62, color: "#DC2626" },
      { name: "Folic Acid", dosage: "5mg", frequency: "Once Daily", adherence: 58, color: "#6366F1" },
      { name: "Hydroxychloroquine", dosage: "200mg", frequency: "Twice Daily", adherence: 65, color: "#16A34A" },
    ],
    vitals: {
      bp: [{ date: "Mar 9", value: 124, secondary: 80 }],
      sugar: [{ date: "Mar 9", value: 102 }],
      heart: [{ date: "Mar 9", value: 82 }],
      weight: [{ date: "Mar 9", value: 78.0 }],
      oxygen: [{ date: "Mar 9", value: 97 }],
      temp: [{ date: "Mar 9", value: 37.1 }],
    },
  },
  {
    id: "p4",
    name: "Meera Iyer",
    age: 67,
    gender: "Female",
    bloodGroup: "AB+",
    conditions: ["Heart Failure (Stage II)", "CKD Stage 3"],
    compliance: 88,
    weeklyTrend: [100, 83, 100, 100, 75, 100, 83],
    lastActive: "1h ago",
    phone: "+91 77001 99001",
    nextAppt: "Mar 14, 2026",
    avatar: "MI",
    alerts: [
      { id: "a7", type: "WEIGHT", message: "Weight gain of 1.8kg in 3 days — possible fluid retention", severity: "high", time: "2h ago", isRead: false },
    ],
    medicines: [
      { name: "Furosemide", dosage: "40mg", frequency: "Once Daily", adherence: 92, color: "#DC2626" },
      { name: "Carvedilol", dosage: "6.25mg", frequency: "Twice Daily", adherence: 87, color: "#7C3AED" },
      { name: "Enalapril", dosage: "5mg", frequency: "Twice Daily", adherence: 85, color: "#14B8A6" },
    ],
    vitals: {
      bp: [{ date: "Mar 9", value: 138, secondary: 88 }, { date: "Mar 11", value: 135, secondary: 85 }],
      sugar: [{ date: "Mar 11", value: 106 }],
      heart: [{ date: "Mar 11", value: 68 }],
      weight: [{ date: "Mar 8", value: 64.2 }, { date: "Mar 9", value: 65.0 }, { date: "Mar 11", value: 66.0 }],
      oxygen: [{ date: "Mar 11", value: 95 }],
      temp: [{ date: "Mar 11", value: 36.5 }],
    },
  },
];

// ─── HELPERS ──────────────────────────────────────────────────────────────────

function complianceColor(score: number): string {
  if (score >= 85) return "#10b981";
  if (score >= 70) return "#f59e0b";
  return "#ef4444";
}

function severityColor(s: Severity): string {
  return s === "high" ? "#ef4444" : s === "medium" ? "#f59e0b" : "#3b82f6";
}

function severityBg(s: Severity): string {
  return s === "high" ? "#fef2f2" : s === "medium" ? "#fffbeb" : "#eff6ff";
}

// ─── MINI SPARKLINE ───────────────────────────────────────────────────────────

function Sparkline({ data, color }: { data: number[]; color: string }) {
  const w = 80, h = 32;
  const min = Math.min(...data);
  const max = Math.max(...data);
  const range = max - min || 1;
  const pts = data.map((v, i) => {
    const x = (i / (data.length - 1)) * w;
    const y = h - ((v - min) / range) * (h - 4) - 2;
    return `${x},${y}`;
  });
  return (
    <svg width={w} height={h} style={{ display: "block" }}>
      <polyline
        points={pts.join(" ")}
        fill="none"
        stroke={color}
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <circle cx={pts[pts.length - 1].split(",")[0]} cy={pts[pts.length - 1].split(",")[1]} r="3" fill={color} />
    </svg>
  );
}

// ─── BAR CHART ────────────────────────────────────────────────────────────────

function WeeklyBar({ data, color }: { data: number[]; color: string }) {
  const days = ["M", "T", "W", "T", "F", "S", "S"];
  return (
    <div style={{ display: "flex", alignItems: "flex-end", gap: 4, height: 48 }}>
      {data.map((v, i) => {
        const barColor = v >= 90 ? "#10b981" : v >= 60 ? "#f59e0b" : "#ef4444";
        return (
          <div key={i} style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", gap: 2 }}>
            <div style={{
              width: "100%",
              height: `${(v / 100) * 36}px`,
              background: barColor,
              borderRadius: 3,
              transition: "height 0.5s ease",
            }} />
            <span style={{ fontSize: 9, color: "#94a3b8", fontWeight: 600 }}>{days[i]}</span>
          </div>
        );
      })}
    </div>
  );
}

// ─── VITAL CHART ─────────────────────────────────────────────────────────────

function VitalChart({ readings, color, unit }: { readings: VitalReading[]; color: string; unit: string }) {
  if (!readings.length) return <div style={{ color: "#94a3b8", fontSize: 13, padding: "12px 0" }}>No data</div>;
  const vals = readings.map(r => r.value);
  const min = Math.min(...vals) - 5;
  const max = Math.max(...vals) + 5;
  const range = max - min || 1;
  const W = 280, H = 80;

  const pts = readings.map((r, i) => {
    const x = readings.length === 1 ? W / 2 : (i / (readings.length - 1)) * (W - 20) + 10;
    const y = H - ((r.value - min) / range) * (H - 20) - 10;
    return { x, y, r };
  });

  const pathD = pts.length === 1
    ? `M ${pts[0].x} ${pts[0].y}`
    : pts.map((p, i) => (i === 0 ? `M ${p.x} ${p.y}` : `L ${p.x} ${p.y}`)).join(" ");

  const areaD = pts.length === 1
    ? ""
    : `${pathD} L ${pts[pts.length - 1].x} ${H} L ${pts[0].x} ${H} Z`;

  return (
    <div style={{ position: "relative" }}>
      <svg width={W} height={H} style={{ overflow: "visible" }}>
        <defs>
          <linearGradient id={`g-${color.replace("#", "")}`} x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor={color} stopOpacity="0.2" />
            <stop offset="100%" stopColor={color} stopOpacity="0" />
          </linearGradient>
        </defs>
        {areaD && <path d={areaD} fill={`url(#g-${color.replace("#", "")})`} />}
        <polyline points={pts.map(p => `${p.x},${p.y}`).join(" ")} fill="none" stroke={color} strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
        {pts.map((p, i) => (
          <g key={i}>
            <circle cx={p.x} cy={p.y} r="4" fill="white" stroke={color} strokeWidth="2" />
            <text x={p.x} y={H + 14} textAnchor="middle" fontSize="9" fill="#94a3b8" fontWeight="600">{p.r.date.replace("Mar ", "")}</text>
          </g>
        ))}
      </svg>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 8 }}>
        <span style={{ fontSize: 11, color: "#94a3b8" }}>Latest: <strong style={{ color }}>{readings[readings.length - 1].value}{readings[readings.length - 1].secondary ? `/${readings[readings.length - 1].secondary}` : ""} {unit}</strong></span>
        <span style={{ fontSize: 11, color: "#94a3b8" }}>{readings[readings.length - 1].date}</span>
      </div>
    </div>
  );
}

// ─── COMPLIANCE RING ─────────────────────────────────────────────────────────

function ComplianceRing({ score, size = 56 }: { score: number; size?: number }) {
  const r = (size - 8) / 2;
  const circ = 2 * Math.PI * r;
  const offset = circ - (score / 100) * circ;
  const color = complianceColor(score);
  return (
    <svg width={size} height={size} style={{ transform: "rotate(-90deg)" }}>
      <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke="#f1f5f9" strokeWidth="5" />
      <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke={color} strokeWidth="5"
        strokeDasharray={circ} strokeDashoffset={offset} strokeLinecap="round"
        style={{ transition: "stroke-dashoffset 1s ease" }} />
      <text x={size / 2} y={size / 2} textAnchor="middle" dominantBaseline="central"
        fill={color} fontSize={size * 0.22} fontWeight="800"
        style={{ transform: "rotate(90deg)", transformOrigin: `${size / 2}px ${size / 2}px` }}>
        {score}%
      </text>
    </svg>
  );
}

// ─── MAIN DASHBOARD ──────────────────────────────────────────────────────────

export default function AayuTrackDashboard() {
  const [activeTab, setActiveTab] = useState<TabId>("overview");
  const [selectedPatient, setSelectedPatient] = useState<Patient | null>(null);
  const [searchQuery, setSearchQuery] = useState("");
  const [severityFilter, setSeverityFilter] = useState<"all" | Severity>("all");
  const [alertsData, setAlertsData] = useState(PATIENTS);
  const [msgPatient, setMsgPatient] = useState<Patient | null>(null);
  const [msgText, setMsgText] = useState("");
  const [sentMsgs, setSentMsgs] = useState<{ pid: string; text: string; time: string }[]>([]);
  const [isLoaded, setIsLoaded] = useState(false);
  useEffect(() => { setTimeout(() => setIsLoaded(true), 100); }, []);

  const allAlerts = alertsData.flatMap(p => p.alerts.map(a => ({ ...a, patient: p })));
  const unreadCount = allAlerts.filter(a => !a.isRead).length;

  const filteredPatients = PATIENTS.filter(p =>
    p.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    p.conditions.some(c => c.toLowerCase().includes(searchQuery.toLowerCase()))
  );

  const markAlertRead = (patientId: string, alertId: string) => {
    setAlertsData(prev => prev.map(p =>
      p.id === patientId ? { ...p, alerts: p.alerts.map(a => a.id === alertId ? { ...a, isRead: true } : a) } : p
    ));
  };

  const sendMessage = () => {
    if (!msgPatient || !msgText.trim()) return;
    setSentMsgs(prev => [...prev, { pid: msgPatient.id, text: msgText, time: "Just now" }]);
    setMsgText("");
  };

  return (
    <div style={{
      fontFamily: "'DM Sans', 'Outfit', system-ui, sans-serif",
      background: "#f8fafc",
      minHeight: "100vh",
      display: "flex",
      flexDirection: "column",
      opacity: isLoaded ? 1 : 0,
      transition: "opacity 0.4s ease",
    }}>
      {/* Google Fonts */}
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=DM+Mono:wght@400;500&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 3px; }
        input, textarea, select { font-family: inherit; }
        button { font-family: inherit; cursor: pointer; border: none; }
      `}</style>

      {/* ── TOP NAV ── */}
      <header style={{
        background: "white",
        borderBottom: "1px solid #e2e8f0",
        padding: "0 24px",
        height: 60,
        display: "flex",
        alignItems: "center",
        justifyContent: "space-between",
        position: "sticky",
        top: 0,
        zIndex: 100,
        boxShadow: "0 1px 3px rgba(0,0,0,0.06)",
      }}>
        {/* Logo */}
        <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
          <div style={{
            width: 34, height: 34,
            background: "linear-gradient(135deg, #1e40af, #06b6d4)",
            borderRadius: 10,
            display: "flex", alignItems: "center", justifyContent: "center",
          }}>
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
              <path d="M12 2L3 7v10l9 5 9-5V7L12 2z" stroke="white" strokeWidth="1.5" strokeLinejoin="round"/>
              <path d="M12 7v5M12 12l4 2" stroke="white" strokeWidth="1.5" strokeLinecap="round"/>
            </svg>
          </div>
          <div>
            <div style={{ fontSize: 15, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>AAYUTRACK</div>
            <div style={{ fontSize: 10, color: "#64748b", fontWeight: 500, marginTop: -2 }}>Doctor Dashboard</div>
          </div>
        </div>

        {/* Nav tabs */}
        <nav style={{ display: "flex", gap: 2 }}>
          {([
            { id: "overview", label: "Overview", icon: "⊞" },
            { id: "patients", label: "Patients", icon: "⊕" },
            { id: "alerts", label: "Alerts", icon: "⚠", badge: unreadCount },
            { id: "reports", label: "Reports", icon: "◫" },
            { id: "messages", label: "Messages", icon: "◻" },
          ] as { id: TabId; label: string; icon: string; badge?: number }[]).map(tab => (
            <button key={tab.id} onClick={() => setActiveTab(tab.id)} style={{
              padding: "6px 14px",
              borderRadius: 8,
              fontSize: 13,
              fontWeight: activeTab === tab.id ? 700 : 500,
              color: activeTab === tab.id ? "#1e40af" : "#64748b",
              background: activeTab === tab.id ? "#eff6ff" : "transparent",
              position: "relative",
              transition: "all 0.15s",
              display: "flex", alignItems: "center", gap: 6,
            }}>
              {tab.label}
              {tab.badge ? (
                <span style={{
                  background: "#ef4444", color: "white",
                  borderRadius: 20, fontSize: 10, fontWeight: 700,
                  padding: "1px 6px", minWidth: 18, textAlign: "center",
                }}>{tab.badge}</span>
              ) : null}
            </button>
          ))}
        </nav>

        {/* Doctor info */}
        <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
          <div style={{ textAlign: "right" }}>
            <div style={{ fontSize: 13, fontWeight: 700, color: "#0f172a" }}>Dr. Priya Nair</div>
            <div style={{ fontSize: 11, color: "#64748b" }}>MBBS · Diabetology</div>
          </div>
          <div style={{
            width: 36, height: 36,
            background: "linear-gradient(135deg, #7c3aed, #4f46e5)",
            borderRadius: "50%",
            display: "flex", alignItems: "center", justifyContent: "center",
            fontSize: 13, fontWeight: 800, color: "white",
          }}>PN</div>
        </div>
      </header>

      {/* ── CONTENT ── */}
      <main style={{ flex: 1, padding: "24px", maxWidth: 1280, margin: "0 auto", width: "100%" }}>

        {/* ═══════════════════ OVERVIEW ═══════════════════ */}
        {activeTab === "overview" && (
          <div>
            <div style={{ marginBottom: 24 }}>
              <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>Good morning, Dr. Nair 👋</h1>
              <p style={{ color: "#64748b", fontSize: 14, marginTop: 3 }}>Thursday, March 12, 2026 · {PATIENTS.length} patients monitored</p>
            </div>

            {/* Stats row */}
            <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 16, marginBottom: 24 }}>
              {[
                { label: "Total Patients", value: PATIENTS.length, sub: "Under monitoring", color: "#1e40af", bg: "#eff6ff", icon: "👥" },
                { label: "Critical Alerts", value: allAlerts.filter(a => a.severity === "high" && !a.isRead).length, sub: "Needs attention", color: "#dc2626", bg: "#fef2f2", icon: "🚨" },
                { label: "Avg Compliance", value: `${Math.round(PATIENTS.reduce((s, p) => s + p.compliance, 0) / PATIENTS.length)}%`, sub: "This week", color: "#059669", bg: "#ecfdf5", icon: "📊" },
                { label: "Appointments", value: 3, sub: "This week", color: "#7c3aed", bg: "#f5f3ff", icon: "📅" },
              ].map((s, i) => (
                <div key={i} style={{
                  background: "white", borderRadius: 16, padding: 20,
                  border: "1px solid #e2e8f0",
                  boxShadow: "0 1px 4px rgba(0,0,0,0.04)",
                  transition: "transform 0.2s, box-shadow 0.2s",
                }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 12 }}>
                    <div style={{ fontSize: 22 }}>{s.icon}</div>
                    <div style={{
                      background: s.bg, color: s.color,
                      fontSize: 11, fontWeight: 700, padding: "3px 10px",
                      borderRadius: 20,
                    }}>{s.sub}</div>
                  </div>
                  <div style={{ fontSize: 32, fontWeight: 900, color: s.color, lineHeight: 1 }}>{s.value}</div>
                  <div style={{ fontSize: 13, color: "#64748b", marginTop: 4, fontWeight: 500 }}>{s.label}</div>
                </div>
              ))}
            </div>

            {/* Two column layout */}
            <div style={{ display: "grid", gridTemplateColumns: "1.2fr 0.8fr", gap: 20 }}>
              {/* Patient list */}
              <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", overflow: "hidden" }}>
                <div style={{ padding: "16px 20px", borderBottom: "1px solid #f1f5f9", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                  <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a" }}>Patient Overview</div>
                  <button onClick={() => setActiveTab("patients")} style={{
                    background: "#eff6ff", color: "#1e40af",
                    fontSize: 12, fontWeight: 700, padding: "5px 12px", borderRadius: 8,
                  }}>View All →</button>
                </div>
                <div>
                  {PATIENTS.map((p, i) => {
                    const highAlerts = p.alerts.filter(a => a.severity === "high" && !a.isRead).length;
                    return (
                      <div key={p.id}
                        onClick={() => { setSelectedPatient(p); setActiveTab("patients"); }}
                        style={{
                          padding: "14px 20px",
                          borderBottom: i < PATIENTS.length - 1 ? "1px solid #f8fafc" : "none",
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
                            {p.age}y · {p.conditions[0]}
                            {p.conditions.length > 1 ? ` +${p.conditions.length - 1}` : ""}
                          </div>
                        </div>
                        <div style={{ textAlign: "right" }}>
                          <ComplianceRing score={p.compliance} size={44} />
                        </div>
                        <Sparkline data={p.weeklyTrend} color={complianceColor(p.compliance)} />
                      </div>
                    );
                  })}
                </div>
              </div>

              {/* Alerts panel */}
              <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>
                <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", overflow: "hidden" }}>
                  <div style={{ padding: "16px 20px", borderBottom: "1px solid #f1f5f9", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                    <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a" }}>Recent Alerts</div>
                    <button onClick={() => setActiveTab("alerts")} style={{
                      background: "#fef2f2", color: "#dc2626",
                      fontSize: 12, fontWeight: 700, padding: "5px 12px", borderRadius: 8,
                    }}>{unreadCount} unread</button>
                  </div>
                  <div>
                    {allAlerts.filter(a => !a.isRead).slice(0, 5).map((a, i) => (
                      <div key={a.id} style={{
                        padding: "12px 16px",
                        borderBottom: "1px solid #f8fafc",
                        display: "flex", gap: 10, alignItems: "flex-start",
                        background: a.isRead ? "white" : `${severityBg(a.severity)}80`,
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
                  </div>
                </div>

                {/* Upcoming appointments */}
                <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
                  <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a", marginBottom: 14 }}>Upcoming Appointments</div>
                  {PATIENTS.map(p => (
                    <div key={p.id} style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 10 }}>
                      <div style={{
                        width: 8, height: 8, borderRadius: 2,
                        background: "#1e40af", flexShrink: 0,
                      }} />
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
        )}

        {/* ═══════════════════ PATIENTS ═══════════════════ */}
        {activeTab === "patients" && (
          <div>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 20 }}>
              <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>
                {selectedPatient ? `← ${selectedPatient.name}` : "Patients"}
              </h1>
              {selectedPatient && (
                <button onClick={() => setSelectedPatient(null)} style={{
                  background: "#f1f5f9", color: "#475569",
                  padding: "8px 16px", borderRadius: 8, fontSize: 13, fontWeight: 600,
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
                          <WeeklyBar data={p.weeklyTrend} color={complianceColor(p.compliance)} />
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
              </div>
            ) : (
              /* ── PATIENT DETAIL VIEW ── */
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
                    }}>{selectedPatient.compliance >= 85 ? "Excellent" : selectedPatient.compliance >= 70 ? "Good" : "Needs Attention"}</div>
                  </div>
                  <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
                    <button onClick={() => { setMsgPatient(selectedPatient); setActiveTab("messages"); }} style={{
                      background: "rgba(255,255,255,0.2)", color: "white",
                      padding: "8px 16px", borderRadius: 10, fontSize: 12, fontWeight: 700,
                      border: "1px solid rgba(255,255,255,0.3)",
                    }}>💬 Message</button>
                    <button style={{
                      background: "white", color: "#1e40af",
                      padding: "8px 16px", borderRadius: 10, fontSize: 12, fontWeight: 700,
                    }}>📋 Report</button>
                  </div>
                </div>

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
                              height: "100%",
                              width: `${m.adherence}%`,
                              background: m.color,
                              borderRadius: 3,
                              transition: "width 0.8s ease",
                            }} />
                          </div>
                        </div>
                      ))}
                    </div>

                    {/* Alerts for this patient */}
                    <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
                      <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a", marginBottom: 14 }}>Active Alerts</div>
                      {selectedPatient.alerts.length === 0 ? (
                        <div style={{ fontSize: 13, color: "#94a3b8", textAlign: "center", padding: "12px 0" }}>No alerts 🎉</div>
                      ) : selectedPatient.alerts.map(a => (
                        <div key={a.id} style={{
                          padding: "10px 14px",
                          borderRadius: 10,
                          background: severityBg(a.severity),
                          border: `1px solid ${severityColor(a.severity)}22`,
                          marginBottom: 8,
                          opacity: a.isRead ? 0.6 : 1,
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
                                  marginLeft: 8, flexShrink: 0,
                                }}>✓ Read</button>
                            )}
                          </div>
                        </div>
                      ))}
                    </div>

                    {/* Weekly trend */}
                    <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
                      <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a", marginBottom: 14 }}>Weekly Adherence Trend</div>
                      <WeeklyBar data={selectedPatient.weeklyTrend} color={complianceColor(selectedPatient.compliance)} />
                    </div>
                  </div>
                </div>
              </div>
            )}
          </div>
        )}

        {/* ═══════════════════ ALERTS ═══════════════════ */}
        {activeTab === "alerts" && (
          <div>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 20 }}>
              <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>Risk Alerts</h1>
              <div style={{ display: "flex", gap: 8 }}>
                {(["all", "high", "medium", "low"] as const).map(f => (
                  <button key={f} onClick={() => setSeverityFilter(f)} style={{
                    padding: "6px 14px", borderRadius: 20,
                    fontSize: 12, fontWeight: 700,
                    background: severityFilter === f ? (f === "all" ? "#1e40af" : severityColor(f as Severity)) : "#f1f5f9",
                    color: severityFilter === f ? "white" : "#64748b",
                    transition: "all 0.15s",
                    textTransform: "capitalize",
                  }}>{f}</button>
                ))}
              </div>
            </div>

            <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
              {allAlerts
                .filter(a => severityFilter === "all" || a.severity === severityFilter)
                .sort((a, b) => {
                  const sOrder = { high: 0, medium: 1, low: 2 };
                  if (a.isRead !== b.isRead) return a.isRead ? 1 : -1;
                  return sOrder[a.severity] - sOrder[b.severity];
                })
                .map(a => (
                  <div key={a.id} style={{
                    background: "white", borderRadius: 14,
                    border: `1px solid ${a.isRead ? "#e2e8f0" : severityColor(a.severity) + "44"}`,
                    padding: "16px 20px",
                    display: "flex", gap: 16, alignItems: "flex-start",
                    opacity: a.isRead ? 0.65 : 1,
                    boxShadow: !a.isRead && a.severity === "high" ? "0 0 0 3px #fef2f2" : "none",
                    transition: "all 0.2s",
                  }}>
                    {/* Severity indicator */}
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
                        {!a.isRead && <span style={{
                          width: 7, height: 7, borderRadius: "50%",
                          background: severityColor(a.severity), display: "inline-block",
                        }} />}
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
                        }}>✓ Mark Read</button>
                      )}
                      <button onClick={() => { setSelectedPatient(a.patient); setActiveTab("patients"); }} style={{
                        background: "#eff6ff", color: "#1e40af",
                        padding: "6px 12px", borderRadius: 8, fontSize: 12, fontWeight: 600,
                      }}>View Patient →</button>
                    </div>
                  </div>
                ))}
            </div>
          </div>
        )}

        {/* ═══════════════════ REPORTS ═══════════════════ */}
        {activeTab === "reports" && (
          <div>
            <div style={{ marginBottom: 24 }}>
              <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>Reports & Analytics</h1>
              <p style={{ color: "#64748b", fontSize: 14, marginTop: 3 }}>Compliance summary for your patient cohort</p>
            </div>

            {/* Summary stats */}
            <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 16, marginBottom: 24 }}>
              {[
                {
                  label: "Avg Overall Compliance",
                  value: `${Math.round(PATIENTS.reduce((s, p) => s + p.compliance, 0) / PATIENTS.length)}%`,
                  sub: "All patients this week",
                  color: "#1e40af", icon: "📊"
                },
                {
                  label: "High Risk Patients",
                  value: PATIENTS.filter(p => p.compliance < 70).length,
                  sub: "Compliance < 70%",
                  color: "#dc2626", icon: "⚠️"
                },
                {
                  label: "Medicine Adherence",
                  value: `${Math.round(PATIENTS.flatMap(p => p.medicines.map(m => m.adherence)).reduce((a, b) => a + b, 0) / PATIENTS.flatMap(p => p.medicines).length)}%`,
                  sub: "Average across all meds",
                  color: "#059669", icon: "💊"
                },
              ].map((s, i) => (
                <div key={i} style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
                  <div style={{ fontSize: 22, marginBottom: 8 }}>{s.icon}</div>
                  <div style={{ fontSize: 34, fontWeight: 900, color: s.color }}>{s.value}</div>
                  <div style={{ fontSize: 14, fontWeight: 700, color: "#0f172a", marginTop: 2 }}>{s.label}</div>
                  <div style={{ fontSize: 12, color: "#64748b", marginTop: 2 }}>{s.sub}</div>
                </div>
              ))}
            </div>

            {/* Per-patient compliance table */}
            <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", overflow: "hidden", marginBottom: 20 }}>
              <div style={{ padding: "16px 20px", borderBottom: "1px solid #f1f5f9" }}>
                <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a" }}>Patient Compliance Report · March 2026</div>
              </div>
              <table style={{ width: "100%", borderCollapse: "collapse" }}>
                <thead>
                  <tr style={{ background: "#f8fafc" }}>
                    {["Patient", "Age", "Conditions", "Overall", "Medicine Adh.", "Weekly Trend", "Status"].map(h => (
                      <th key={h} style={{ padding: "10px 16px", textAlign: "left", fontSize: 11, fontWeight: 700, color: "#64748b", textTransform: "uppercase", letterSpacing: 0.5 }}>{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {PATIENTS.map((p, i) => {
                    const avgMed = Math.round(p.medicines.reduce((s, m) => s + m.adherence, 0) / p.medicines.length);
                    return (
                      <tr key={p.id} style={{ borderTop: "1px solid #f1f5f9" }}>
                        <td style={{ padding: "12px 16px" }}>
                          <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
                            <div style={{
                              width: 32, height: 32, borderRadius: "50%",
                              background: `${complianceColor(p.compliance)}22`,
                              display: "flex", alignItems: "center", justifyContent: "center",
                              fontSize: 11, fontWeight: 800, color: complianceColor(p.compliance),
                            }}>{p.avatar}</div>
                            <span style={{ fontSize: 13, fontWeight: 700, color: "#0f172a" }}>{p.name}</span>
                          </div>
                        </td>
                        <td style={{ padding: "12px 16px", fontSize: 13, color: "#64748b" }}>{p.age}y</td>
                        <td style={{ padding: "12px 16px" }}>
                          <div style={{ display: "flex", gap: 4, flexWrap: "wrap" }}>
                            {p.conditions.map(c => (
                              <span key={c} style={{ background: "#f1f5f9", color: "#475569", fontSize: 10, fontWeight: 600, padding: "2px 7px", borderRadius: 10 }}>{c}</span>
                            ))}
                          </div>
                        </td>
                        <td style={{ padding: "12px 16px" }}>
                          <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                            <div style={{ flex: 1, height: 6, background: "#f1f5f9", borderRadius: 3, minWidth: 60 }}>
                              <div style={{ height: "100%", width: `${p.compliance}%`, background: complianceColor(p.compliance), borderRadius: 3 }} />
                            </div>
                            <span style={{ fontSize: 13, fontWeight: 800, color: complianceColor(p.compliance), minWidth: 36 }}>{p.compliance}%</span>
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
                            color: complianceColor(p.compliance),
                          }}>{p.compliance >= 85 ? "Excellent" : p.compliance >= 70 ? "Good" : "At Risk"}</span>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>

            {/* Medicine adherence breakdown */}
            <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 20 }}>
              <div style={{ fontSize: 15, fontWeight: 700, color: "#0f172a", marginBottom: 16 }}>Medicine Adherence Breakdown</div>
              <div style={{ display: "grid", gridTemplateColumns: "repeat(2, 1fr)", gap: 20 }}>
                {PATIENTS.map(p => (
                  <div key={p.id}>
                    <div style={{ fontSize: 13, fontWeight: 700, color: "#0f172a", marginBottom: 10 }}>{p.name}</div>
                    {p.medicines.map((m, i) => (
                      <div key={i} style={{ marginBottom: 8 }}>
                        <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 4 }}>
                          <span style={{ fontSize: 12, color: "#475569" }}>{m.name} {m.dosage}</span>
                          <span style={{ fontSize: 12, fontWeight: 700, color: complianceColor(m.adherence) }}>{m.adherence}%</span>
                        </div>
                        <div style={{ height: 5, background: "#f1f5f9", borderRadius: 3 }}>
                          <div style={{ height: "100%", width: `${m.adherence}%`, background: m.color, borderRadius: 3 }} />
                        </div>
                      </div>
                    ))}
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* ═══════════════════ MESSAGES ═══════════════════ */}
        {activeTab === "messages" && (
          <div>
            <div style={{ marginBottom: 24 }}>
              <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>Patient Messages</h1>
              <p style={{ color: "#64748b", fontSize: 14, marginTop: 3 }}>Send reminders, follow-ups, and instructions directly to patients</p>
            </div>

            <div style={{ display: "grid", gridTemplateColumns: "280px 1fr", gap: 20 }}>
              {/* Patient selector */}
              <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", overflow: "hidden" }}>
                <div style={{ padding: "14px 16px", borderBottom: "1px solid #f1f5f9", fontSize: 13, fontWeight: 700, color: "#64748b" }}>SELECT PATIENT</div>
                {PATIENTS.map(p => (
                  <div key={p.id}
                    onClick={() => setMsgPatient(p)}
                    style={{
                      padding: "12px 16px",
                      display: "flex", alignItems: "center", gap: 10,
                      cursor: "pointer",
                      background: msgPatient?.id === p.id ? "#eff6ff" : "white",
                      borderBottom: "1px solid #f8fafc",
                      borderLeft: msgPatient?.id === p.id ? "3px solid #1e40af" : "3px solid transparent",
                      transition: "all 0.15s",
                    }}
                  >
                    <div style={{
                      width: 36, height: 36, borderRadius: "50%",
                      background: `${complianceColor(p.compliance)}22`,
                      border: `1.5px solid ${complianceColor(p.compliance)}`,
                      display: "flex", alignItems: "center", justifyContent: "center",
                      fontSize: 11, fontWeight: 800, color: complianceColor(p.compliance),
                      flexShrink: 0,
                    }}>{p.avatar}</div>
                    <div style={{ flex: 1, minWidth: 0 }}>
                      <div style={{ fontSize: 13, fontWeight: 700, color: "#0f172a", whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>{p.name}</div>
                      <div style={{ fontSize: 11, color: "#64748b" }}>{p.compliance}% compliance</div>
                    </div>
                    {p.alerts.some(a => a.severity === "high" && !a.isRead) && (
                      <div style={{ width: 8, height: 8, borderRadius: "50%", background: "#ef4444", flexShrink: 0 }} />
                    )}
                  </div>
                ))}
              </div>

              {/* Message compose area */}
              <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>
                {msgPatient ? (
                  <>
                    {/* Patient quick info */}
                    <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 16, display: "flex", alignItems: "center", gap: 14 }}>
                      <div style={{
                        width: 44, height: 44, borderRadius: "50%",
                        background: `${complianceColor(msgPatient.compliance)}22`,
                        border: `2px solid ${complianceColor(msgPatient.compliance)}`,
                        display: "flex", alignItems: "center", justifyContent: "center",
                        fontSize: 13, fontWeight: 800, color: complianceColor(msgPatient.compliance),
                      }}>{msgPatient.avatar}</div>
                      <div style={{ flex: 1 }}>
                        <div style={{ fontSize: 15, fontWeight: 800, color: "#0f172a" }}>{msgPatient.name}</div>
                        <div style={{ fontSize: 12, color: "#64748b" }}>{msgPatient.conditions.join(", ")} · Last active {msgPatient.lastActive}</div>
                      </div>
                      <ComplianceRing score={msgPatient.compliance} size={44} />
                    </div>

                    {/* Quick templates */}
                    <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 16 }}>
                      <div style={{ fontSize: 13, fontWeight: 700, color: "#64748b", marginBottom: 10 }}>QUICK TEMPLATES</div>
                      <div style={{ display: "flex", flexWrap: "wrap", gap: 8 }}>
                        {[
                          "Please take your medicine as scheduled today.",
                          "Reminder: Log your blood pressure reading.",
                          `Your compliance is at ${msgPatient.compliance}% — keep it up!`,
                          "Please schedule a follow-up appointment.",
                          "Contact me if your symptoms worsen.",
                        ].map((t, i) => (
                          <button key={i} onClick={() => setMsgText(t)} style={{
                            background: "#f1f5f9", color: "#475569",
                            padding: "6px 12px", borderRadius: 8, fontSize: 12, fontWeight: 500,
                            textAlign: "left",
                            transition: "all 0.15s",
                          }}
                            onMouseEnter={e => { e.currentTarget.style.background = "#eff6ff"; e.currentTarget.style.color = "#1e40af"; }}
                            onMouseLeave={e => { e.currentTarget.style.background = "#f1f5f9"; e.currentTarget.style.color = "#475569"; }}
                          >{t}</button>
                        ))}
                      </div>
                    </div>

                    {/* Compose */}
                    <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 16 }}>
                      <div style={{ fontSize: 13, fontWeight: 700, color: "#64748b", marginBottom: 10 }}>COMPOSE MESSAGE</div>
                      <textarea
                        value={msgText}
                        onChange={e => setMsgText(e.target.value)}
                        placeholder={`Write a message to ${msgPatient.name}...`}
                        rows={4}
                        style={{
                          width: "100%", padding: "12px 14px",
                          border: "1px solid #e2e8f0", borderRadius: 10,
                          fontSize: 13, resize: "vertical", outline: "none",
                          background: "#f8fafc",
                          transition: "border 0.15s",
                        }}
                        onFocus={e => (e.target.style.borderColor = "#1e40af")}
                        onBlur={e => (e.target.style.borderColor = "#e2e8f0")}
                      />
                      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 10 }}>
                        <span style={{ fontSize: 12, color: "#94a3b8" }}>{msgText.length} characters</span>
                        <button onClick={sendMessage} disabled={!msgText.trim()} style={{
                          background: msgText.trim() ? "#1e40af" : "#e2e8f0",
                          color: msgText.trim() ? "white" : "#94a3b8",
                          padding: "8px 20px", borderRadius: 10,
                          fontSize: 13, fontWeight: 700,
                          transition: "all 0.2s",
                        }}>Send Message →</button>
                      </div>
                    </div>

                    {/* Sent messages history */}
                    {sentMsgs.filter(m => m.pid === msgPatient.id).length > 0 && (
                      <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 16 }}>
                        <div style={{ fontSize: 13, fontWeight: 700, color: "#64748b", marginBottom: 10 }}>SENT MESSAGES</div>
                        {sentMsgs.filter(m => m.pid === msgPatient.id).map((m, i) => (
                          <div key={i} style={{
                            background: "#eff6ff", borderRadius: 10,
                            padding: "10px 14px", marginBottom: 8,
                            borderLeft: "3px solid #1e40af",
                          }}>
                            <div style={{ fontSize: 13, color: "#0f172a" }}>{m.text}</div>
                            <div style={{ fontSize: 11, color: "#94a3b8", marginTop: 4 }}>Dr. Nair · {m.time}</div>
                          </div>
                        ))}
                      </div>
                    )}
                  </>
                ) : (
                  <div style={{
                    background: "white", borderRadius: 16, border: "1px solid #e2e8f0",
                    display: "flex", flexDirection: "column",
                    alignItems: "center", justifyContent: "center",
                    padding: 60, color: "#94a3b8",
                  }}>
                    <div style={{ fontSize: 48, marginBottom: 16 }}>💬</div>
                    <div style={{ fontSize: 16, fontWeight: 700, color: "#475569", marginBottom: 6 }}>Select a Patient</div>
                    <div style={{ fontSize: 13, textAlign: "center" }}>Choose a patient from the list to send them a message</div>
                  </div>
                )}
              </div>
            </div>
          </div>
        )}
      </main>
    </div>
  );
}
