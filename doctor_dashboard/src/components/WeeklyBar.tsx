export function WeeklyBar({ data }: { data: number[] }) {
  const days = ["M", "T", "W", "T", "F", "S", "S"];
  return (
    <div style={{ display: "flex", alignItems: "flex-end", gap: 4, height: 48 }}>
      {data.map((v, i) => {
        const barColor = v >= 90 ? "#10b981" : v >= 60 ? "#f59e0b" : "#ef4444";
        return (
          <div key={i} style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", gap: 2 }}>
            <div style={{
              width: "100%",
              height: `${(v / 100) * 36}px`,
              background: barColor,
              borderRadius: 3,
              transition: "height 0.5s ease",
              minHeight: 2,
            }} />
            <span style={{ fontSize: 9, color: "#94a3b8", fontWeight: 600 }}>{days[i]}</span>
          </div>
        );
      })}
    </div>
  );
}
