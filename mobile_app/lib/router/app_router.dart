import 'package:flutter/material.dart';

import '../features/auth/presentation/screens/create_account_screen.dart';
import '../features/auth/presentation/screens/email_login_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/otp_screen.dart';
import '../features/auth/presentation/screens/phone_login_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/welcome_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String phoneLogin = '/phone-login';
  static const String otp = '/otp';
  static const String emailLogin = '/email-login';
  static const String createAccount = '/create-account';
  static const String forgotPassword = '/forgot-password';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _materialRoute(const SplashScreen(), settings);

      case welcome:
        return _materialRoute(const WelcomeScreen(), settings);

      case phoneLogin:
        return _materialRoute(const PhoneLoginScreen(), settings);

      case otp:
        final args = settings.arguments as Map<String, dynamic>?;
        final phoneNumber = args?['phoneNumber'] as String?;

        if (phoneNumber == null || phoneNumber.isEmpty) {
          return _errorRoute(
            'Phone number not provided for OTP screen.',
            settings,
          );
        }

        return _materialRoute(
          OtpScreen(phoneNumber: phoneNumber),
          settings,
        );

      case emailLogin:
        return _materialRoute(const EmailLoginScreen(), settings);

      case createAccount:
        return _materialRoute(const CreateAccountScreen(), settings);

      case forgotPassword:
        return _materialRoute(const ForgotPasswordScreen(), settings);

      default:
        return _errorRoute('Route not found', settings);
    }
  }

  static MaterialPageRoute _materialRoute(
    Widget screen,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(
      builder: (_) => screen,
      settings: settings,
    );
  }

  static MaterialPageRoute _errorRoute(
    String message,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text(message),
        ),
      ),
      settings: settings,
    );
  }
}