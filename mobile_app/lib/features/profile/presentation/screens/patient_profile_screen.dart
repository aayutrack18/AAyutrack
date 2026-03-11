import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/patient_profile.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_info_card.dart';

class PatientProfileScreen extends ConsumerStatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  ConsumerState<PatientProfileScreen> createState() =>
      _PatientProfileScreenState();
}

class _PatientProfileScreenState extends ConsumerState<PatientProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(profileProvider.notifier).loadProfile();
    });
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
        child: profileState.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : profileState.profile == null
                ? const _EmptyProfileView()
                : _PatientProfileContent(
                    profile: profileState.profile!,
                  ),
      ),
    );
  }
}

class _PatientProfileContent extends ConsumerWidget {
  final PatientProfile profile;

  const _PatientProfileContent({
    required this.profile,
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

    return '$day/$month/$year  $hour:$minute';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final horizontalPadding = mediaQuery.size.width < 420 ? 16.0 : 22.0;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
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
                ),
                const SizedBox(height: 18),
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
                      value: _formatOptionalText(profile.emergencyContactName),
                    ),
                    _ProfileDetailRow(
                      label: 'Contact Phone',
                      value: _formatOptionalText(profile.emergencyContactPhone),
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
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () async {
                await Navigator.pushNamed(
                  context,
                  AppRoutes.editProfile,
                );

                if (!context.mounted) return;
                await ref.read(profileProvider.notifier).loadProfile();
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final PatientProfile profile;
  final String initials;

  const _ProfileHeaderCard({
    required this.profile,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
            child: Text(
              initials,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            profile.fullName,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${profile.age} years • ${profile.gender} • ${profile.bloodGroup}',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _HeaderChip(
                icon: Icons.phone_outlined,
                label: profile.phoneNumber,
              ),
              _HeaderChip(
                icon: Icons.favorite_border,
                label: profile.bloodGroup,
              ),
              _HeaderChip(
                icon: Icons.sync_outlined,
                label: profile.isSynced ? 'Synced' : 'Local',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Colors.black.withValues(alpha: 0.06),
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_off_outlined,
                size: 52,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 14),
              Text(
                'No profile found',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Complete your patient profile to continue with AAYUTRACK.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.patientOnboarding,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Complete Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
