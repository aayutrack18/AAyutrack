import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/router/app_router.dart';
import 'package:aayutrack/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:aayutrack/features/auth/presentation/widgets/auth_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    debugPrint('Google button tapped');

    final messenger = ScaffoldMessenger.of(context);
    final container = ProviderScope.containerOf(context, listen: false);

    messenger.showSnackBar(
      const SnackBar(content: Text('Starting Google sign-in...')),
    );

    try {
      final success = await container
          .read(authStateNotifierProvider.notifier)
          .signInWithGoogle();

      if (!context.mounted) return;

      final authState = container.read(authStateNotifierProvider);

      debugPrint('Google sign-in success = $success');
      debugPrint('Google sign-in error = ${authState.errorMessage}');

      if (success) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Google sign-in successful.')),
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.welcome,
          (route) => false,
        );
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              authState.errorMessage ?? 'Google sign-in failed.',
            ),
          ),
        );
      }
    } catch (e, st) {
      debugPrint('Google sign-in crashed: $e');
      debugPrint('$st');

      if (!context.mounted) return;

      messenger.showSnackBar(
        SnackBar(content: Text('Google sign-in crashed: $e')),
      );
    }
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
                    Navigator.pushNamed(context, AppRouter.phoneLogin);
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                const AuthDivider(),
                const SizedBox(height: AppSpacing.md),
                SecondaryAuthButton(
                  label: 'Continue with Google',
                  leading: const Icon(Icons.g_mobiledata_rounded, size: 28),
                  onPressed: () => _handleGoogleSignIn(context),
                ),
                const SizedBox(height: AppSpacing.md),
                SecondaryAuthButton(
                  label: 'Sign in with Email',
                  leading: const Icon(Icons.email_outlined, size: 20),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.emailLogin);
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