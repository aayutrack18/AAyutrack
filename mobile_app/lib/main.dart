import 'package:flutter/material.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/router/app_router.dart';
import 'package:aayutrack/core/constants/app_constants.dart';

void main() {
  runApp(const AayuTrackApp());
}

class AayuTrackApp extends StatelessWidget {
  const AayuTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}