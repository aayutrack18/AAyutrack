interface StatCardProps {
  label: string;
  value: string | number;
  sub: string;
  color: string;
  bg: string;
  icon: string;
}

export function StatCard({ label, value, sub, color, bg, icon }: StatCardProps) {
  return (
    <div style={{
      background: "white",
      borderRadius: 16,
      padding: 20,
      border: "1px solid #e2e8f0",
      boxShadow: "0 1px 4px rgba(0,0,0,0.04)",
      transition: "box-shadow 0.2s",
    }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 12 }}>
        <div style={{ fontSize: 22 }}>{icon}</div>
        <div style={{
          background: bg, color,
          fontSize: 11, fontWeight: 700,
          padding: "3px 10px", borderRadius: 20,
        }}>
          {sub}
        </div>
      </div>
      <div style={{ fontSize: 32, fontWeight: 900, color, lineHeight: 1 }}>{value}</div>
      <div style={{ fontSize: 13, color: "#64748b", marginTop: 5, fontWeight: 500 }}>{label}</div>
    </div>
  );
}
