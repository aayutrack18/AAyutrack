import { useState } from "react";
import { useAuth } from "../context/AuthContext";

export function LoginPage() {
  const { login } = useAuth();
  const [email, setEmail] = useState("priya.nair@aayutrack.in");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    if (!email.trim() || !password.trim()) {
      setError("Please enter your email and password.");
      return;
    }
    setLoading(true);
    await new Promise(r => setTimeout(r, 700)); // simulate network
    const ok = await login(email, password);
    setLoading(false);
    if (!ok) setError("Invalid credentials. Please try again.");
  };

  return (
    <div style={{
      minHeight: "100vh",
      background: "linear-gradient(135deg, #0f172a 0%, #1e3a8a 50%, #0c4a6e 100%)",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
      fontFamily: "'DM Sans', system-ui, sans-serif",
      padding: 24,
    }}>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }
        input { font-family: inherit; }
        button { font-family: inherit; cursor: pointer; border: none; }
      `}</style>

      {/* Card */}
      <div style={{
        background: "white",
        borderRadius: 24,
        padding: "48px 44px",
        width: "100%",
        maxWidth: 420,
        boxShadow: "0 32px 64px rgba(0,0,0,0.4)",
      }}>
        {/* Logo */}
        <div style={{ display: "flex", alignItems: "center", gap: 12, marginBottom: 36 }}>
          <div style={{
            width: 44, height: 44,
            background: "linear-gradient(135deg, #1e40af, #06b6d4)",
            borderRadius: 14,
            display: "flex", alignItems: "center", justifyContent: "center",
          }}>
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
              <path d="M12 2L3 7v10l9 5 9-5V7L12 2z" stroke="white" strokeWidth="1.5" strokeLinejoin="round" />
              <path d="M12 7v5M12 12l4 2" stroke="white" strokeWidth="1.5" strokeLinecap="round" />
            </svg>
          </div>
          <div>
            <div style={{ fontSize: 18, fontWeight: 900, color: "#0f172a", letterSpacing: "-0.5px" }}>AAYUTRACK</div>
            <div style={{ fontSize: 11, color: "#64748b", fontWeight: 500 }}>Remote Patient Monitoring</div>
          </div>
        </div>

        <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", marginBottom: 6 }}>Doctor Login</h1>
        <p style={{ fontSize: 13, color: "#64748b", marginBottom: 28 }}>
          Sign in to monitor your patients remotely.
        </p>

        {/* Demo hint */}
        <div style={{
          background: "#eff6ff", border: "1px solid #bfdbfe",
          borderRadius: 10, padding: "10px 14px", marginBottom: 24,
          fontSize: 12, color: "#1e40af", fontWeight: 500,
        }}>
          💡 <strong>Demo:</strong> Use any email + any password to sign in.
        </div>

        <form onSubmit={handleLogin}>
          <div style={{ marginBottom: 16 }}>
            <label style={{ fontSize: 12, fontWeight: 700, color: "#374151", display: "block", marginBottom: 6 }}>
              EMAIL ADDRESS
            </label>
            <input
              type="email"
              value={email}
              onChange={e => setEmail(e.target.value)}
              placeholder="doctor@hospital.in"
              style={{
                width: "100%", padding: "11px 14px",
                border: "1.5px solid #e2e8f0", borderRadius: 10,
                fontSize: 14, outline: "none",
                transition: "border 0.15s",
              }}
              onFocus={e => (e.target.style.borderColor = "#1e40af")}
              onBlur={e => (e.target.style.borderColor = "#e2e8f0")}
            />
          </div>

          <div style={{ marginBottom: 24 }}>
            <label style={{ fontSize: 12, fontWeight: 700, color: "#374151", display: "block", marginBottom: 6 }}>
              PASSWORD
            </label>
            <input
              type="password"
              value={password}
              onChange={e => setPassword(e.target.value)}
              placeholder="••••••••"
              style={{
                width: "100%", padding: "11px 14px",
                border: "1.5px solid #e2e8f0", borderRadius: 10,
                fontSize: 14, outline: "none",
                transition: "border 0.15s",
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
            }}>{error}</div>
          )}

          <button
            type="submit"
            disabled={loading}
            style={{
              width: "100%",
              background: loading ? "#94a3b8" : "linear-gradient(135deg, #1e40af, #1d4ed8)",
              color: "white",
              padding: "13px",
              borderRadius: 12,
              fontSize: 15,
              fontWeight: 700,
              transition: "all 0.2s",
              boxShadow: loading ? "none" : "0 4px 14px rgba(30,64,175,0.35)",
            }}
          >
            {loading ? "Signing in…" : "Sign In →"}
          </button>
        </form>

        <p style={{ fontSize: 12, color: "#94a3b8", textAlign: "center", marginTop: 24 }}>
          AAYUTRACK · Digital Compliance & Remote Monitoring
        </p>
      </div>
    </div>
  );
}
