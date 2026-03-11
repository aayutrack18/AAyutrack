import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/patient_profile.dart';
import '../providers/profile_provider.dart';
import '../providers/profile_state.dart';
import '../widgets/profile_info_card.dart';

class PatientProfileScreen extends ConsumerStatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  ConsumerState<PatientProfileScreen> createState() =>
      _PatientProfileScreenState();
}

class _PatientProfileScreenState extends ConsumerState<PatientProfileScreen> {
  bool _isOpeningEdit = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(profileProvider.notifier).loadProfile();
    });
  }

  Future<void> _reloadProfile() async {
    await ref.read(profileProvider.notifier).loadProfile();
  }

  Future<void> _openEditProfile() async {
    if (_isOpeningEdit) return;

    setState(() {
      _isOpeningEdit = true;
    });

    try {
      await Navigator.pushNamed(context, AppRoutes.editProfile);

      if (!mounted) return;
      await ref.read(profileProvider.notifier).loadProfile();
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningEdit = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          child: _buildBody(context, profileState),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProfileState profileState) {
    if (profileState.isLoading && profileState.profile == null) {
      return const _ProfileLoadingView();
    }

    if (profileState.errorMessage != null && profileState.profile == null) {
      return _ProfileErrorView(
        message: profileState.errorMessage!,
        onRetry: _reloadProfile,
      );
    }

    if (profileState.profile == null) {
      return const _EmptyProfileView();
    }

    return _PatientProfileContent(
      profile: profileState.profile!,
      isRefreshing: profileState.isLoading,
      isOpeningEdit: _isOpeningEdit,
      onRefresh: _reloadProfile,
      onEditProfile: _openEditProfile,
      errorMessage: profileState.errorMessage,
    );
  }
}

class _PatientProfileContent extends StatelessWidget {
  final PatientProfile profile;
  final bool isRefreshing;
  final bool isOpeningEdit;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onEditProfile;
  final String? errorMessage;

  const _PatientProfileContent({
    required this.profile,
    required this.isRefreshing,
    required this.isOpeningEdit,
    required this.onRefresh,
    required this.onEditProfile,
    this.errorMessage,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'P';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  String _formatOptionalText(String value) {
    return value.trim().isEmpty ? 'Not provided' : value.trim();
  }

  String _formatOptionalNumber(double? value, String suffix) {
    if (value == null) return 'Not provided';
    return '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)} $suffix';
  }

  String _formatDateTime(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '$day/$month/$year • $hour:$minute';
  }

  int _calculateCompletionPercent(PatientProfile profile) {
    final checks = <bool>[
      profile.fullName.trim().isNotEmpty,
      profile.age > 0,
      profile.gender.trim().isNotEmpty,
      profile.phoneNumber.trim().isNotEmpty,
      profile.email.trim().isNotEmpty,
      profile.bloodGroup.trim().isNotEmpty,
      profile.heightCm != null,
      profile.weightKg != null,
      profile.address.trim().isNotEmpty,
      profile.allergies.trim().isNotEmpty,
      profile.medicalConditions.trim().isNotEmpty,
      profile.emergencyContactName.trim().isNotEmpty,
      profile.emergencyContactPhone.trim().isNotEmpty,
    ];

    final completed = checks.where((item) => item).length;
    return ((completed / checks.length) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding =
        screenWidth < AppSizes.maxContentWidth ? 16.0 : 22.0;
    final completionPercent = _calculateCompletionPercent(profile);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Column(
        children: [
          if (errorMessage != null && errorMessage!.trim().isNotEmpty)
            _InlineWarningBanner(message: errorMessage!),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                24,
              ),
              child: Column(
                children: [
                  _ProfileHeaderCard(
                    profile: profile,
                    initials: _getInitials(profile.fullName),
                    completionPercent: completionPercent,
                    isRefreshing: isRefreshing,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _QuickActionsCard(
                    isEditLoading: isOpeningEdit,
                    onEditProfile: onEditProfile,
                    onRefresh: onRefresh,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ProfileInfoCard(
                    title: 'Personal Information',
                    icon: Icons.person_outline_rounded,
                    children: [
                      _ProfileDetailRow(
                        label: 'Full Name',
                        value: profile.fullName,
                      ),
                      _ProfileDetailRow(
                        label: 'Age',
                        value: '${profile.age} years',
                      ),
                      _ProfileDetailRow(
                        label: 'Gender',
                        value: profile.gender,
                      ),
                      _ProfileDetailRow(
                        label: 'Blood Group',
                        value: profile.bloodGroup,
                        isLast: true,
                      ),
                    ],
                  ),
                  ProfileInfoCard(
                    title: 'Contact Information',
                    icon: Icons.call_outlined,
                    children: [
                      _ProfileDetailRow(
                        label: 'Phone Number',
                        value: profile.phoneNumber,
                      ),
                      _ProfileDetailRow(
                        label: 'Email',
                        value: _formatOptionalText(profile.email),
                      ),
                      _ProfileDetailRow(
                        label: 'Address',
                        value: _formatOptionalText(profile.address),
                        isLast: true,
                      ),
                    ],
                  ),
                  ProfileInfoCard(
                    title: 'Health Information',
                    icon: Icons.monitor_heart_outlined,
                    children: [
                      _ProfileDetailRow(
                        label: 'Height',
                        value: _formatOptionalNumber(profile.heightCm, 'cm'),
                      ),
                      _ProfileDetailRow(
                        label: 'Weight',
                        value: _formatOptionalNumber(profile.weightKg, 'kg'),
                      ),
                      _ProfileDetailRow(
                        label: 'Allergies',
                        value: _formatOptionalText(profile.allergies),
                      ),
                      _ProfileDetailRow(
                        label: 'Medical Conditions',
                        value: _formatOptionalText(profile.medicalConditions),
                        isLast: true,
                      ),
                    ],
                  ),
                  ProfileInfoCard(
                    title: 'Emergency Contact',
                    icon: Icons.emergency_outlined,
                    children: [
                      _ProfileDetailRow(
                        label: 'Contact Name',
                        value:
                            _formatOptionalText(profile.emergencyContactName),
                      ),
                      _ProfileDetailRow(
                        label: 'Contact Phone',
                        value:
                            _formatOptionalText(profile.emergencyContactPhone),
                        isLast: true,
                      ),
                    ],
                  ),
                  ProfileInfoCard(
                    title: 'Profile Status',
                    icon: Icons.sync_outlined,
                    children: [
                      _ProfileDetailRow(
                        label: 'Sync Status',
                        value: profile.isSynced ? 'Synced' : 'Pending Sync',
                      ),
                      _ProfileDetailRow(
                        label: 'Created At',
                        value: _formatDateTime(profile.createdAt),
                      ),
                      _ProfileDetailRow(
                        label: 'Last Updated',
                        value: _formatDateTime(profile.updatedAt),
                        isLast: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              0,
              horizontalPadding,
              16,
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: isOpeningEdit ? null : onEditProfile,
                  icon: isOpeningEdit
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.edit_outlined),
                  label: Text(
                    isOpeningEdit ? 'Opening Editor...' : 'Edit Profile',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final PatientProfile profile;
  final String initials;
  final int completionPercent;
  final bool isRefreshing;

  const _ProfileHeaderCard({
    required this.profile,
    required this.initials,
    required this.completionPercent,
    required this.isRefreshing,
  });

  Color _statusColor(bool isSynced) {
    return isSynced ? AppColors.success : Colors.orange;
  }

  String _statusText(bool isSynced) {
    return isSynced ? 'Synced' : 'Pending Sync';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(profile.isSynced);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor:
                    theme.colorScheme.primary.withValues(alpha: 0.16),
                child: Text(
                  initials,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${profile.age} years • ${profile.gender} • ${profile.bloodGroup}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _StatusChip(
                          label: _statusText(profile.isSynced),
                          color: statusColor,
                          icon: profile.isSynced
                              ? Icons.cloud_done_outlined
                              : Icons.sync_problem_outlined,
                        ),
                        if (isRefreshing)
                          const _MiniLoadingChip(
                            label: 'Refreshing',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _CompletionCard(percent: completionPercent),
        ],
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  final bool isEditLoading;
  final Future<void> Function() onEditProfile;
  final Future<void> Function() onRefresh;

  const _QuickActionsCard({
    required this.isEditLoading,
    required this.onEditProfile,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileInfoCard(
      title: 'Quick Actions',
      icon: Icons.bolt_outlined,
      padding: const EdgeInsets.all(14),
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isEditLoading ? null : onRefresh,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Refresh'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isEditLoading ? null : onEditProfile,
                icon: isEditLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.edit_outlined),
                label: Text(isEditLoading ? 'Opening...' : 'Edit'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CompletionCard extends StatelessWidget {
  final int percent;

  const _CompletionCard({
    required this.percent,
  });

  String get _message {
    if (percent >= 100) return 'Profile completed';
    if (percent >= 70) return 'Almost complete';
    if (percent >= 40) return 'Good progress';
    return 'Complete more details';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (percent.clamp(0, 100)) / 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.task_alt_rounded, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Profile completion',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$percent%',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.black.withValues(alpha: 0.06),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniLoadingChip extends StatelessWidget {
  final String label;

  const _MiniLoadingChip({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 14,
            width: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _ProfileDetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  bool get _isNotProvided =>
      value.trim().toLowerCase() == 'not provided' || value.trim().isEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueColor =
        _isNotProvided ? AppColors.textMuted : AppColors.textPrimary;

    return Container(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      margin: EdgeInsets.only(bottom: isLast ? 0 : 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Colors.black.withValues(alpha: 0.06),
                ),
              ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 300;

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: valueColor,
                    fontWeight:
                        _isNotProvided ? FontWeight.w500 : FontWeight.w600,
                    fontStyle:
                        _isNotProvided ? FontStyle.italic : FontStyle.normal,
                    height: 1.4,
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 112,
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: valueColor,
                    fontWeight:
                        _isNotProvided ? FontWeight.w500 : FontWeight.w600,
                    fontStyle:
                        _isNotProvided ? FontStyle.italic : FontStyle.normal,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileLoadingView extends StatelessWidget {
  const _ProfileLoadingView();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width < AppSizes.maxContentWidth ? 16.0 : 22.0;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding:
          EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 24),
      child: Column(
        children: const [
          _SkeletonCard(height: 190),
          SizedBox(height: 16),
          _SkeletonCard(height: 92),
          SizedBox(height: 16),
          _SkeletonCard(height: 190),
          SizedBox(height: 16),
          _SkeletonCard(height: 190),
          SizedBox(height: 16),
          _SkeletonCard(height: 160),
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatefulWidget {
  final double height;

  const _SkeletonCard({
    required this.height,
  });

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.35, end: 0.75).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: double.infinity,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ProfileErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.red.withValues(alpha: 0.15),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: AppColors.danger,
                ),
                const SizedBox(height: 14),
                Text(
                  'Unable to load profile',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyProfileView extends StatelessWidget {
  const _EmptyProfileView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.05),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.10),
                  ),
                  child: Icon(
                    Icons.person_add_alt_1_rounded,
                    size: 34,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No profile found',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete onboarding to create a patient profile and continue using AAYUTRACK.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.patientOnboarding,
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Complete Onboarding'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InlineWarningBanner extends StatelessWidget {
  final String message;

  const _InlineWarningBanner({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: Colors.orange,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
