import type { VitalReading } from "../types";

export function VitalChart({ readings, color, unit }: { readings: VitalReading[]; color: string; unit: string }) {
  if (!readings.length)
    return <div style={{ color: "#94a3b8", fontSize: 13, padding: "12px 0" }}>No data</div>;

  const vals = readings.map(r => r.value);
  const min = Math.min(...vals) - 5;
  const max = Math.max(...vals) + 5;
  const range = max - min || 1;
  const W = 280, H = 80;

  const pts = readings.map((r, i) => {
    const x = readings.length === 1 ? W / 2 : (i / (readings.length - 1)) * (W - 20) + 10;
    const y = H - ((r.value - min) / range) * (H - 20) - 10;
    return { x, y, r };
  });

  const pathD =
    pts.length === 1
      ? `M ${pts[0].x} ${pts[0].y}`
      : pts.map((p, i) => (i === 0 ? `M ${p.x} ${p.y}` : `L ${p.x} ${p.y}`)).join(" ");

  const areaD =
    pts.length === 1
      ? ""
      : `${pathD} L ${pts[pts.length - 1].x} ${H} L ${pts[0].x} ${H} Z`;

  const gradId = `g-${color.replace("#", "")}`;
  const last = readings[readings.length - 1];

  return (
    <div style={{ position: "relative" }}>
      <svg width={W} height={H} style={{ overflow: "visible" }}>
        <defs>
          <linearGradient id={gradId} x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor={color} stopOpacity="0.2" />
            <stop offset="100%" stopColor={color} stopOpacity="0" />
          </linearGradient>
        </defs>
        {areaD && <path d={areaD} fill={`url(#${gradId})`} />}
        <polyline
          points={pts.map(p => `${p.x},${p.y}`).join(" ")}
          fill="none"
          stroke={color}
          strokeWidth="2.5"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
        {pts.map((p, i) => (
          <g key={i}>
            <circle cx={p.x} cy={p.y} r="4" fill="white" stroke={color} strokeWidth="2" />
            <text x={p.x} y={H + 14} textAnchor="middle" fontSize="9" fill="#94a3b8" fontWeight="600">
              {p.r.date.replace("Mar ", "")}
            </text>
          </g>
        ))}
      </svg>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 8 }}>
        <span style={{ fontSize: 11, color: "#94a3b8" }}>
          Latest:{" "}
          <strong style={{ color }}>
            {last.value}
            {last.secondary ? `/${last.secondary}` : ""} {unit}
          </strong>
        </span>
        <span style={{ fontSize: 11, color: "#94a3b8" }}>{last.date}</span>
      </div>
    </div>
  );
}
