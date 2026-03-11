import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../compliance/presentation/providers/compliance_provider.dart';
import '../../../health_logs/domain/entities/health_log.dart';
import '../../../health_logs/presentation/providers/health_log_provider.dart';
import '../../../health_logs/presentation/screens/add_health_log_screen.dart';
import '../../../medicine/presentation/providers/medicine_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../reminders/presentation/providers/reminder_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final medicineState = ref.watch(medicineProvider);
    final reminderState = ref.watch(reminderProvider);
    final healthState = ref.watch(healthLogProvider);
    final complianceState = ref.watch(complianceProvider);

    final name = profileState.profile?.fullName.split(' ').first ?? 'there';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(context, name, complianceState),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickActions(context),
                  const SizedBox(height: 20),
                  _buildTodayMedicines(context, medicineState),
                  const SizedBox(height: 20),
                  _buildComplianceCard(context, complianceState),
                  const SizedBox(height: 20),
                  _buildTodayReminders(context, reminderState),
                  const SizedBox(height: 20),
                  _buildHealthSummary(context, healthState),
                  const SizedBox(height: 20),
                  _buildAlerts(context, complianceState),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(
      BuildContext context, String name, ComplianceState compliance) {
    return SliverAppBar(
      expandedHeight: 160,
      floating: true,
      pinned: false,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_greeting()}, $name! 👋',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _todayDate(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.complianceOverview),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.25)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${compliance.overallScore.toInt()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const Text(
                                'Compliance',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.add_circle_rounded,
        label: 'Log Reading',
        color: AppColors.accent,
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddHealthLogScreen())),
      ),
      _QuickAction(
        icon: Icons.medication_rounded,
        label: 'Medicines',
        color: AppColors.primary,
        onTap: () => Navigator.pushNamed(context, AppRoutes.medicineList),
      ),
      _QuickAction(
        icon: Icons.alarm_rounded,
        label: 'Reminders',
        color: const Color(0xFF7C3AED),
        onTap: () => Navigator.pushNamed(context, AppRoutes.reminderList),
      ),
      _QuickAction(
        icon: Icons.bar_chart_rounded,
        label: 'Reports',
        color: const Color(0xFFF59E0B),
        onTap: () => Navigator.pushNamed(context, AppRoutes.reports),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Quick Actions'),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actions.map((a) => _QuickActionButton(action: a)).toList(),
        ),
      ],
    );
  }

  Widget _buildTodayMedicines(
      BuildContext context, MedicineState medState) {
    final active = medState.activeMedicines.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Today's Medicines",
          actionLabel: 'View All',
          onAction: () =>
              Navigator.pushNamed(context, AppRoutes.medicineList),
        ),
        const SizedBox(height: 12),
        if (medState.isLoading)
          const LoadingIndicator()
        else if (active.isEmpty)
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.medication_outlined,
                    color: AppColors.textMuted),
                const SizedBox(width: 12),
                Text(
                  'No active medicines',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
              ],
            ),
          )
        else
          ...active.map((m) {
            final color = _parseColor(m.color);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.tablet_rounded,
                          color: color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppColors.textPrimary)),
                          Text('${m.dosage} · ${m.frequency}',
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    Text(
                      m.scheduledTimes.isNotEmpty
                          ? m.scheduledTimes.first
                          : '',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: color,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildComplianceCard(
      BuildContext context, ComplianceState compliance) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, AppRoutes.complianceOverview),
      child: GradientCard(
        colors: const [Color(0xFF1D4ED8), Color(0xFF1E3A8A)],
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Compliance Score',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12)),
                  Text(
                    '${compliance.overallScore.toInt()}% · ${compliance.scoreLabel}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: compliance.overallScore / 100,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      color: Colors.white,
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            if (compliance.unreadAlertCount > 0)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${compliance.unreadAlertCount}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Alerts',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 10)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayReminders(
      BuildContext context, ReminderState reminderState) {
    final enabled = reminderState.enabledReminders.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Today's Reminders",
          actionLabel: 'View All',
          onAction: () =>
              Navigator.pushNamed(context, AppRoutes.reminderList),
        ),
        const SizedBox(height: 12),
        if (enabled.isEmpty)
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.alarm_off_rounded,
                    color: AppColors.textMuted),
                const SizedBox(width: 12),
                Text('No reminders set',
                    style: TextStyle(color: AppColors.textMuted)),
              ],
            ),
          )
        else
          ...enabled.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppCard(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.alarm_rounded,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(r.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: AppColors.textPrimary)),
                      ),
                      Text(r.time,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              fontSize: 14)),
                    ],
                  ),
                ),
              )),
      ],
    );
  }

  Widget _buildHealthSummary(
      BuildContext context, HealthLogState healthState) {
    final latestBp = healthState.latestOfType(MetricType.bloodPressure);
    final latestSugar = healthState.latestOfType(MetricType.bloodSugar);
    final latestHr = healthState.latestOfType(MetricType.heartRate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Health Summary',
          actionLabel: 'View All',
          onAction: () =>
              Navigator.pushNamed(context, AppRoutes.healthLogsDashboard),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'Blood Pressure',
                value: latestBp?.displayValue ?? '--',
                unit: latestBp != null ? 'mmHg' : '',
                icon: Icons.bloodtype_rounded,
                color: const Color(0xFFDC2626),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricTile(
                label: 'Blood Sugar',
                value: latestSugar?.displayValue ?? '--',
                unit: latestSugar != null ? 'mg/dL' : '',
                icon: Icons.water_drop_rounded,
                color: const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'Heart Rate',
                value: latestHr?.displayValue ?? '--',
                unit: latestHr != null ? 'bpm' : '',
                icon: Icons.favorite_rounded,
                color: const Color(0xFFEC4899),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppCard(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AddHealthLogScreen()),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: AppColors.primary, size: 18),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      'Log',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: AppColors.textPrimary),
                    ),
                    const Text('New reading',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlerts(
      BuildContext context, ComplianceState compliance) {
    final unread =
        compliance.alerts.where((a) => !a.isRead).take(2).toList();
    if (unread.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Risk Alerts',
          actionLabel: 'View All',
          onAction: () =>
              Navigator.pushNamed(context, AppRoutes.riskAlerts),
        ),
        const SizedBox(height: 12),
        ...unread.map((alert) {
          final color = alert.severity == 'high'
              ? AppColors.danger
              : alert.severity == 'medium'
                  ? const Color(0xFFF59E0B)
                  : AppColors.accent;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AppCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      alert.severity == 'high'
                          ? Icons.warning_rounded
                          : Icons.info_rounded,
                      color: color,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      alert.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.textPrimary),
                    ),
                  ),
                  StatusChip(
                      label: alert.severity.toUpperCase(), color: color),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.primary;
    }
  }

  String _todayDate() {
    final now = DateTime.now();
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class _QuickActionButton extends StatelessWidget {
  final _QuickAction action;

  const _QuickActionButton({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      child: SizedBox(
        width: 74,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: action.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: action.color.withOpacity(0.2)),
              ),
              child: Icon(action.icon, color: action.color, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              action.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
