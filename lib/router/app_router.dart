import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/features/auth/presentation/screens/create_account_screen.dart';
import 'package:aayutrack/features/auth/presentation/screens/email_login_screen.dart';
import 'package:aayutrack/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:aayutrack/features/auth/presentation/screens/otp_screen.dart';
import 'package:aayutrack/features/auth/presentation/screens/phone_login_screen.dart';
import 'package:aayutrack/features/auth/presentation/screens/splash_screen.dart';
import 'package:aayutrack/features/auth/presentation/screens/welcome_screen.dart';
import 'package:aayutrack/features/compliance/presentation/screens/compliance_overview_screen.dart';
import 'package:aayutrack/features/compliance/presentation/screens/risk_alerts_screen.dart';
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';
import 'package:aayutrack/features/health_logs/presentation/screens/add_health_log_screen.dart';
import 'package:aayutrack/features/health_logs/presentation/screens/edit_health_log_screen.dart';
import 'package:aayutrack/features/health_logs/presentation/screens/health_log_history_screen.dart';
import 'package:aayutrack/features/health_logs/presentation/screens/health_logs_dashboard_screen.dart';
import 'package:aayutrack/features/health_logs/presentation/screens/metric_detail_screen.dart';
import 'package:aayutrack/features/medicine/domain/entities/medicine.dart';
import 'package:aayutrack/features/medicine/presentation/screens/add_medicine_screen.dart';
import 'package:aayutrack/features/medicine/presentation/screens/medicine_detail_screen.dart';
import 'package:aayutrack/features/medicine/presentation/screens/medicine_list_screen.dart';
import 'package:aayutrack/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:aayutrack/features/profile/presentation/screens/patient_onboarding_screen.dart';
import 'package:aayutrack/features/profile/presentation/screens/patient_profile_screen.dart';
import 'package:aayutrack/features/profile/presentation/screens/profile_gate_screen.dart';
import 'package:aayutrack/features/reminders/domain/entities/reminder.dart';
import 'package:aayutrack/features/reminders/presentation/screens/add_reminder_screen.dart';
import 'package:aayutrack/features/reminders/presentation/screens/edit_reminder_screen.dart';
import 'package:aayutrack/features/reminders/presentation/screens/notification_settings_screen.dart';
import 'package:aayutrack/features/reminders/presentation/screens/reminder_list_screen.dart';
import 'package:aayutrack/features/reports/presentation/screens/report_pdf_design_screen.dart';
import 'package:aayutrack/features/reports/presentation/screens/report_preview_screen.dart';
import 'package:aayutrack/features/reports/presentation/screens/reports_screen.dart';
import 'package:aayutrack/features/shell/presentation/main_shell.dart';
import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ── Auth ──────────────────────────────────────────────────────────
      case AppRoutes.splash:
        return _fade(const SplashScreen(), settings);

      case AppRoutes.welcome:
        return _fade(const WelcomeScreen(), settings);

      case AppRoutes.phoneLogin:
        return _slide(const PhoneLoginScreen(), settings);

      case AppRoutes.otp:
        final args = settings.arguments as Map<String, dynamic>?;
        return _slide(
          OtpScreen(phoneNumber: args?['phoneNumber'] as String? ?? ''),
          settings,
        );

      case AppRoutes.emailLogin:
        return _slide(const EmailLoginScreen(), settings);

      case AppRoutes.createAccount:
        return _slide(const CreateAccountScreen(), settings);

      case AppRoutes.forgotPassword:
        return _slide(const ForgotPasswordScreen(), settings);

      // ── Profile ───────────────────────────────────────────────────────
      case AppRoutes.profileGate:
        return _slide(const ProfileGateScreen(), settings);

      case AppRoutes.patientOnboarding:
        return _slide(const PatientOnboardingScreen(), settings);

      case AppRoutes.patientProfile:
        return _slide(const PatientProfileScreen(), settings);

      case AppRoutes.editProfile:
        return _slide(const EditProfileScreen(), settings);

      // ── Main Shell ────────────────────────────────────────────────────
      case AppRoutes.home:
        return _fade(const MainShell(), settings);

      // ── Medicines ─────────────────────────────────────────────────────
      case AppRoutes.medicineList:
        return _slide(const MedicineListScreen(), settings);

      case AppRoutes.addMedicine:
        return _slide(const AddMedicineScreen(), settings);

      case AppRoutes.editMedicine:
        final medicine = settings.arguments as Medicine?;
        return _slide(AddMedicineScreen(existing: medicine), settings);

      case AppRoutes.medicineDetail:
        final medicine = settings.arguments as Medicine;
        return _slide(MedicineDetailScreen(medicine: medicine), settings);

      // ── Reminders ─────────────────────────────────────────────────────
      case AppRoutes.reminderList:
        return _slide(const ReminderListScreen(), settings);

      case AppRoutes.addReminder:
        return _slide(const AddReminderScreen(), settings);

      case AppRoutes.editReminder:
        final reminder = settings.arguments as Reminder;
        return _slide(EditReminderScreen(reminder: reminder), settings);

      case AppRoutes.notificationSettings:
        return _slide(const NotificationSettingsScreen(), settings);

      // ── Health Logs ───────────────────────────────────────────────────
      case AppRoutes.healthLogsDashboard:
        return _slide(const HealthLogsDashboardScreen(), settings);

      case AppRoutes.addHealthLog:
        return _slide(const AddHealthLogScreen(), settings);

      case AppRoutes.editHealthLog:
        final log = settings.arguments as HealthLog;
        return _slide(EditHealthLogScreen(log: log), settings);

      case AppRoutes.healthLogHistory:
        return _slide(const HealthLogHistoryScreen(), settings);

      case AppRoutes.metricDetail:
        final metricType = settings.arguments as MetricType;
        return _slide(MetricDetailScreen(metricType: metricType), settings);

      // ── Compliance ────────────────────────────────────────────────────
      case AppRoutes.complianceOverview:
        return _slide(const ComplianceOverviewScreen(), settings);

      case AppRoutes.riskAlerts:
        return _slide(const RiskAlertsScreen(), settings);

      // ── Reports ───────────────────────────────────────────────────────
      case AppRoutes.reports:
        return _slide(const ReportsScreen(), settings);

      case AppRoutes.reportPreview:
        return _slide(const ReportPreviewScreen(), settings);

      case AppRoutes.reportPdfDesign:
        return _slide(const ReportPdfDesignScreen(), settings);

      default:
        return _fade(const WelcomeScreen(), settings);
    }
  }

  static PageRouteBuilder<dynamic> _fade(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static PageRouteBuilder<dynamic> _slide(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 320),
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween<Offset>(
          begin: const Offset(0.08, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}
