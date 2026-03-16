# AAYUTRACK — Doctor Dashboard

Remote Patient Monitoring & Digital Compliance Web App

## Tech Stack
- React 18 + TypeScript
- Vite (build tool)
- DM Sans font (via Google Fonts)
- 100% custom CSS (no UI library dependencies)

## Features
- **Overview** — KPI cards, patient list with compliance rings, recent alerts, appointments
- **Patients** — Search/filter, compliance cards, drill-down with vital charts, medicine adherence bars, alert management
- **Alerts** — Severity-filtered alert feed, mark-as-read, navigate to patient
- **Reports** — Compliance table, medicine adherence breakdown, weekly sparklines
- **Messages** — Patient messaging with quick templates and sent history

## Getting Started
```bash
npm install
npm run dev
```

Open http://localhost:3000

## Build for Production
```bash
npm run build
npm run preview
```

## Mock Data
The dashboard uses mock data representing 4 patients:
- Rahul Sharma — T2 Diabetes + Hypertension (78% compliance)
- Sunita Patel — Asthma + Hypothyroidism (92% compliance)
- Arjun Menon — Rheumatoid Arthritis (61% compliance — at risk)
- Meera Iyer — Heart Failure + CKD (88% compliance)

## Backend Integration
Replace mock `PATIENTS` array with API calls to your Firebase Firestore backend.
All TypeScript interfaces are defined at the top of `src/App.tsx`.
