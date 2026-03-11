class AppRoutes {
  AppRoutes._();

  // Auth
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String phoneLogin = '/phone-login';
  static const String otp = '/otp';
  static const String emailLogin = '/email-login';
  static const String createAccount = '/create-account';
  static const String forgotPassword = '/forgot-password';

  // Profile
  static const String profileGate = '/profile-gate';
  static const String patientOnboarding = '/patient-onboarding';
  static const String patientProfile = '/patient-profile';
  static const String editProfile = '/edit-profile';

  // Main Shell
  static const String home = '/home';

  // Dashboard (legacy, redirects to home)
  static const String dashboard = '/home';

  // Medicine
  static const String medicineList = '/medicines';
  static const String addMedicine = '/medicines/add';
  static const String editMedicine = '/medicines/edit';
  static const String medicineDetail = '/medicines/detail';

  // Reminders
  static const String reminderList = '/reminders';
  static const String addReminder = '/reminders/add';
  static const String editReminder = '/reminders/edit';
  static const String notificationSettings = '/reminders/settings';

  // Health Logs
  static const String healthLogsDashboard = '/health-logs';
  static const String addHealthLog = '/health-logs/add';
  static const String healthLogHistory = '/health-logs/history';
  static const String metricDetail = '/health-logs/metric';

  // Compliance
  static const String complianceOverview = '/compliance';
  static const String riskAlerts = '/compliance/alerts';

  // Reports
  static const String reports = '/reports';
  static const String reportPreview = '/reports/preview';
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
  static const double xxxl = 56;
}

class AppSizes {
  AppSizes._();

  static const double iconXs = 14;
  static const double iconSm = 18;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  static const double buttonHeight = 54;
  static const double inputHeight = 56;
  static const double otpBoxSize = 52;

  static const double maxContentWidth = 420;
  static const double otpBox = 52;
}

class AppRadius {
  AppRadius._();

  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 22;
  static const double xxl = 28;
}

class AppStrings {
  AppStrings._();

  static const int otpLength = 6;
  static const int resendSeconds = 30;

  static const String appName = 'AAYUTRACK';
  static const String appSubtitle =
      'Digital Compliance & Remote Patient Monitoring';

  static const String welcomeTitle = 'Welcome to AAYUTRACK';
  static const String welcomeSubtitle =
      'Digital Compliance & Remote Patient Monitoring';

  static const String welcomeHeadline = 'Track health. Improve compliance.';
  static const String welcomeDescription =
      'Manage patient profile, medicines, reminders, and health logs with an offline-first experience built for modern remote care.';
  static const String secureAccess =
      'Secure access for patients, caregivers, and healthcare teams.';
}
