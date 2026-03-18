import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useDashboard } from "../context/DashboardContext";
import { ComplianceRing } from "../components/ComplianceRing";
import { WeeklyBar } from "../components/WeeklyBar";
import { complianceColor } from "../data/helpers";

export function PatientsPage() {
  const navigate = useNavigate();
  const { patients } = useDashboard();
  const [searchQuery, setSearchQuery] = useState("");
  const [filterStatus, setFilterStatus] = useState<"all" | "critical" | "stable" | "atrisk">("all");

  const filtered = patients
    .filter(p => {
      const q = searchQuery.toLowerCase();
      return !q ||
        p.name.toLowerCase().includes(q) ||
        p.conditions.some(c => c.toLowerCase().includes(q)) ||
        p.bloodGroup.toLowerCase().includes(q);
    })
    .filter(p => {
      if (filterStatus === "all") return true;
      if (filterStatus === "critical") return p.alerts.some(a => a.severity === "high" && !a.isRead);
      if (filterStatus === "atrisk") return p.compliance < 70;
      if (filterStatus === "stable") return p.compliance >= 85 && !p.alerts.some(a => a.severity === "high" && !a.isRead);
      return true;
    });

  return (
    <div>
      {/* Header */}
      <div style={{ marginBottom: 24 }}>
        <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>
          Patients
        </h1>
        <p style={{ color: "#64748b", fontSize: 14, marginTop: 4 }}>
          {patients.length} patients under monitoring
        </p>
      </div>

      {/* Search + Filters */}
      <div style={{ display: "flex", gap: 12, marginBottom: 20, flexWrap: "wrap", alignItems: "center" }}>
        <div style={{ position: "relative", flex: "1 1 280px", maxWidth: 380 }}>
          <svg
            width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" strokeWidth="2.5"
            style={{ position: "absolute", left: 12, top: "50%", transform: "translateY(-50%)", pointerEvents: "none" }}
          >
            <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
          </svg>
          <input
            value={searchQuery}
            onChange={e => setSearchQuery(e.target.value)}
            placeholder="Search name, condition, blood group…"
            style={{
              width: "100%", padding: "9px 14px 9px 36px",
              border: "1px solid #e2e8f0", borderRadius: 10,
              fontSize: 13, outline: "none", background: "white",
              boxShadow: "0 1px 3px rgba(0,0,0,0.05)",
              transition: "border-color 0.15s",
              boxSizing: "border-box",
            }}
            onFocus={e => (e.target.style.borderColor = "#1e40af")}
            onBlur={e => (e.target.style.borderColor = "#e2e8f0")}
          />
        </div>

        <div style={{ display: "flex", gap: 6 }}>
          {([
            { key: "all",      label: "All Patients" },
            { key: "critical", label: "🚨 Critical" },
            { key: "atrisk",   label: "⚠ At Risk" },
            { key: "stable",   label: "✓ Stable" },
          ] as { key: typeof filterStatus; label: string }[]).map(f => (
            <button
              key={f.key}
              onClick={() => setFilterStatus(f.key)}
              style={{
                padding: "7px 14px", borderRadius: 20, border: "none",
                fontSize: 12, fontWeight: 600, cursor: "pointer",
                background: filterStatus === f.key ? "#1e40af" : "#f1f5f9",
                color: filterStatus === f.key ? "white" : "#475569",
                transition: "all 0.15s",
              }}
            >
              {f.label}
            </button>
          ))}
        </div>
      </div>

      {/* Patient grid */}
      {filtered.length === 0 ? (
        <div style={{
          textAlign: "center", padding: "80px 0",
          background: "white", borderRadius: 16, border: "1px solid #e2e8f0",
        }}>
          <div style={{ fontSize: 44, marginBottom: 16 }}>🔍</div>
          <div style={{ fontSize: 16, fontWeight: 700, color: "#475569" }}>No patients found</div>
          <div style={{ fontSize: 13, color: "#94a3b8", marginTop: 6 }}>
            Try a different name, condition, or filter
          </div>
          <button
            onClick={() => { setSearchQuery(""); setFilterStatus("all"); }}
            style={{
              marginTop: 20, background: "#eff6ff", color: "#1e40af",
              padding: "8px 18px", borderRadius: 8, border: "none",
              fontSize: 13, fontWeight: 600, cursor: "pointer",
            }}
          >
            Clear filters
          </button>
        </div>
      ) : (
        <div style={{ display: "grid", gridTemplateColumns: "repeat(2, 1fr)", gap: 16 }}>
          {filtered.map(p => {
            const critical = p.alerts.filter(a => a.severity === "high" && !a.isRead).length;
            return (
              <div
                key={p.id}
                onClick={() => navigate(`/patients/${p.id}`)}
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
                      flexShrink: 0,
                    }}>
                      {p.avatar}
                    </div>
                    <div>
                      <div style={{ fontSize: 16, fontWeight: 800, color: "#0f172a" }}>{p.name}</div>
                      <div style={{ fontSize: 12, color: "#64748b" }}>
                        {p.age}y · {p.gender} · {p.bloodGroup}
                      </div>
                    </div>
                  </div>
                  <ComplianceRing score={p.compliance} size={52} />
                </div>

                <div style={{ display: "flex", flexWrap: "wrap", gap: 6, marginBottom: 14 }}>
                  {p.conditions.map(c => (
                    <span key={c} style={{
                      background: "#f1f5f9", color: "#475569",
                      fontSize: 11, fontWeight: 600, padding: "3px 10px", borderRadius: 20,
                    }}>
                      {c}
                    </span>
                  ))}
                </div>

                <div style={{ marginBottom: 14 }}>
                  <div style={{ fontSize: 10, color: "#94a3b8", marginBottom: 5, fontWeight: 700, letterSpacing: 0.5, textTransform: "uppercase" }}>
                    Weekly Adherence
                  </div>
                  <WeeklyBar data={p.weeklyTrend} />
                </div>

                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", fontSize: 12, color: "#64748b" }}>
                  <span>Last active: {p.lastActive}</span>
                  {critical > 0 ? (
                    <span style={{
                      background: "#fef2f2", color: "#dc2626",
                      fontSize: 11, fontWeight: 700, padding: "3px 10px", borderRadius: 20,
                    }}>
                      ⚠ {critical} critical
                    </span>
                  ) : (
                    <span style={{
                      background: "#ecfdf5", color: "#059669",
                      fontSize: 11, fontWeight: 700, padding: "3px 10px", borderRadius: 20,
                    }}>
                      ✓ Stable
                    </span>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
