import { Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import { DashboardProvider } from "./context/DashboardContext";
import { ProtectedRoute } from "./routes/ProtectedRoute";
import { DashboardLayout } from "./layout/DashboardLayout";
import { LoginPage } from "./pages/LoginPage";
import { OverviewPage } from "./pages/OverviewPage";
import { PatientsPage } from "./pages/PatientsPage";
import { PatientDetailPage } from "./pages/PatientDetailPage";
import { AlertsPage } from "./pages/AlertsPage";
import { AnalyticsPage } from "./pages/AnalyticsPage";
import { ReportsPage } from "./pages/ReportsPage";
import { MessagesPage } from "./pages/MessagesPage";
import { NotFoundPage } from "./pages/NotFoundPage";

const GlobalStyles = () => (
  <style>{`
    @import url('https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800;900&display=swap');
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    ::-webkit-scrollbar { width: 6px; height: 6px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 3px; }
    input, textarea, select { font-family: inherit; }
    button { font-family: inherit; cursor: pointer; border: none; outline: none; }
    body { font-family: 'DM Sans', system-ui, sans-serif; background: #f8fafc; }
    a { text-decoration: none; color: inherit; }
  `}</style>
);

export default function App() {
  return (
    <AuthProvider>
      <DashboardProvider>
        <GlobalStyles />
        <Routes>
          {/* Public */}
          <Route path="/login" element={<LoginPage />} />

          {/* Protected — all inside DashboardLayout shell */}
          <Route
            element={
              <ProtectedRoute>
                <DashboardLayout />
              </ProtectedRoute>
            }
          >
            <Route path="/dashboard"       element={<OverviewPage />} />
            <Route path="/patients"        element={<PatientsPage />} />
            <Route path="/patients/:id"    element={<PatientDetailPage />} />
            <Route path="/alerts"          element={<AlertsPage />} />
            <Route path="/analytics"       element={<AnalyticsPage />} />
            <Route path="/reports"         element={<ReportsPage />} />
            <Route path="/messages"        element={<MessagesPage />} />
          </Route>

          {/* Redirects + 404 */}
          <Route path="/" element={<Navigate to="/dashboard" replace />} />
          <Route path="*" element={<NotFoundPage />} />
        </Routes>
      </DashboardProvider>
    </AuthProvider>
  );
}
