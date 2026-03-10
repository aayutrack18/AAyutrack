import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../features/auth/presentation/screens/welcome_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/otp_verification_screen.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcome:
        return _fadeRoute(const WelcomeScreen(), settings);

      case AppRoutes.login:
        return _slideRoute(const LoginScreen(), settings);

      case AppRoutes.otp:
        final args = settings.arguments as Map<String, dynamic>?;
        final phone = args?['phone'] as String? ?? '';
        return _slideRoute(
          OtpVerificationScreen(phoneNumber: phone),
          settings,
        );

      default:
        return _fadeRoute(const WelcomeScreen(), settings);
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        return FadeTransition(opacity: anim, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: anim.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 380),
    );
  }
}