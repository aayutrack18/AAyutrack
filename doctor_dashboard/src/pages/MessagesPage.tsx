import { useState, useEffect } from "react";
import { useLocation } from "react-router-dom";
import type { Patient } from "../types";
import { useDashboard } from "../context/DashboardContext";
import { ComplianceRing } from "../components/ComplianceRing";
import { complianceColor } from "../data/helpers";

export function MessagesPage() {
  const location = useLocation();
  const { patients, sentMsgs, addSentMsg } = useDashboard();

  // Support navigate("/messages", { state: { patientId } }) from PatientDetail
  const preselectedId = (location.state as { patientId?: string } | null)?.patientId ?? null;
  const [msgPatient, setMsgPatient] = useState<Patient | null>(
    preselectedId ? (patients.find(p => p.id === preselectedId) ?? null) : null
  );
  const [msgText, setMsgText] = useState("");
  const [searchMsg, setSearchMsg] = useState("");

  // Re-sync if state changes (e.g. navigated from different patient)
  useEffect(() => {
    if (preselectedId) {
      const p = patients.find(p => p.id === preselectedId);
      if (p) setMsgPatient(p);
    }
  }, [preselectedId, patients]);

  const filteredPatients = patients.filter(p =>
    !searchMsg || p.name.toLowerCase().includes(searchMsg.toLowerCase())
  );

  const sendMessage = () => {
    if (!msgPatient || !msgText.trim()) return;
    addSentMsg({ pid: msgPatient.id, text: msgText.trim(), time: "Just now" });
    setMsgText("");
  };

  return (
    <div>
      <div style={{ marginBottom: 24 }}>
        <h1 style={{ fontSize: 22, fontWeight: 800, color: "#0f172a", letterSpacing: "-0.5px" }}>
          Messages
        </h1>
        <p style={{ color: "#64748b", fontSize: 14, marginTop: 4 }}>
          Send reminders and care notes directly to patients
        </p>
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "300px 1fr", gap: 20, alignItems: "start" }}>

        {/* Patient selector */}
        <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", overflow: "hidden" }}>
          <div style={{ padding: "12px 16px", borderBottom: "1px solid #f1f5f9" }}>
            <input
              value={searchMsg}
              onChange={e => setSearchMsg(e.target.value)}
              placeholder="Search patients…"
              style={{
                width: "100%", padding: "7px 10px",
                border: "1px solid #e2e8f0", borderRadius: 8,
                fontSize: 12, outline: "none", background: "#f8fafc",
                boxSizing: "border-box",
              }}
              onFocus={e => (e.target.style.borderColor = "#1e40af")}
              onBlur={e => (e.target.style.borderColor = "#e2e8f0")}
            />
          </div>
          {filteredPatients.map(p => {
            const unread = sentMsgs.filter(m => m.pid === p.id).length;
            return (
              <div
                key={p.id}
                onClick={() => setMsgPatient(p)}
                style={{
                  padding: "12px 16px", borderBottom: "1px solid #f8fafc",
                  display: "flex", alignItems: "center", gap: 10,
                  cursor: "pointer",
                  background: msgPatient?.id === p.id ? "#eff6ff" : "white",
                  borderLeft: msgPatient?.id === p.id ? "3px solid #1e40af" : "3px solid transparent",
                  transition: "all 0.15s",
                }}
                onMouseEnter={e => { if (msgPatient?.id !== p.id) (e.currentTarget as HTMLDivElement).style.background = "#f8fafc"; }}
                onMouseLeave={e => { if (msgPatient?.id !== p.id) (e.currentTarget as HTMLDivElement).style.background = "white"; }}
              >
                <div style={{
                  width: 36, height: 36, borderRadius: "50%", flexShrink: 0,
                  background: `${complianceColor(p.compliance)}22`,
                  border: `1.5px solid ${complianceColor(p.compliance)}`,
                  display: "flex", alignItems: "center", justifyContent: "center",
                  fontSize: 11, fontWeight: 800, color: complianceColor(p.compliance),
                }}>
                  {p.avatar}
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 13, fontWeight: 700, color: "#0f172a", whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
                    {p.name}
                  </div>
                  <div style={{ fontSize: 11, color: "#64748b" }}>{p.compliance}% compliance</div>
                </div>
                <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-end", gap: 3 }}>
                  {p.alerts.some(a => a.severity === "high" && !a.isRead) && (
                    <div style={{ width: 7, height: 7, borderRadius: "50%", background: "#ef4444" }} />
                  )}
                  {unread > 0 && (
                    <span style={{ fontSize: 9, fontWeight: 700, color: "#1e40af", background: "#eff6ff", padding: "1px 5px", borderRadius: 10 }}>
                      {unread} sent
                    </span>
                  )}
                </div>
              </div>
            );
          })}
        </div>

        {/* Compose area */}
        {!msgPatient ? (
          <div style={{
            background: "white", borderRadius: 16, border: "1px solid #e2e8f0",
            display: "flex", flexDirection: "column", alignItems: "center",
            justifyContent: "center", padding: 60, color: "#94a3b8", minHeight: 360,
          }}>
            <div style={{ fontSize: 48, marginBottom: 16 }}>💬</div>
            <div style={{ fontSize: 16, fontWeight: 700, color: "#475569", marginBottom: 6 }}>
              Select a Patient
            </div>
            <div style={{ fontSize: 13, textAlign: "center", maxWidth: 240 }}>
              Choose a patient from the list to compose a message
            </div>
          </div>
        ) : (
          <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>

            {/* Patient banner */}
            <div style={{
              background: "white", borderRadius: 16, border: "1px solid #e2e8f0",
              padding: 16, display: "flex", alignItems: "center", gap: 14,
            }}>
              <div style={{
                width: 44, height: 44, borderRadius: "50%",
                background: `${complianceColor(msgPatient.compliance)}22`,
                border: `2px solid ${complianceColor(msgPatient.compliance)}`,
                display: "flex", alignItems: "center", justifyContent: "center",
                fontSize: 13, fontWeight: 800, color: complianceColor(msgPatient.compliance),
                flexShrink: 0,
              }}>
                {msgPatient.avatar}
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 15, fontWeight: 800, color: "#0f172a" }}>{msgPatient.name}</div>
                <div style={{ fontSize: 12, color: "#64748b" }}>
                  {msgPatient.conditions.join(", ")} · Last active {msgPatient.lastActive}
                </div>
              </div>
              <ComplianceRing score={msgPatient.compliance} size={44} />
            </div>

            {/* Quick templates */}
            <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 16 }}>
              <div style={{ fontSize: 11, fontWeight: 700, color: "#64748b", marginBottom: 10, textTransform: "uppercase", letterSpacing: 0.5 }}>
                Quick Templates
              </div>
              <div style={{ display: "flex", flexWrap: "wrap", gap: 8 }}>
                {[
                  "Please take your medicine as scheduled today.",
                  "Reminder: Log your blood pressure reading.",
                  `Your compliance is at ${msgPatient.compliance}% — keep it up!`,
                  "Please schedule a follow-up appointment.",
                  "Contact me immediately if your symptoms worsen.",
                  "Great progress this week! Keep up the routine.",
                ].map((t, i) => (
                  <button
                    key={i}
                    onClick={() => setMsgText(t)}
                    style={{
                      background: "#f1f5f9", color: "#475569",
                      padding: "6px 12px", borderRadius: 8, fontSize: 12, fontWeight: 500,
                      textAlign: "left", border: "none", cursor: "pointer",
                      transition: "all 0.15s",
                    }}
                    onMouseEnter={e => { e.currentTarget.style.background = "#eff6ff"; e.currentTarget.style.color = "#1e40af"; }}
                    onMouseLeave={e => { e.currentTarget.style.background = "#f1f5f9"; e.currentTarget.style.color = "#475569"; }}
                  >
                    {t}
                  </button>
                ))}
              </div>
            </div>

            {/* Compose */}
            <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 16 }}>
              <div style={{ fontSize: 11, fontWeight: 700, color: "#64748b", marginBottom: 10, textTransform: "uppercase", letterSpacing: 0.5 }}>
                Compose Message
              </div>
              <textarea
                value={msgText}
                onChange={e => setMsgText(e.target.value)}
                placeholder={`Write a message to ${msgPatient.name}…`}
                rows={4}
                style={{
                  width: "100%", padding: "12px 14px",
                  border: "1px solid #e2e8f0", borderRadius: 10,
                  fontSize: 13, resize: "vertical", outline: "none",
                  background: "#f8fafc", fontFamily: "inherit",
                  transition: "border-color 0.15s", boxSizing: "border-box",
                }}
                onFocus={e => (e.target.style.borderColor = "#1e40af")}
                onBlur={e => (e.target.style.borderColor = "#e2e8f0")}
                onKeyDown={e => {
                  if (e.key === "Enter" && (e.metaKey || e.ctrlKey)) sendMessage();
                }}
              />
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 10 }}>
                <span style={{ fontSize: 11, color: "#94a3b8" }}>
                  {msgText.length} chars · Ctrl+Enter to send
                </span>
                <button
                  onClick={sendMessage}
                  disabled={!msgText.trim()}
                  style={{
                    background: msgText.trim() ? "#1e40af" : "#e2e8f0",
                    color: msgText.trim() ? "white" : "#94a3b8",
                    padding: "8px 20px", borderRadius: 10,
                    fontSize: 13, fontWeight: 700, border: "none",
                    cursor: msgText.trim() ? "pointer" : "default",
                    transition: "all 0.2s",
                    boxShadow: msgText.trim() ? "0 4px 12px rgba(30,64,175,0.25)" : "none",
                  }}
                >
                  Send →
                </button>
              </div>
            </div>

            {/* Sent history */}
            {sentMsgs.filter(m => m.pid === msgPatient.id).length > 0 && (
              <div style={{ background: "white", borderRadius: 16, border: "1px solid #e2e8f0", padding: 16 }}>
                <div style={{ fontSize: 11, fontWeight: 700, color: "#64748b", marginBottom: 12, textTransform: "uppercase", letterSpacing: 0.5 }}>
                  Sent Messages ({sentMsgs.filter(m => m.pid === msgPatient.id).length})
                </div>
                {[...sentMsgs].reverse().filter(m => m.pid === msgPatient.id).map((m, i) => (
                  <div key={i} style={{
                    background: "#eff6ff", borderRadius: 10,
                    padding: "10px 14px", marginBottom: 8,
                    borderLeft: "3px solid #1e40af",
                  }}>
                    <div style={{ fontSize: 13, color: "#0f172a", lineHeight: 1.45 }}>{m.text}</div>
                    <div style={{ fontSize: 10, color: "#94a3b8", marginTop: 4 }}>
                      Dr. Nair · {m.time}
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
