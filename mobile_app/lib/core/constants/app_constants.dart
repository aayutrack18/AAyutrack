class AppConstants {
  AppConstants._();

  static const String appName = 'AAYUTRACK';
  static const String appTagline =
      'Track care. Improve compliance. Stay connected.';
  static const String appSubtitle =
      'Digital Compliance & Remote Patient Monitoring';

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 14.0;
  static const double radiusL = 20.0;
  static const double radiusXL = 28.0;
  static const double radiusFull = 100.0;

  // OTP
  static const int otpLength = 6;
  static const int resendTimeoutSeconds = 30;

  // Default country code
  static const String defaultCountryCode = '+91';
  static const String defaultCountryFlag = '🇮🇳';
}

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String dashboard = '/dashboard';
}