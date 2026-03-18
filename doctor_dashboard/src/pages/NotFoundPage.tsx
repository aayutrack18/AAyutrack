import { useNavigate, useLocation } from "react-router-dom";

export function NotFoundPage() {
  const navigate = useNavigate();
  const location = useLocation();

  return (
    <div style={{
      minHeight: "100vh",
      background: "#f8fafc",
      display: "flex",
      flexDirection: "column",
      alignItems: "center",
      justifyContent: "center",
      fontFamily: "'DM Sans', system-ui, sans-serif",
      padding: 24,
      textAlign: "center",
    }}>
      <style>{`@import url('https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800;900&display=swap');`}</style>

      {/* Illustration */}
      <div style={{
        width: 120, height: 120, borderRadius: "50%",
        background: "linear-gradient(135deg, #eff6ff, #e0f2fe)",
        display: "flex", alignItems: "center", justifyContent: "center",
        fontSize: 56, marginBottom: 28,
        boxShadow: "0 8px 32px rgba(30,64,175,0.12)",
      }}>
        🏥
      </div>

      <h1 style={{ fontSize: 28, fontWeight: 900, color: "#0f172a", marginBottom: 8 }}>
        Page Not Found
      </h1>
      <p style={{ color: "#64748b", fontSize: 15, marginBottom: 6, maxWidth: 360 }}>
        The route <code style={{
          background: "#f1f5f9", padding: "2px 8px", borderRadius: 6,
          fontSize: 13, color: "#1e40af", fontWeight: 600,
        }}>{location.pathname}</code> doesn't exist.
      </p>
      <p style={{ color: "#94a3b8", fontSize: 13, marginBottom: 32 }}>
        It may have been moved, deleted, or you may have mistyped the URL.
      </p>

      <div style={{ display: "flex", gap: 12 }}>
        <button
          onClick={() => navigate(-1)}
          style={{
            background: "#f1f5f9", color: "#475569",
            padding: "10px 20px", borderRadius: 10,
            fontSize: 14, fontWeight: 600, border: "none", cursor: "pointer",
          }}
        >
          ← Go Back
        </button>
        <button
          onClick={() => navigate("/dashboard")}
          style={{
            background: "linear-gradient(135deg, #1e40af, #1d4ed8)", color: "white",
            padding: "10px 24px", borderRadius: 10,
            fontSize: 14, fontWeight: 700, border: "none", cursor: "pointer",
            boxShadow: "0 4px 12px rgba(30,64,175,0.3)",
          }}
        >
          Go to Dashboard
        </button>
      </div>

      {/* Branding */}
      <div style={{ marginTop: 48, display: "flex", alignItems: "center", gap: 8 }}>
        <div style={{
          width: 28, height: 28,
          background: "linear-gradient(135deg, #1e40af, #06b6d4)",
          borderRadius: 8,
          display: "flex", alignItems: "center", justifyContent: "center",
        }}>
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none">
            <path d="M12 2L3 7v10l9 5 9-5V7L12 2z" stroke="white" strokeWidth="1.5" strokeLinejoin="round" />
            <path d="M12 7v5M12 12l4 2" stroke="white" strokeWidth="1.5" strokeLinecap="round" />
          </svg>
        </div>
        <span style={{ fontSize: 13, fontWeight: 700, color: "#94a3b8" }}>AAYUTRACK</span>
      </div>
    </div>
  );
}
