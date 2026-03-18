import type { TabId } from "../types";
import { useAuth } from "../context/AuthContext";
import { useDashboard } from "../context/DashboardContext";

interface TopbarProps {
  activeTab: TabId;
  setActiveTab: (tab: TabId) => void;
  unreadCount: number;
}

export function Topbar({ activeTab, setActiveTab, unreadCount }: TopbarProps) {
  const { doctor, logout } = useAuth();
  const { setSelectedPatient } = useDashboard();

  const handleTabChange = (tab: TabId) => {
    setActiveTab(tab);
    if (tab !== "patients") setSelectedPatient(null);
  };

  return (
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
            <path d="M12 2L3 7v10l9 5 9-5V7L12 2z" stroke="white" strokeWidth="1.5" strokeLinejoin="round" />
            <path d="M12 7v5M12 12l4 2" stroke="white" strokeWidth="1.5" strokeLinecap="round" />
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
          <button key={tab.id} onClick={() => handleTabChange(tab.id)} style={{
            padding: "6px 14px",
            borderRadius: 8,
            fontSize: 13,
            fontWeight: activeTab === tab.id ? 700 : 500,
            color: activeTab === tab.id ? "#1e40af" : "#64748b",
            background: activeTab === tab.id ? "#eff6ff" : "transparent",
            position: "relative",
            transition: "all 0.15s",
            display: "flex", alignItems: "center", gap: 6,
            border: "none", cursor: "pointer",
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

      {/* Doctor info + logout */}
      <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
        <div style={{ textAlign: "right" }}>
          <div style={{ fontSize: 13, fontWeight: 700, color: "#0f172a" }}>{doctor?.name}</div>
          <div style={{ fontSize: 11, color: "#64748b" }}>{doctor?.specialty}</div>
        </div>
        <div style={{
          width: 36, height: 36,
          background: "linear-gradient(135deg, #7c3aed, #4f46e5)",
          borderRadius: "50%",
          display: "flex", alignItems: "center", justifyContent: "center",
          fontSize: 13, fontWeight: 800, color: "white",
        }}>PN</div>
        <button onClick={logout} title="Logout" style={{
          background: "#f1f5f9",
          border: "none",
          borderRadius: 8,
          padding: "6px 10px",
          fontSize: 12,
          color: "#64748b",
          cursor: "pointer",
          fontWeight: 600,
          transition: "all 0.15s",
        }}
          onMouseEnter={e => { e.currentTarget.style.background = "#fee2e2"; e.currentTarget.style.color = "#dc2626"; }}
          onMouseLeave={e => { e.currentTarget.style.background = "#f1f5f9"; e.currentTarget.style.color = "#64748b"; }}
        >
          ⎋ Logout
        </button>
      </div>
    </header>
  );
}
