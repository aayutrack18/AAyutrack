import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/intelligence/compliance_score_service.dart';
import 'package:aayutrack/core/intelligence/intelligence_providers.dart';
import 'package:aayutrack/core/intelligence/risk_detection_service.dart';
import 'package:aayutrack/core/sync/sync_queue_service.dart';
import 'package:aayutrack/core/sync/sync_status_provider.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';
import 'package:aayutrack/features/health_logs/presentation/providers/health_log_provider.dart';
import 'package:aayutrack/features/health_logs/presentation/screens/add_health_log_screen.dart';
import 'package:aayutrack/features/medicine/presentation/providers/medicine_provider.dart';
import 'package:aayutrack/features/profile/presentation/providers/profile_provider.dart';
import 'package:aayutrack/features/reminders/presentation/providers/reminder_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _todayDate() {
    final now = DateTime.now();
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  String _scoreLabel(double score) {
    if (score >= 90) return 'Excellent';
    if (score >= 80) return 'Good';
    if (score >= 60) return 'Fair';
    return 'Needs Attention';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final medicineState = ref.watch(medicineProvider);
    final reminderState = ref.watch(reminderProvider);
    final healthState = ref.watch(healthLogProvider);

    final complianceSummary = ref.watch(complianceSummaryProvider);
    final riskAlerts = ref.watch(riskAlertsProvider);
    final intelligenceLoading = ref.watch(intelligenceLoadingProvider);

    final syncStatusAsync = ref.watch(syncStatusStreamProvider);
    final syncActionState = ref.watch(syncActionProvider);

    final name = profileState.profile?.fullName.split(' ').first ?? 'there';

    ref.listen<SyncActionState>(syncActionProvider, (previous, next) {
      if (previous?.successMessage != next.successMessage &&
          next.successMessage != null &&
          next.successMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!)),
        );
      }

      if (previous?.errorMessage != next.errorMessage &&
          next.errorMessage != null &&
          next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(
            context,
            name,
            complianceSummary,
            riskAlerts.length,
            intelligenceLoading,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickActions(context),
                  const SizedBox(height: 20),
                  _buildSyncStatusCard(
                    context,
                    ref,
                    syncStatusAsync,
                    syncActionState,
                  ),
                  const SizedBox(height: 20),
                  _buildTodayMedicines(context, medicineState),
                  const SizedBox(height: 20),
                  _buildComplianceCard(
                    context,
                    complianceSummary,
                    riskAlerts.length,
                    intelligenceLoading,
                  ),
                  const SizedBox(height: 20),
                  _buildTodayReminders(context, reminderState),
                  const SizedBox(height: 20),
                  _buildHealthSummary(context, healthState),
                  const SizedBox(height: 20),
                  _buildAlerts(context, riskAlerts),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(
    BuildContext context,
    String name,
    ComplianceSummary complianceSummary,
    int alertCount,
    bool intelligenceLoading,
  ) {
    final score = intelligenceLoading ? 0.0 : complianceSummary.complianceScore;

    return SliverAppBar(
      expandedHeight: 160,
      floating: true,
      pinned: false,
      backgroundColor: AppColors.primary,
      automaticallyImplyLeading: false,
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
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _todayDate(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.complianceOverview,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                            ),
                          ),
                          child: Column(
                            children: [
                              intelligenceLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      '${score.toInt()}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                              const Text(
                                'Compliance',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                              if (!intelligenceLoading && alertCount > 0)
                                Text(
                                  '$alertCount alerts',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 9,
                                  ),
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
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddHealthLogScreen()),
        ),
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

  Widget _buildSyncStatusCard(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<SyncStatusSnapshot> syncStatusAsync,
    SyncActionState syncActionState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Sync Status'),
        const SizedBox(height: 12),
        syncStatusAsync.when(
          loading: () => AppCard(
            child: Row(
              children: const [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text(
                  'Loading sync status...',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          error: (error, _) => AppCard(
            color: AppColors.danger.withOpacity(0.05),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.sync_problem_rounded,
                  color: AppColors.danger,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Unable to load sync status: $error',
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontSize: 13,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => ref.invalidate(syncStatusStreamProvider),
                  icon: const Icon(Icons.refresh_rounded),
                  color: AppColors.danger,
                ),
              ],
            ),
          ),
          data: (snapshot) {
            final status = _statusPresentation(snapshot);

            return AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: status.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          status.icon,
                          color: status.color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              status.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              status.subtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: syncActionState.isWorking
                            ? null
                            : () => ref.invalidate(syncStatusStreamProvider),
                        icon: const Icon(Icons.refresh_rounded),
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _SyncCountTile(
                          label: 'Pending',
                          value: snapshot.pendingCount,
                          color: const Color(0xFFF59E0B),
                          icon: Icons.schedule_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SyncCountTile(
                          label: 'Syncing',
                          value: snapshot.syncingCount,
                          color: AppColors.primary,
                          icon: Icons.sync_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SyncCountTile(
                          label: 'Failed',
                          value: snapshot.failedCount,
                          color: AppColors.danger,
                          icon: Icons.error_outline_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _SyncCountTile(
                          label: 'Synced',
                          value: snapshot.syncedCount,
                          color: AppColors.success,
                          icon: Icons.check_circle_outline_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.storage_rounded,
                                size: 16,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Total queue items: ${snapshot.totalCount}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: syncActionState.isWorking
                            ? null
                            : () async {
                                await ref
                                    .read(syncActionProvider.notifier)
                                    .syncNow();
                              },
                        icon: syncActionState.isWorking
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.sync_rounded, size: 16),
                        label: const Text('Sync Now'),
                      ),
                      OutlinedButton.icon(
                        onPressed:
                            syncActionState.isWorking || snapshot.failedCount == 0
                            ? null
                            : () async {
                                await ref
                                    .read(syncActionProvider.notifier)
                                    .retryFailed();
                              },
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Retry Failed'),
                      ),
                      OutlinedButton.icon(
                        onPressed:
                            syncActionState.isWorking || snapshot.syncedCount == 0
                            ? null
                            : () async {
                                await ref
                                    .read(syncActionProvider.notifier)
                                    .clearSynced();
                              },
                        icon: const Icon(Icons.cleaning_services_rounded, size: 16),
                        label: const Text('Clear Synced'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  _SyncStatusPresentation _statusPresentation(SyncStatusSnapshot snapshot) {
    if (snapshot.failedCount > 0) {
      return const _SyncStatusPresentation(
        title: 'Sync Needs Attention',
        subtitle: 'Some items failed to sync. Retry when connection is stable.',
        color: AppColors.danger,
        icon: Icons.sync_problem_rounded,
      );
    }

    if (snapshot.syncingCount > 0) {
      return const _SyncStatusPresentation(
        title: 'Sync In Progress',
        subtitle: 'Your offline changes are currently being uploaded.',
        color: AppColors.primary,
        icon: Icons.sync_rounded,
      );
    }

    if (snapshot.pendingCount > 0) {
      return const _SyncStatusPresentation(
        title: 'Pending Sync',
        subtitle: 'Local changes are queued and waiting to sync.',
        color: Color(0xFFF59E0B),
        icon: Icons.schedule_rounded,
      );
    }

    return const _SyncStatusPresentation(
      title: 'All Changes Synced',
      subtitle: 'Your local data is currently up to date.',
      color: AppColors.success,
      icon: Icons.check_circle_rounded,
    );
  }

  Widget _buildTodayMedicines(BuildContext context, MedicineState medState) {
    final active = medState.activeMedicines.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Today's Medicines",
          actionLabel: 'View All',
          onAction: () => Navigator.pushNamed(context, AppRoutes.medicineList),
        ),
        const SizedBox(height: 12),
        if (medState.isLoading)
          const LoadingIndicator()
        else if (active.isEmpty)
          AppCard(
            child: Row(
              children: [
                const Icon(
                  Icons.medication_outlined,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 12),
                const Text(
                  'No active medicines',
                  style: TextStyle(color: AppColors.textMuted),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.tablet_rounded,
                        color: color,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${m.dosage} · ${m.frequency}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      m.scheduledTimes.isNotEmpty ? m.scheduledTimes.first : '',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: color,
                        fontSize: 13,
                      ),
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
    BuildContext context,
    ComplianceSummary complianceSummary,
    int alertCount,
    bool intelligenceLoading,
  ) {
    final score = intelligenceLoading ? 0.0 : complianceSummary.complianceScore;
    final label = intelligenceLoading ? 'Loading...' : _scoreLabel(score);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.complianceOverview),
      child: GradientCard(
        colors: const [Color(0xFF1D4ED8), Color(0xFF1E3A8A)],
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Compliance Score',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  intelligenceLoading
                      ? const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : Text(
                          '${score.toInt()}% · $label',
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
                      value: intelligenceLoading ? 0 : (score / 100),
                      backgroundColor: Colors.white.withOpacity(0.2),
                      color: Colors.white,
                      minHeight: 6,
                    ),
                  ),
                  if (!intelligenceLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${complianceSummary.takenCount}/${complianceSummary.totalScheduled} doses taken this period',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            if (!intelligenceLoading && alertCount > 0)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$alertCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Alerts',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayReminders(
    BuildContext context,
    ReminderState reminderState,
  ) {
    final enabled = reminderState.enabledReminders.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Today's Reminders",
          actionLabel: 'View All',
          onAction: () => Navigator.pushNamed(context, AppRoutes.reminderList),
        ),
        const SizedBox(height: 12),
        if (enabled.isEmpty)
          AppCard(
            child: const Row(
              children: [
                Icon(Icons.alarm_off_rounded, color: AppColors.textMuted),
                SizedBox(width: 12),
                Text(
                  'No reminders set',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
          )
        else
          ...enabled.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.alarm_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        r.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      r.time,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHealthSummary(BuildContext context, HealthLogState healthState) {
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
                    builder: (_) => const AddHealthLogScreen(),
                  ),
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
                      child: const Icon(
                        Icons.add_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      'Log',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'New reading',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlerts(BuildContext context, List<RiskAlert> riskAlerts) {
    final visibleAlerts = riskAlerts.take(2).toList();
    if (visibleAlerts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Risk Alerts',
          actionLabel: 'View All',
          onAction: () => Navigator.pushNamed(context, AppRoutes.riskAlerts),
        ),
        const SizedBox(height: 12),
        ...visibleAlerts.map((alert) {
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
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  StatusChip(
                    label: alert.severity.toUpperCase(),
                    color: color,
                  ),
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
}

class _SyncStatusPresentation {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _SyncStatusPresentation({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });
}

class _SyncCountTile extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const _SyncCountTile({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
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
                border: Border.all(color: action.color.withOpacity(0.2)),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}