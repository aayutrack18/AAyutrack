import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/profile/presentation/providers/profile_provider.dart';

class ProfileGateScreen extends ConsumerStatefulWidget {
  const ProfileGateScreen({super.key});

  @override
  ConsumerState<ProfileGateScreen> createState() => _ProfileGateScreenState();
}

class _ProfileGateScreenState extends ConsumerState<ProfileGateScreen> {
  bool _didStartLoad = false;
  bool _didNavigate = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (_didStartLoad) return;
      _didStartLoad = true;
      await ref.read(profileProvider.notifier).loadProfile();
    });
  }

  void _navigateOnce(String routeName) {
    if (_didNavigate || !mounted) return;
    _didNavigate = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    if (!_didStartLoad || profileState.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: LoadingIndicator(message: 'Loading profile...'),
      );
    }

    if (profileState.hasError) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: AppColors.danger,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Unable to load profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  profileState.errorMessage ?? 'Something went wrong.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    await ref.read(profileProvider.notifier).loadProfile();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (profileState.hasProfile) {
      _navigateOnce(AppRoutes.home);
    } else {
      _navigateOnce(AppRoutes.patientOnboarding);
    }

    return const Scaffold(
      backgroundColor: AppColors.background,
      body: LoadingIndicator(message: 'Preparing your workspace...'),
    );
  }
}