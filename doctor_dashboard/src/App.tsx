import { useState, useEffect } from "react";
import type { TabId } from "./types";
import { AuthProvider } from "./context/AuthContext";
import { DashboardProvider, useDashboard } from "./context/DashboardContext";
import { ProtectedRoute } from "./routes/ProtectedRoute";
import { Topbar } from "./layout/Topbar";
import { OverviewPage } from "./pages/OverviewPage";
import { PatientsPage } from "./pages/PatientsPage";
import { AlertsPage } from "./pages/AlertsPage";
import { ReportsPage } from "./pages/ReportsPage";
import { MessagesPage } from "./pages/MessagesPage";

const GlobalStyles = () => (
  <style>{`
    @import url('https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800;900&display=swap');
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    ::-webkit-scrollbar { width: 6px; height: 6px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 3px; }
    input, textarea, select { font-family: inherit; }
    button { font-family: inherit; cursor: pointer; border: none; outline: none; }
    body { font-family: 'DM Sans', system-ui, sans-serif; }
  `}</style>
);

function DashboardShell() {
  const [activeTab, setActiveTab] = useState<TabId>("overview");
  const [isLoaded, setIsLoaded] = useState(false);
  const { patients } = useDashboard();

  useEffect(() => {
    const t = setTimeout(() => setIsLoaded(true), 80);
    return () => clearTimeout(t);
  }, []);

  // Compute alerts with patient reference here — single source of truth
  const allAlerts = patients.flatMap(p =>
    p.alerts.map(a => ({ ...a, patient: p }))
  );
  const unreadCount = allAlerts.filter(a => !a.isRead).length;

  return (
    <div style={{
      fontFamily: "'DM Sans', system-ui, sans-serif",
      background: "#f8fafc",
      minHeight: "100vh",
      display: "flex",
      flexDirection: "column",
      opacity: isLoaded ? 1 : 0,
      transition: "opacity 0.35s ease",
    }}>
      <GlobalStyles />

      <Topbar
        activeTab={activeTab}
        setActiveTab={setActiveTab}
        unreadCount={unreadCount}
      />

      <main style={{
        flex: 1,
        padding: "28px 24px",
        maxWidth: 1300,
        margin: "0 auto",
        width: "100%",
      }}>
        {activeTab === "overview" && (
          <OverviewPage
            setActiveTab={setActiveTab}
            allAlerts={allAlerts}
            unreadCount={unreadCount}
          />
        )}
        {activeTab === "patients" && (
          <PatientsPage setActiveTab={setActiveTab} />
        )}
        {activeTab === "alerts" && (
          <AlertsPage
            setActiveTab={setActiveTab}
            allAlerts={allAlerts}
          />
        )}
        {activeTab === "reports" && <ReportsPage />}
        {activeTab === "messages" && <MessagesPage />}
      </main>
    </div>
  );
}

export default function App() {
  return (
    <AuthProvider>
      <DashboardProvider>
        <ProtectedRoute>
          <DashboardShell />
        </ProtectedRoute>
      </DashboardProvider>
    </AuthProvider>
  );
}
