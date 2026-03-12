class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String phoneLogin = '/phone-login';
  static const String otp = '/otp';
  static const String emailLogin = '/email-login';
  static const String createAccount = '/create-account';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
}

class AppStrings {
  AppStrings._();

  static const String appName = 'AAYUTRACK';
  static const String appSubtitle =
      'Digital compliance & remote patient monitoring';
  static const String welcomeHeadline = 'Stay on track with every dose';
  static const String welcomeDescription =
      'Remote patient monitoring and digital compliance designed for better care.';
  static const String secureAccess =
      'Secure access for patients, caregivers, and clinicians';
  static const int otpLength = 6;
  static const int resendSeconds = 30;
}

class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double huge = 56;
}

class AppRadius {
  AppRadius._();

  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 28;
  static const double pill = 999;
}

class AppSizes {
  AppSizes._();

  static const double buttonHeight = 56;
  static const double inputHeight = 58;
  static const double otpBox = 52;
  static const double maxContentWidth = 460;
}