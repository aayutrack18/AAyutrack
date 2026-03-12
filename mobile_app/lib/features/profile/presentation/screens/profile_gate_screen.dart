import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/profile/presentation/providers/profile_provider.dart';
import 'package:aayutrack/features/profile/presentation/providers/profile_state.dart';

class ProfileGateScreen extends ConsumerWidget {
  const ProfileGateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    if (profileState.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: LoadingIndicator(message: 'Loading profile...'),
      );
    }

    if (profileState.hasProfile) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      });
      return const SizedBox.shrink();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, AppRoutes.patientOnboarding);
    });
    return const SizedBox.shrink();
  }
}
