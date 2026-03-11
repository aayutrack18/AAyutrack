import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/features/auth/presentation/screens/create_account_screen.dart';
import 'package:aayutrack/features/auth/presentation/screens/email_login_screen.dart';
import 'package:aayutrack/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:aayutrack/features/auth/presentation/screens/otp_screen.dart';
import 'package:aayutrack/features/auth/presentation/screens/phone_login_screen.dart';
import 'package:aayutrack/features/auth/presentation/screens/splash_screen.dart';
import 'package:aayutrack/features/auth/presentation/screens/welcome_screen.dart';
import 'package:aayutrack/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:aayutrack/features/profile/presentation/screens/patient_onboarding_screen.dart';
import 'package:aayutrack/features/profile/presentation/screens/patient_profile_screen.dart';
import 'package:aayutrack/features/profile/presentation/screens/profile_gate_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _fade(const SplashScreen(), settings);

      case AppRoutes.welcome:
        return _fade(const WelcomeScreen(), settings);

      case AppRoutes.phoneLogin:
        return _slide(const PhoneLoginScreen(), settings);

      case AppRoutes.otp:
        final args = settings.arguments as Map<String, dynamic>?;
        return _slide(
          OtpScreen(
            phoneNumber: args?['phoneNumber'] as String? ?? '',
          ),
          settings,
        );

      case AppRoutes.emailLogin:
        return _slide(const EmailLoginScreen(), settings);

      case AppRoutes.createAccount:
        return _slide(const CreateAccountScreen(), settings);

      case AppRoutes.forgotPassword:
        return _slide(const ForgotPasswordScreen(), settings);

      case AppRoutes.profileGate:
        return _slide(const ProfileGateScreen(), settings);

      case AppRoutes.patientOnboarding:
        return _slide(const PatientOnboardingScreen(), settings);

      case AppRoutes.patientProfile:
        return _slide(const PatientProfileScreen(), settings);

      case AppRoutes.editProfile:
        return _slide(const EditProfileScreen(), settings);

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
        return FadeTransition(
          opacity: animation,
          child: child,
        );
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
        ).chain(
          CurveTween(curve: Curves.easeOutCubic),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}
