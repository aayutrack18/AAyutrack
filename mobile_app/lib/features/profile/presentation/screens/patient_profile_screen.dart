import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/profile/presentation/providers/profile_provider.dart';
import 'package:aayutrack/features/profile/presentation/providers/profile_state.dart';
import 'package:aayutrack/features/profile/presentation/widgets/profile_info_card.dart';
import 'package:aayutrack/features/reminders/presentation/screens/notification_settings_screen.dart';
import 'package:aayutrack/features/reports/presentation/screens/reports_screen.dart';

class PatientProfileScreen extends ConsumerStatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  ConsumerState<PatientProfileScreen> createState() =>
      _PatientProfileScreenState();
}

class _PatientProfileScreenState extends ConsumerState<PatientProfileScreen> {
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(profileProvider.notifier).loadProfile());
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showConfirmationSheet(
      context,
      title: 'Log Out',
      message: 'Are you sure you want to log out of AAYUTRACK?',
      confirmLabel: 'Log Out',
      isDangerous: true,
    );

    if (confirm != true) return;
    if (_isLoggingOut) return;

    setState(() => _isLoggingOut = true);

    try {
      await GoogleSignIn().signOut().catchError((_) {});
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.welcome,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: profileState.isLoading
          ? const LoadingIndicator(message: 'Loading profile...')
          : profileState.hasError
              ? ErrorState(
                  message: profileState.errorMessage!,
                  onRetry: () =>
                      ref.read(profileProvider.notifier).loadProfile(),
                )
              : !profileState.hasProfile
                  ? EmptyState(
                      icon: Icons.person_outline_rounded,
                      title: 'No Profile Found',
                      message: 'Complete your profile to get started.',
                      actionLabel: 'Set Up Profile',
                      onAction: () => Navigator.pushNamed(
                        context,
                        AppRoutes.patientOnboarding,
                      ),
                    )
                  : _buildProfile(context, profileState),
    );
  }

  Widget _buildProfile(BuildContext context, ProfileState state) {
    final p = state.profile!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 380;

    final initials = p.fullName
        .trim()
        .split(' ')
        .where((n) => n.trim().isNotEmpty)
        .take(2)
        .map((n) => n[0].toUpperCase())
        .join();

    final heightCm =
        (p.heightCm != null && p.heightCm! > 0) ? p.heightCm : null;
    final weightKg =
        (p.weightKg != null && p.weightKg! > 0) ? p.weightKg : null;

    String? bmiValue;
    if (heightCm != null && weightKg != null) {
      final bmi = weightKg / ((heightCm / 100) * (heightCm / 100));
      if (bmi.isFinite && !bmi.isNaN) {
        bmiValue = bmi.toStringAsFixed(1);
      }
    }

    final metaParts = <String>[
      if (p.age > 0) '${p.age} yrs',
      if (p.gender.trim().isNotEmpty) p.gender.trim(),
      if (p.bloodGroup.trim().isNotEmpty) p.bloodGroup.trim(),
    ];

    final profileMeta =
        metaParts.isNotEmpty ? metaParts.join(' · ') : 'Patient';

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: isCompact ? 286 : 274,
          pinned: true,
          backgroundColor: AppColors.primary,
          leading: const SizedBox.shrink(),
          leadingWidth: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: Colors.white),
              onPressed: () async {
                await Navigator.pushNamed(context, AppRoutes.editProfile);
                ref.read(profileProvider.notifier).loadProfile();
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              onPressed: _isLoggingOut ? null : () => _handleLogout(context),
            ),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Color(0xFF1E40AF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    isCompact ? 16 : 20,
                    20,
                    isCompact ? 28 : 24,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: isCompact ? 32 : 36),
                      CircleAvatar(
                        radius: isCompact ? 40 : 44,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(
                          initials.isEmpty ? 'P' : initials,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isCompact ? 28 : 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: isCompact ? 10 : 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          p.fullName.trim().isEmpty
                              ? 'Patient Profile'
                              : p.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isCompact ? 18 : 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          profileMeta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: isCompact ? 12 : 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isCompact ? 180 : 220,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isCompact ? 10 : 12,
                            vertical: isCompact ? 5 : 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            p.isSynced ? '● Synced' : '● Pending sync',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isCompact ? 10 : 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _InfoChip(
                        Icons.phone_rounded,
                        p.phoneNumber.isEmpty ? 'Phone not added' : p.phoneNumber,
                      ),
                    ),
                  ],
                ),
                if (p.email.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoChip(Icons.email_rounded, p.email),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                if (p.medicalConditions.isNotEmpty)
                  ProfileInfoCard(
                    title: 'Medical Conditions',
                    icon: Icons.medical_information_rounded,
                    children: [
                      Text(
                        p.medicalConditions,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                if (p.allergies.isNotEmpty)
                  ProfileInfoCard(
                    title: 'Allergies',
                    icon: Icons.warning_amber_rounded,
                    iconColor: AppColors.danger,
                    iconBackgroundColor: AppColors.danger.withOpacity(0.1),
                    children: [
                      Text(
                        p.allergies,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ProfileInfoCard(
                  title: 'Body Metrics',
                  icon: Icons.monitor_weight_outlined,
                  children: [
                    _infoRow(
                      'Blood Group',
                      p.bloodGroup.trim().isEmpty ? 'Not set' : p.bloodGroup,
                    ),
                    if (heightCm != null) ...[
                      const Divider(color: AppColors.border, height: 20),
                      _infoRow(
                        'Height',
                        '${heightCm.toStringAsFixed(1)} cm',
                      ),
                    ],
                    if (weightKg != null) ...[
                      const Divider(color: AppColors.border, height: 20),
                      _infoRow(
                        'Weight',
                        '${weightKg.toStringAsFixed(1)} kg',
                      ),
                    ],
                    if (bmiValue != null) ...[
                      const Divider(color: AppColors.border, height: 20),
                      _infoRow('BMI', bmiValue),
                    ],
                  ],
                ),
                if (p.emergencyContactName.isNotEmpty)
                  ProfileInfoCard(
                    title: 'Emergency Contact',
                    icon: Icons.emergency_rounded,
                    iconColor: AppColors.danger,
                    iconBackgroundColor: AppColors.danger.withOpacity(0.1),
                    children: [
                      _infoRow('Name', p.emergencyContactName),
                      const Divider(color: AppColors.border, height: 20),
                      _infoRow(
                        'Phone',
                        p.emergencyContactPhone.isEmpty
                            ? 'Not set'
                            : p.emergencyContactPhone,
                      ),
                    ],
                  ),
                if (p.address.isNotEmpty)
                  ProfileInfoCard(
                    title: 'Address',
                    icon: Icons.location_on_rounded,
                    children: [
                      Text(
                        p.address,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                AppButton(
                  label: 'Edit Profile',
                  icon: Icons.edit_rounded,
                  outlined: true,
                  onPressed: () async {
                    await Navigator.pushNamed(context, AppRoutes.editProfile);
                    ref.read(profileProvider.notifier).loadProfile();
                  },
                ),
                const SizedBox(height: 20),
                ProfileInfoCard(
                  title: 'Settings',
                  icon: Icons.settings_rounded,
                  children: [
                    _SettingRow(
                      icon: Icons.notifications_rounded,
                      iconColor: AppColors.accent,
                      label: 'Notification Settings',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationSettingsScreen(),
                        ),
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _SettingRow(
                      icon: Icons.description_rounded,
                      iconColor: AppColors.primary,
                      label: 'Generate Health Report',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReportsScreen(),
                        ),
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _SettingRow(
                      icon: Icons.verified_rounded,
                      iconColor: const Color(0xFF7C3AED),
                      label: 'View Compliance Overview',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.complianceOverview,
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    _SettingRow(
                      icon: Icons.logout_rounded,
                      iconColor: AppColors.danger,
                      label: _isLoggingOut ? 'Logging out...' : 'Log Out',
                      onTap:
                          _isLoggingOut ? () {} : () => _handleLogout(context),
                    ),
                  ],
                ),
                ProfileInfoCard(
                  title: 'About',
                  icon: Icons.info_outline_rounded,
                  children: [
                    _infoRow('App Name', 'AAYUTRACK'),
                    const Divider(color: AppColors.border, height: 20),
                    _infoRow('Version', '1.0.0'),
                    const Divider(color: AppColors.border, height: 20),
                    _infoRow('Type', 'Patient Mobile App'),
                    const SizedBox(height: 12),
                    const Text(
                      'Digital Compliance & Remote Patient Monitoring Platform. For medical questions, always consult your healthcare provider.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _SettingRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}