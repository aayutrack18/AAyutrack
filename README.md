# AAYUTRACK

Digital Compliance & Remote Patient Monitoring Platform built with Flutter and Firebase.

## Overview

AAYUTRACK is a healthtech application focused on patient compliance, medication tracking, reminders, health logs, profile management, reports, and authentication flows including email, Google Sign-In, guest login, and phone OTP.

## Current Modules

- Authentication
- Compliance
- Dashboard
- Health Logs
- Medicine Management
- Patient Profile
- Reminders
- Reports
- Main Shell Navigation

## Tech Stack

- Flutter
- Riverpod
- Firebase Auth
- Cloud Firestore
- Firebase Core
- Google Sign-In

## Project Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── widgets/
├── features/
│   ├── auth/
│   ├── compliance/
│   ├── dashboard/
│   ├── health_logs/
│   ├── medicine/
│   ├── profile/
│   ├── reminders/
│   ├── reports/
│   └── shell/
├── firebase_options.dart
├── main.dart
└── router/