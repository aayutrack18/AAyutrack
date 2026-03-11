import 'package:flutter/material.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/features/auth/presentation/widgets/auth_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _showGoogleDemo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Google sign-in UI ready. Firebase logic will be added next.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          const AppLogo(size: 84),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppStrings.appName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.appSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          const AuthHeader(
            title: AppStrings.welcomeHeadline,
            subtitle: AppStrings.welcomeDescription,
            center: true,
          ),
          const SizedBox(height: AppSpacing.xxxl),
          GlassCard(
            child: Column(
              children: [
                PrimaryAuthButton(
                  label: 'Continue with Phone',
                  icon: Icons.phone_iphone_rounded,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.phoneLogin);
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                const AuthDivider(),
                const SizedBox(height: AppSpacing.md),
                SecondaryAuthButton(
                  label: 'Continue with Google',
                  leading: const Icon(Icons.g_mobiledata_rounded, size: 28),
                  onPressed: () => _showGoogleDemo(context),
                ),
                const SizedBox(height: AppSpacing.md),
                SecondaryAuthButton(
                  label: 'Sign in with Email',
                  leading: const Icon(Icons.email_outlined, size: 20),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.emailLogin);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const TrustNote(text: AppStrings.secureAccess),
        ],
      ),
    );
  }
}
