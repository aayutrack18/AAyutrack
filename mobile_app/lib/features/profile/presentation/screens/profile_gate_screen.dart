import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/profile_provider.dart';

enum _ProfileGateViewState {
  loading,
  error,
}

class ProfileGateScreen extends ConsumerStatefulWidget {
  const ProfileGateScreen({super.key});

  @override
  ConsumerState<ProfileGateScreen> createState() => _ProfileGateScreenState();
}

class _ProfileGateScreenState extends ConsumerState<ProfileGateScreen> {
  _ProfileGateViewState _viewState = _ProfileGateViewState.loading;
  bool _hasStartedCheck = false;
  bool _hasNavigated = false;
  String? _localErrorMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runProfileCheck();
    });
  }

  Future<void> _runProfileCheck() async {
    if (_hasStartedCheck && _viewState == _ProfileGateViewState.loading) {
      return;
    }

    _hasStartedCheck = true;

    if (mounted) {
      setState(() {
        _viewState = _ProfileGateViewState.loading;
        _localErrorMessage = null;
      });
    }

    try {
      await ref.read(profileProvider.notifier).loadProfile();

      if (!mounted || _hasNavigated) return;

      final profileState = ref.read(profileProvider);

      if (profileState.errorMessage != null &&
          profileState.errorMessage!.trim().isNotEmpty) {
        setState(() {
          _viewState = _ProfileGateViewState.error;
          _localErrorMessage = profileState.errorMessage;
        });
        return;
      }

      if (profileState.profile != null && profileState.isProfileCompleted) {
        _navigateTo(AppRoutes.patientProfile);
      } else {
        _navigateTo(AppRoutes.patientOnboarding);
      }
    } catch (e) {
      if (!mounted || _hasNavigated) return;

      setState(() {
        _viewState = _ProfileGateViewState.error;
        _localErrorMessage =
            'Something went wrong while preparing the profile flow.';
      });
    }
  }

  void _navigateTo(String route) {
    if (!mounted || _hasNavigated) return;

    _hasNavigated = true;
    Navigator.pushReplacementNamed(context, route);
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSizes.maxContentWidth,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: AppColors.border,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 76,
                  width: 76,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.health_and_safety_rounded,
                    size: 38,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Preparing Your Profile',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Checking patient details and setting up your AAYUTRACK experience.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: const LinearProgressIndicator(
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildStatusItem(
                  icon: Icons.verified_user_outlined,
                  label: 'Checking profile availability',
                ),
                const SizedBox(height: AppSpacing.md),
                _buildStatusItem(
                  icon: Icons.folder_shared_outlined,
                  label: 'Preparing local profile state',
                ),
                const SizedBox(height: AppSpacing.md),
                _buildStatusItem(
                  icon: Icons.route_outlined,
                  label: 'Routing to the correct next screen',
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'This may take a moment on first launch.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.check_circle_outline_rounded,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);
    final errorText =
        (_localErrorMessage != null && _localErrorMessage!.trim().isNotEmpty)
            ? _localErrorMessage!
            : 'Unable to load the profile state right now.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSizes.maxContentWidth,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: AppColors.border,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 76,
                  width: 76,
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    size: 38,
                    color: AppColors.danger,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Profile Check Failed',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  errorText,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton.icon(
                    onPressed: _runProfileCheck,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: OutlinedButton.icon(
                    onPressed: () => _navigateTo(AppRoutes.patientOnboarding),
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    label: const Text('Continue to Onboarding'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (_viewState) {
      case _ProfileGateViewState.loading:
        body = _buildLoadingState(context);
        break;
      case _ProfileGateViewState.error:
        body = _buildErrorState(context);
        break;
    }

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: body,
        ),
      ),
    );
  }
}
