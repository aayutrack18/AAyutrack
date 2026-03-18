import { useEffect, useState } from "react";
import { Outlet } from "react-router-dom";
import { Topbar } from "./Topbar";

export function DashboardLayout() {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    const t = setTimeout(() => setVisible(true), 60);
    return () => clearTimeout(t);
  }, []);

  return (
    <div style={{
      fontFamily: "'DM Sans', system-ui, sans-serif",
      background: "#f8fafc",
      minHeight: "100vh",
      display: "flex",
      flexDirection: "column",
      opacity: visible ? 1 : 0,
      transition: "opacity 0.3s ease",
    }}>
      <Topbar />
      <main style={{
        flex: 1,
        padding: "28px 28px",
        maxWidth: 1320,
        margin: "0 auto",
        width: "100%",
        boxSizing: "border-box",
      }}>
        <Outlet />
      </main>
    </div>
  );
}
