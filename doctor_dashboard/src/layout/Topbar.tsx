import { useNavigate, useLocation } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { useDashboard } from "../context/DashboardContext";

const NAV_ITEMS = [
  { path: "/dashboard", label: "Overview"   },
  { path: "/patients",  label: "Patients"   },
  { path: "/alerts",    label: "Alerts",    badge: true },
  { path: "/analytics", label: "Analytics"  },
  { path: "/reports",   label: "Reports"    },
  { path: "/messages",  label: "Messages"   },
] as const;

export function Topbar() {
  const navigate           = useNavigate();
  const location           = useLocation();
  const { doctor, logout } = useAuth();
  const { patients }       = useDashboard();

  const unreadCount = patients.flatMap(p => p.alerts).filter(a => !a.isRead).length;

  const handleLogout = () => {
    logout();
    navigate("/login", { replace: true });
  };

  const isActive = (path: string) =>
    path === "/dashboard"
      ? location.pathname === "/dashboard"
      : location.pathname.startsWith(path);

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
      flexShrink: 0,
      gap: 12,
    }}>
      {/* Logo */}
      <div
        onClick={() => navigate("/dashboard")}
        style={{ display: "flex", alignItems: "center", gap: 10, cursor: "pointer", flexShrink: 0 }}
      >
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
        <div style={{ display: "flex", flexDirection: "column" }}>
          <span style={{ fontSize: 15, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px", lineHeight: 1.2 }}>AAYUTRACK</span>
          <span style={{ fontSize: 10, color: "#64748b", fontWeight: 500 }}>Doctor Dashboard</span>
        </div>
      </div>

      {/* Nav */}
      <nav style={{ display: "flex", gap: 2, flex: 1, justifyContent: "center" }}>
        {NAV_ITEMS.map(item => {
          const active = isActive(item.path);
          return (
            <button
              key={item.path}
              onClick={() => navigate(item.path)}
              style={{
                padding: "6px 12px",
                borderRadius: 8,
                fontSize: 13,
                fontWeight: active ? 700 : 500,
                color: active ? "#1e40af" : "#64748b",
                background: active ? "#eff6ff" : "transparent",
                border: "none",
                cursor: "pointer",
                display: "flex",
                alignItems: "center",
                gap: 5,
                transition: "all 0.15s",
                whiteSpace: "nowrap",
              }}
            >
              {item.label}
              {"badge" in item && item.badge && unreadCount > 0 && (
                <span style={{
                  background: "#ef4444", color: "white",
                  borderRadius: 20, fontSize: 10, fontWeight: 700,
                  padding: "1px 6px", minWidth: 18,
                  textAlign: "center", lineHeight: "16px",
                }}>
                  {unreadCount}
                </span>
              )}
            </button>
          );
        })}
      </nav>

      {/* Doctor + logout */}
      <div style={{ display: "flex", alignItems: "center", gap: 10, flexShrink: 0 }}>
        <div style={{ textAlign: "right" }}>
          <div style={{ fontSize: 13, fontWeight: 700, color: "#0f172a", lineHeight: 1.2 }}>{doctor?.name ?? "Doctor"}</div>
          <div style={{ fontSize: 10, color: "#64748b" }}>{doctor?.specialty ?? ""}</div>
        </div>
        <div style={{
          width: 34, height: 34,
          background: "linear-gradient(135deg, #7c3aed, #4f46e5)",
          borderRadius: "50%",
          display: "flex", alignItems: "center", justifyContent: "center",
          fontSize: 12, fontWeight: 800, color: "white", flexShrink: 0,
        }}>
          {doctor?.initials ?? "DR"}
        </div>
        <button
          onClick={handleLogout}
          style={{
            background: "#f1f5f9", border: "none", borderRadius: 8,
            padding: "6px 10px", fontSize: 12, color: "#64748b",
            cursor: "pointer", fontWeight: 600, transition: "all 0.15s",
            whiteSpace: "nowrap",
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
