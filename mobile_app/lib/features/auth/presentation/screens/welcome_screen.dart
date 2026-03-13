import 'package:flutter/material.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/features/auth/presentation/widgets/auth_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _showGoogleDemo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Google sign-in UI ready. Firebase logic will be added next.'),
        behavior: SnackBarBehavior.floating,
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
          const AppLogo(size: 88),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppStrings.appName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.appSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          const AuthHeader(
            title: AppStrings.welcomeHeadline,
            subtitle: AppStrings.welcomeDescription,
            center: true,
          ),
          const SizedBox(height: AppSpacing.xxl),
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
                const SizedBox(height: AppSpacing.sm),
                SecondaryAuthButton(
                  label: 'Sign in with Email',
                  leading: const Icon(Icons.email_outlined, size: 20),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.emailLogin);
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.createAccount);
                  },
                  child: const Text(
                    "Don't have an account? Create one",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const TrustNote(text: AppStrings.secureAccess),
          const SizedBox(height: AppSpacing.lg),
          // Demo shortcut
          GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (r) => false,
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.rocket_launch_rounded,
                      color: AppColors.accent, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Demo: Skip to App →',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
