import { useState, type FormEvent } from "react";
import { useNavigate, useLocation, Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

export function LoginPage() {
  const { login, isAuthenticated } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const from = (location.state as { from?: { pathname: string } } | null)?.from?.pathname ?? "/dashboard";

  const [email,    setEmail]    = useState("priya.nair@aayutrack.in");
  const [password, setPassword] = useState("");
  const [error,    setError]    = useState("");
  const [loading,  setLoading]  = useState(false);

  if (isAuthenticated) {
    return <Navigate to={from} replace />;
  }

  const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setError("");
    if (!email.trim() || !password.trim()) {
      setError("Please enter your email and password.");
      return;
    }
    setLoading(true);
    await new Promise(r => setTimeout(r, 650));
    const ok = await login(email, password);
    setLoading(false);
    if (ok) {
      navigate(from, { replace: true });
    } else {
      setError("Invalid credentials. Please try again.");
    }
  };

  return (
    <div style={{
      minHeight: "100vh",
      background: "linear-gradient(135deg, #0f172a 0%, #1e3a8a 55%, #0c4a6e 100%)",
      display: "flex", alignItems: "center", justifyContent: "center",
      padding: 24, fontFamily: "'DM Sans', system-ui, sans-serif",
    }}>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800;900&display=swap');
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        @keyframes spin { to { transform: rotate(360deg); } }
      `}</style>

      {/* Decorative rings */}
      <div style={{ position: "fixed", inset: 0, pointerEvents: "none", zIndex: 0 }}>
        {[300, 420, 540, 660, 780, 900].map((size, i) => (
          <div key={i} style={{
            position: "absolute", width: size, height: size, borderRadius: "50%",
            border: "1px solid rgba(255,255,255,0.04)",
            top: "50%", left: "50%", transform: "translate(-50%,-50%)",
          }} />
        ))}
      </div>

      <div style={{ position: "relative", zIndex: 1, width: "100%", maxWidth: 420 }}>
        <div style={{
          background: "white", borderRadius: 24, padding: "48px 44px",
          boxShadow: "0 32px 80px rgba(0,0,0,0.45)",
        }}>
          {/* Logo */}
          <div style={{ display: "flex", alignItems: "center", gap: 12, marginBottom: 36 }}>
            <div style={{
              width: 44, height: 44, borderRadius: 14, flexShrink: 0,
              background: "linear-gradient(135deg, #1e40af, #06b6d4)",
              display: "flex", alignItems: "center", justifyContent: "center",
            }}>
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                <path d="M12 2L3 7v10l9 5 9-5V7L12 2z" stroke="white" strokeWidth="1.5" strokeLinejoin="round"/>
                <path d="M12 7v5M12 12l4 2" stroke="white" strokeWidth="1.5" strokeLinecap="round"/>
              </svg>
            </div>
            <div>
              <div style={{ fontSize: 18, fontWeight: 900, color: "#0f172a", letterSpacing: "-0.5px" }}>AAYUTRACK</div>
              <div style={{ fontSize: 11, color: "#64748b", fontWeight: 500 }}>Remote Patient Monitoring</div>
            </div>
          </div>

          <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", marginBottom: 6 }}>Doctor Sign In</h1>
          <p style={{ fontSize: 13, color: "#64748b", marginBottom: 24 }}>
            Monitor your patients remotely and securely.
          </p>

          <div style={{
            background: "#eff6ff", border: "1px solid #bfdbfe",
            borderRadius: 10, padding: "10px 14px", marginBottom: 24,
            fontSize: 12, color: "#1e40af", lineHeight: 1.5,
          }}>
            💡 <strong>Demo mode:</strong> Email is pre-filled. Enter any password to sign in.
          </div>

          <form onSubmit={handleSubmit}>
            <div style={{ marginBottom: 16 }}>
              <label style={{
                fontSize: 11, fontWeight: 700, color: "#374151",
                display: "block", marginBottom: 6,
                textTransform: "uppercase", letterSpacing: 0.5,
              }}>
                Email Address
              </label>
              <input
                type="email" value={email} onChange={e => setEmail(e.target.value)}
                placeholder="doctor@hospital.in"
                style={{
                  width: "100%", padding: "11px 14px",
                  border: "1.5px solid #e2e8f0", borderRadius: 10,
                  fontSize: 14, outline: "none", background: "#f8fafc",
                  transition: "border-color 0.15s", boxSizing: "border-box",
                }}
                onFocus={e => (e.target.style.borderColor = "#1e40af")}
                onBlur={e => (e.target.style.borderColor = "#e2e8f0")}
              />
            </div>

            <div style={{ marginBottom: 24 }}>
              <label style={{
                fontSize: 11, fontWeight: 700, color: "#374151",
                display: "block", marginBottom: 6,
                textTransform: "uppercase", letterSpacing: 0.5,
              }}>
                Password
              </label>
              <input
                type="password" value={password} onChange={e => setPassword(e.target.value)}
                placeholder="••••••••"
                style={{
                  width: "100%", padding: "11px 14px",
                  border: "1.5px solid #e2e8f0", borderRadius: 10,
                  fontSize: 14, outline: "none", background: "#f8fafc",
                  transition: "border-color 0.15s", boxSizing: "border-box",
                }}
                onFocus={e => (e.target.style.borderColor = "#1e40af")}
                onBlur={e => (e.target.style.borderColor = "#e2e8f0")}
              />
            </div>

            {error && (
              <div style={{
                background: "#fef2f2", border: "1px solid #fecaca",
                borderRadius: 8, padding: "10px 14px",
                fontSize: 13, color: "#dc2626", marginBottom: 16,
              }}>
                ⚠ {error}
              </div>
            )}

            <button
              type="submit" disabled={loading}
              style={{
                width: "100%", padding: "13px",
                background: loading ? "#94a3b8" : "linear-gradient(135deg, #1e40af, #1d4ed8)",
                color: "white", borderRadius: 12, fontSize: 15, fontWeight: 700,
                border: "none", cursor: loading ? "not-allowed" : "pointer",
                transition: "all 0.2s",
                boxShadow: loading ? "none" : "0 4px 14px rgba(30,64,175,0.4)",
              }}
            >
              {loading ? (
                <span style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: 8 }}>
                  <span style={{
                    width: 14, height: 14,
                    border: "2px solid rgba(255,255,255,0.4)",
                    borderTopColor: "white", borderRadius: "50%",
                    display: "inline-block", animation: "spin 0.7s linear infinite",
                  }} />
                  Signing in…
                </span>
              ) : "Sign In →"}
            </button>
          </form>

          <p style={{ fontSize: 11, color: "#94a3b8", textAlign: "center", marginTop: 28 }}>
            AAYUTRACK · Digital Compliance Platform · v3.0
          </p>
        </div>
      </div>
    </div>
  );
}
