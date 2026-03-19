import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/features/compliance/presentation/providers/compliance_provider.dart';
import 'package:aayutrack/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:aayutrack/features/health_logs/presentation/screens/health_logs_dashboard_screen.dart';
import 'package:aayutrack/features/medicine/presentation/screens/medicine_list_screen.dart';
import 'package:aayutrack/features/profile/presentation/screens/patient_profile_screen.dart';
import 'package:aayutrack/features/reminders/presentation/screens/reminder_list_screen.dart';
import 'package:aayutrack/features/reports/presentation/screens/reports_screen.dart';
import 'package:aayutrack/features/sos/presentation/screens/sos_emergency_screen.dart';

final _shellIndexProvider = StateProvider<int>((ref) => 0);

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const List<Widget> _screens = [
    DashboardScreen(),
    MedicineListScreen(),
    ReminderListScreen(),
    HealthLogsDashboardScreen(),
    PatientProfileScreen(),
  ];

  static const List<String> _titles = [
    'Home',
    'Medicine',
    'Reminders',
    'Health Logs',
    'Profile',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(_shellIndexProvider);
    final complianceState = ref.watch(complianceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const _AppDrawer(),
      body: Stack(
        children: [
          IndexedStack(
            index: index,
            children: _screens,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: _DrawerMenuButton(
                title: _titles[index],
                alertCount: complianceState.unreadAlertCount,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: index,
        onTap: (i) => ref.read(_shellIndexProvider.notifier).state = i,
      ),
    );
  }
}

class _DrawerMenuButton extends StatelessWidget {
  final String title;
  final int alertCount;

  const _DrawerMenuButton({
    required this.title,
    required this.alertCount,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withOpacity(0.96),
      elevation: 6,
      shadowColor: AppColors.shadow,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Scaffold.of(context).openDrawer(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.menu_rounded,
                color: AppColors.textPrimary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (alertCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    alertCount > 99 ? '99+' : '$alertCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.medication_rounded,
                label: 'Medicine',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.alarm_rounded,
                label: 'Reminders',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.monitor_heart_rounded,
                label: 'Health Logs',
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isSelected: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 68,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 46,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AAYUTRACK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Digital Compliance & Remote Patient Monitoring',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                children: [
                  _DrawerTile(
                    icon: Icons.video_call_rounded,
                    title: 'Telemedicine',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TelemedicineScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.local_hospital_rounded,
                    title: 'Nearby Care',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NearbyCareScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.watch_rounded,
                    title: 'Device Connection',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const DeviceConnectionPlaceholderScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.sos_rounded,
                    title: 'SOS Emergency',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SosEmergencyScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.picture_as_pdf_rounded,
                    title: 'Reports',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReportsScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.sync_rounded,
                    title: 'Sync & Offline',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SyncOfflinePlaceholderScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsPlaceholderScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.info_rounded,
                    title: 'About AAYUTRACK',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutAayutrackScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textMuted,
      ),
      onTap: onTap,
    );
  }
}

class TelemedicineScreen extends StatelessWidget {
  const TelemedicineScreen({super.key});

  Future<void> _launchVideoDemo(BuildContext context) async {
    final uri = Uri.parse('https://meet.google.com/');

    bool launched = false;
    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      launched = false;
    }

    if (!launched && context.mounted) {
      _showFeatureSnackBar(
        context,
        'Unable to open consultation link.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FeatureScaffold(
      title: 'Telemedicine',
      hero: _FeatureHeaderCard(
        icon: Icons.video_call_rounded,
        title: 'Remote consultation, ready for demo',
        subtitle:
            'Show doctors how patient history, adherence insights, and health logs can be reviewed before a secure follow-up call.',
        gradientColors: const [Color(0xFF7C3AED), Color(0xFF5B21B6)],
        pills: const [
          _HeaderPill(label: 'Doctor linked'),
          _HeaderPill(label: 'Follow-up today'),
          _HeaderPill(label: 'Summary ready'),
        ],
      ),
      children: [
        _SectionTitleRow(
          title: 'Today\'s consultation',
          subtitle: 'Key details surfaced clearly for the demo.',
        ),
        const SizedBox(height: 12),
        const _FeatureSurfaceCard(
          child: Column(
            children: [
              _StatusTile(
                icon: Icons.person_rounded,
                title: 'Assigned clinician',
                value: 'Dr. Priya Sharma',
                subtitle: 'General Physician · Remote Monitoring Specialist',
                accentColor: Color(0xFF7C3AED),
              ),
              SizedBox(height: 14),
              _DividerLine(),
              SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _StatBadge(
                      label: 'Appointment',
                      value: '4:30 PM',
                      icon: Icons.schedule_rounded,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatBadge(
                      label: 'Mode',
                      value: 'Video Call',
                      icon: Icons.verified_user_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _SectionTitleRow(
          title: 'Pre-consultation summary',
          subtitle: 'Everything the doctor can review before joining.',
        ),
        const SizedBox(height: 12),
        const _FeatureSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ListPoint(text: 'Medication adherence summary already generated'),
              SizedBox(height: 12),
              _ListPoint(text: 'Recent blood pressure and sugar logs included'),
              SizedBox(height: 12),
              _ListPoint(text: 'Risk alerts available for quick escalation review'),
              SizedBox(height: 12),
              _ListPoint(text: 'PDF reports can be shared immediately with caregivers'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _SectionTitleRow(
          title: 'Quick actions',
          subtitle: 'Clear CTAs with hackathon-friendly wording.',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _launchVideoDemo(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.video_call_rounded),
                label: const Text(
                  'Join consultation',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showFeatureSnackBar(
                  context,
                  'Follow-up appointment added for demo flow.',
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: const BorderSide(color: AppColors.border),
                ),
                icon: const Icon(Icons.add_task_rounded),
                label: const Text(
                  'Book follow-up',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const _FeatureInfoBanner(
          icon: Icons.health_and_safety_rounded,
          title: 'Demo note',
          message:
              'This screen stays focused on consultation readiness instead of backend complexity, so judges can understand the patient-to-doctor workflow instantly.',
        ),
      ],
    );
  }
}

class NearbyCareScreen extends StatelessWidget {
  const NearbyCareScreen({super.key});

  Future<void> _openMapsSearch(
    BuildContext context,
    String query,
    String fallbackLabel,
  ) async {
    final encoded = Uri.encodeComponent(query);

    final googleMapsAppUri = Uri.parse('geo:0,0?q=$encoded');
    final googleMapsWebUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encoded',
    );

    bool launched = false;

    try {
      launched = await launchUrl(
        googleMapsAppUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      launched = false;
    }

    if (!launched) {
      try {
        launched = await launchUrl(
          googleMapsWebUri,
          mode: LaunchMode.externalApplication,
        );
      } catch (_) {
        launched = false;
      }
    }

    if (!launched && context.mounted) {
      _showFeatureSnackBar(
        context,
        'Unable to open $fallbackLabel.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FeatureScaffold(
      title: 'Nearby Care',
      hero: _FeatureHeaderCard(
        icon: Icons.local_hospital_rounded,
        title: 'Fast care discovery during urgent moments',
        subtitle:
            'Let patients or caregivers open nearby hospitals, pharmacies, and emergency support directly from one reliable access point.',
        gradientColors: const [AppColors.primary, AppColors.primaryDark],
        pills: const [
          _HeaderPill(label: 'Hospitals'),
          _HeaderPill(label: 'Pharmacies'),
          _HeaderPill(label: 'Emergency access'),
        ],
      ),
      children: [
        _SectionTitleRow(
          title: 'Find care now',
          subtitle: 'Tap once to continue in maps.',
        ),
        const SizedBox(height: 12),
        _CareCard(
          title: 'Nearby hospitals',
          subtitle: 'Search hospitals around your current location',
          icon: Icons.local_hospital_rounded,
          color: const Color(0xFFDC2626),
          onTap: () => _openMapsSearch(
            context,
            'hospitals near me',
            'nearby hospitals',
          ),
        ),
        const SizedBox(height: 14),
        _CareCard(
          title: 'Medical stores',
          subtitle: 'Find pharmacies and medicine stores nearby',
          icon: Icons.local_pharmacy_rounded,
          color: const Color(0xFF16A34A),
          onTap: () => _openMapsSearch(
            context,
            'medical stores near me',
            'medical stores',
          ),
        ),
        const SizedBox(height: 14),
        _CareCard(
          title: 'Emergency care',
          subtitle: 'Locate urgent and emergency care centers quickly',
          icon: Icons.emergency_rounded,
          color: const Color(0xFFF59E0B),
          onTap: () => _openMapsSearch(
            context,
            'emergency hospital near me',
            'emergency care',
          ),
        ),
        const SizedBox(height: 18),
        _SectionTitleRow(
          title: 'Why this matters',
          subtitle: 'Explain the value instantly during judging.',
        ),
        const SizedBox(height: 12),
        const _FeatureSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ListPoint(text: 'Patients can reach the right care option faster'),
              SizedBox(height: 12),
              _ListPoint(text: 'Medicine refill support is one tap away'),
              SizedBox(height: 12),
              _ListPoint(text: 'Emergency discovery complements SOS workflows'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const _FeatureInfoBanner(
          icon: Icons.map_rounded,
          title: 'Demo tip',
          message:
              'Use this screen right after reminders or SOS to show that AAYUTRACK not only monitors health but also helps patients act immediately.',
        ),
      ],
    );
  }
}

class _CareCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CareCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceConnectionPlaceholderScreen extends StatelessWidget {
  const DeviceConnectionPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _FeatureScaffold(
      title: 'Device Connection',
      hero: _FeatureHeaderCard(
        icon: Icons.watch_rounded,
        title: 'Wearable-ready for the next build phase',
        subtitle:
            'Present the device integration roadmap clearly without pretending the watch pipeline is already production complete.',
        gradientColors: const [Color(0xFF0F766E), Color(0xFF115E59)],
        pills: const [
          _HeaderPill(label: 'Smartwatch'),
          _HeaderPill(label: 'Health Connect'),
          _HeaderPill(label: 'Future sync'),
        ],
      ),
      children: [
        _SectionTitleRow(
          title: 'Planned connection flow',
          subtitle: 'Positioned as a future-ready capability.',
        ),
        const SizedBox(height: 12),
        const _FeatureSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatusTile(
                icon: Icons.bluetooth_searching_rounded,
                title: 'Pair wearable device',
                value: 'Next phase',
                subtitle: 'Connect watch or fitness tracker for passive vitals capture',
                accentColor: Color(0xFF0F766E),
              ),
              SizedBox(height: 14),
              _DividerLine(),
              SizedBox(height: 14),
              _StatusTile(
                icon: Icons.favorite_rounded,
                title: 'Sync health signals',
                value: 'Roadmap ready',
                subtitle: 'Pull steps, heart rate, sleep, and activity trends into AAYUTRACK',
                accentColor: Color(0xFF0F766E),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _SectionTitleRow(
          title: 'Demo-safe talking points',
          subtitle: 'Keep the narrative honest and strong.',
        ),
        const SizedBox(height: 12),
        const _FeatureSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ListPoint(text: 'Offline-first manual tracking works today'),
              SizedBox(height: 12),
              _ListPoint(text: 'Wearable support is the natural next layer for passive monitoring'),
              SizedBox(height: 12),
              _ListPoint(text: 'Health Connect can reduce friction across Android devices'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showFeatureSnackBar(
                  context,
                  'Device integration roadmap noted for demo discussion.',
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: const BorderSide(color: AppColors.border),
                ),
                icon: const Icon(Icons.route_rounded),
                label: const Text(
                  'View roadmap note',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SyncOfflinePlaceholderScreen extends StatelessWidget {
  const SyncOfflinePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _FeatureScaffold(
      title: 'Sync & Offline',
      hero: _FeatureHeaderCard(
        icon: Icons.sync_rounded,
        title: 'Offline-first by design',
        subtitle:
            'AAYUTRACK keeps the demo aligned with its architecture by making local-first behavior and sync visibility easy to explain.',
        gradientColors: const [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        pills: const [
          _HeaderPill(label: 'Local-first'),
          _HeaderPill(label: 'Pending queue'),
          _HeaderPill(label: 'Retry support'),
        ],
      ),
      children: [
        _SectionTitleRow(
          title: 'Current sync posture',
          subtitle: 'Simple visual state for a confident demo.',
        ),
        const SizedBox(height: 12),
        const _FeatureSurfaceCard(
          child: Row(
            children: [
              Expanded(
                child: _StatBadge(
                  label: 'Offline mode',
                  value: 'Ready',
                  icon: Icons.cloud_off_rounded,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatBadge(
                  label: 'Last check',
                  value: 'Just now',
                  icon: Icons.schedule_rounded,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _SectionTitleRow(
          title: 'What this screen represents',
          subtitle: 'Matches your UI → Provider → Repository → Local DB → Sync flow.',
        ),
        const SizedBox(height: 12),
        const _FeatureSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ListPoint(text: 'Patient actions are saved locally first for reliability'),
              SizedBox(height: 12),
              _ListPoint(text: 'Pending updates can be retried when connectivity returns'),
              SizedBox(height: 12),
              _ListPoint(text: 'Sync visibility helps judges understand resilience, not just features'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showFeatureSnackBar(
                  context,
                  'Sync check completed for demo view.',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.sync_rounded),
                label: const Text(
                  'Run sync check',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SettingsPlaceholderScreen extends StatelessWidget {
  const SettingsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _FeatureScaffold(
      title: 'Settings',
      hero: _FeatureHeaderCard(
        icon: Icons.settings_rounded,
        title: 'Preferences shaped for healthcare workflows',
        subtitle:
            'Keep this page consistent with the rest of the app while showing the product is ready for personalization and privacy controls.',
        gradientColors: const [Color(0xFF334155), Color(0xFF1E293B)],
        pills: const [
          _HeaderPill(label: 'Notifications'),
          _HeaderPill(label: 'Language'),
          _HeaderPill(label: 'Privacy'),
        ],
      ),
      children: [
        _SectionTitleRow(
          title: 'Preference groups',
          subtitle: 'Organized for demo clarity.',
        ),
        const SizedBox(height: 12),
        const _FeatureSurfaceCard(
          child: Column(
            children: [
              _SettingsLine(
                icon: Icons.notifications_active_rounded,
                title: 'Reminder alerts',
                subtitle: 'Medicine and follow-up notifications stay visible',
                trailing: 'Enabled',
              ),
              SizedBox(height: 14),
              _DividerLine(),
              SizedBox(height: 14),
              _SettingsLine(
                icon: Icons.translate_rounded,
                title: 'Language support',
                subtitle: 'Prepared for multilingual patient experiences',
                trailing: 'Scalable',
              ),
              SizedBox(height: 14),
              _DividerLine(),
              SizedBox(height: 14),
              _SettingsLine(
                icon: Icons.lock_rounded,
                title: 'Privacy controls',
                subtitle: 'Consent and sensitive health access are part of the roadmap',
                trailing: 'Planned',
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showFeatureSnackBar(
                  context,
                  'Settings overview opened for demo discussion.',
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: const BorderSide(color: AppColors.border),
                ),
                icon: const Icon(Icons.tune_rounded),
                label: const Text(
                  'Review preferences',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AboutAayutrackScreen extends StatelessWidget {
  const AboutAayutrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _FeatureScaffold(
      title: 'About AAYUTRACK',
      hero: _FeatureHeaderCard(
        icon: Icons.favorite_rounded,
        title: 'Digital compliance with patient-centered care',
        subtitle:
            'AAYUTRACK combines medicine adherence, health logs, risk visibility, and care coordination into one practical hackathon MVP.',
        gradientColors: const [Color(0xFFEC4899), Color(0xFFBE185D)],
        pills: const [
          _HeaderPill(label: 'Adherence'),
          _HeaderPill(label: 'Monitoring'),
          _HeaderPill(label: 'Care support'),
        ],
      ),
      children: [
        _SectionTitleRow(
          title: 'Core value',
          subtitle: 'Short enough for a live demo, strong enough for judges.',
        ),
        const SizedBox(height: 12),
        const _FeatureSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ListPoint(text: 'Supports medicine adherence through reminders and daily tracking'),
              SizedBox(height: 12),
              _ListPoint(text: 'Enables remote patient monitoring with logs, risk alerts, and reports'),
              SizedBox(height: 12),
              _ListPoint(text: 'Extends care access through telemedicine, nearby care, and SOS flows'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const _FeatureInfoBanner(
          icon: Icons.workspace_premium_rounded,
          title: 'Hackathon positioning',
          message:
              'Use this screen near the end of your demo to summarize the product story: local reliability, care continuity, and scalable remote monitoring.',
        ),
      ],
    );
  }
}

class _FeatureScaffold extends StatelessWidget {
  final String title;
  final Widget hero;
  final List<Widget> children;

  const _FeatureScaffold({
    required this.title,
    required this.hero,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              hero,
              const SizedBox(height: 18),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureHeaderCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final List<_HeaderPill> pills;

  const _FeatureHeaderCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.pills,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pills,
          ),
        ],
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  final String label;

  const _HeaderPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionTitleRow extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitleRow({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _FeatureSurfaceCard extends StatelessWidget {
  final Widget child;

  const _FeatureSurfaceCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StatusTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color accentColor;

  const _StatusTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: accentColor, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ListPoint extends StatelessWidget {
  final String text;

  const _ListPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.check_circle_rounded,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _FeatureInfoBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _FeatureInfoBanner({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsLine extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;

  const _SettingsLine({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            trailing,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppColors.border,
    );
  }
}

void _showFeatureSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? AppColors.danger : null,
      behavior: SnackBarBehavior.floating,
    ),
  );
}