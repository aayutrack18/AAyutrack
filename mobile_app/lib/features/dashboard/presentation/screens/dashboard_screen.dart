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
import 'package:aayutrack/features/medicine/domain/entities/medicine.dart';
import 'package:aayutrack/features/medicine/presentation/providers/medicine_provider.dart';
import 'package:aayutrack/features/profile/presentation/providers/profile_provider.dart';
import 'package:aayutrack/features/reminders/domain/entities/reminder.dart';
import 'package:aayutrack/features/reminders/presentation/providers/reminder_provider.dart';
import 'package:aayutrack/features/sos/presentation/screens/sos_emergency_screen.dart';

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

  Color _scoreColor(double score) {
    if (score >= 90) return AppColors.success;
    if (score >= 75) return AppColors.primary;
    if (score >= 60) return AppColors.warning;
    return AppColors.danger;
  }

  int _todayMedicineCount(List<Medicine> medicines) {
    return medicines.where((m) => m.isActive && !m.isDeleted).length;
  }

  int _todayReminderCount(List<Reminder> reminders) {
    return reminders.where((r) => r.isEnabled && !r.isDeleted).length;
  }

  int _todayHealthLogCount(List<HealthLog> logs) {
    final now = DateTime.now();
    return logs.where((log) {
      final dt = log.recordedAt;
      return dt.year == now.year && dt.month == now.month && dt.day == now.day;
    }).length;
  }

  List<Reminder> _sortedTodayReminders(List<Reminder> reminders) {
    final enabled = reminders.where((r) => r.isEnabled && !r.isDeleted).toList();

    enabled.sort((a, b) => _minutesFromTime(a.time).compareTo(_minutesFromTime(b.time)));
    return enabled;
  }

  int _minutesFromTime(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return 0;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return hour * 60 + minute;
  }

  String _nextReminderLabel(List<Reminder> reminders) {
    if (reminders.isEmpty) return 'No upcoming reminders';

    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final sorted = _sortedTodayReminders(reminders);

    for (final reminder in sorted) {
      final reminderMinutes = _minutesFromTime(reminder.time);
      if (reminderMinutes >= nowMinutes) {
        return '${reminder.title} at ${reminder.time}';
      }
    }

    return 'Next reminder tomorrow';
  }

  String _lastHealthLogText(List<HealthLog> logs) {
    if (logs.isEmpty) return 'No readings logged yet';
    final log = logs.first;
    return '${log.type.label}: ${log.displayValue}${log.type.unit.isNotEmpty ? ' ${log.type.unit}' : ''}';
  }

  String _syncSummaryText(SyncStatusSnapshot? snapshot) {
    if (snapshot == null) return 'Checking sync status...';
    if (snapshot.hasPendingWork) {
      return '${snapshot.pendingCount} pending • ${snapshot.syncingCount} syncing';
    }
    if (snapshot.hasFailures) {
      return '${snapshot.failedCount} failed item${snapshot.failedCount == 1 ? '' : 's'}';
    }
    return 'All local changes are synced';
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

    final activeMedicines = medicineState.activeMedicines;
    final enabledReminders = reminderState.enabledReminders;
    final recentLogs = healthState.logs;

    final todayMedicineCount = _todayMedicineCount(activeMedicines);
    final todayReminderCount = _todayReminderCount(enabledReminders);
    final todayHealthCount = _todayHealthLogCount(recentLogs);

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
            context: context,
            name: name,
            complianceSummary: complianceSummary,
            alertCount: riskAlerts.length,
            intelligenceLoading: intelligenceLoading,
            todayMedicineCount: todayMedicineCount,
            todayReminderCount: todayReminderCount,
            todayHealthCount: todayHealthCount,
            nextReminderText: _nextReminderLabel(enabledReminders),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTodaySummaryBand(
                    complianceSummary: complianceSummary,
                    riskAlerts: riskAlerts,
                    syncSnapshot: syncStatusAsync.asData?.value,
                    intelligenceLoading: intelligenceLoading,
                    todayMedicineCount: todayMedicineCount,
                    todayReminderCount: todayReminderCount,
                    todayHealthCount: todayHealthCount,
                    nextReminderText: _nextReminderLabel(enabledReminders),
                    lastHealthLogText: _lastHealthLogText(recentLogs),
                  ),
                  const SizedBox(height: 20),
                  _buildQuickActions(context),
                  const SizedBox(height: 20),
                  _buildComplianceCard(
                    context,
                    complianceSummary,
                    riskAlerts.length,
                    intelligenceLoading,
                  ),
                  const SizedBox(height: 20),
                  _buildTodayMedicines(context, medicineState),
                  const SizedBox(height: 20),
                  _buildTodayReminders(context, reminderState),
                  const SizedBox(height: 20),
                  _buildHealthSummary(context, healthState),
                  const SizedBox(height: 20),
                  _buildAlerts(context, riskAlerts),
                  const SizedBox(height: 20),
                  _buildSyncStatusCard(
                    context,
                    ref,
                    syncStatusAsync,
                    syncActionState,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader({
    required BuildContext context,
    required String name,
    required ComplianceSummary complianceSummary,
    required int alertCount,
    required bool intelligenceLoading,
    required int todayMedicineCount,
    required int todayReminderCount,
    required int todayHealthCount,
    required String nextReminderText,
  }) {
    final score = intelligenceLoading ? 0.0 : complianceSummary.complianceScore;
    final scoreColor = _scoreColor(score);

    return SliverAppBar(
      expandedHeight: 280,
      floating: true,
      pinned: false,
      stretch: true,
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
          child: Stack(
            children: [
              Positioned(
                top: -50,
                right: -30,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 90,
                left: -35,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_greeting()}, $name',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _todayDate(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.14),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Today Summary',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.92),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        intelligenceLoading
                                            ? 'Preparing insights...'
                                            : _scoreLabel(score),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          height: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.14),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          intelligenceLoading
                                              ? 'Loading'
                                              : 'Compliance ${score.toInt()}%',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  width: 82,
                                  height: 82,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.18),
                                      width: 6,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      alertCount > 0
                                          ? Icons.warning_amber_rounded
                                          : Icons.verified_rounded,
                                      color: alertCount > 0
                                          ? Colors.white
                                          : scoreColor == AppColors.success
                                              ? Colors.white
                                              : Colors.white,
                                      size: 34,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _HeaderPill(
                                  icon: Icons.medication_rounded,
                                  label: '$todayMedicineCount medicines',
                                ),
                                _HeaderPill(
                                  icon: Icons.alarm_rounded,
                                  label: '$todayReminderCount reminders',
                                ),
                                _HeaderPill(
                                  icon: Icons.monitor_heart_rounded,
                                  label: '$todayHealthCount logs today',
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                const Icon(
                                  Icons.schedule_rounded,
                                  color: Colors.white70,
                                  size: 15,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    nextReminderText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.82),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodaySummaryBand({
    required ComplianceSummary complianceSummary,
    required List<RiskAlert> riskAlerts,
    required SyncStatusSnapshot? syncSnapshot,
    required bool intelligenceLoading,
    required int todayMedicineCount,
    required int todayReminderCount,
    required int todayHealthCount,
    required String nextReminderText,
    required String lastHealthLogText,
  }) {
    final score = intelligenceLoading ? 0.0 : complianceSummary.complianceScore;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your day at a glance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            intelligenceLoading
                ? 'We are preparing your summary.'
                : riskAlerts.isEmpty
                    ? 'Everything looks stable for today.'
                    : 'You have ${riskAlerts.length} alert${riskAlerts.length == 1 ? '' : 's'} that may need attention.',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HomeMiniStatCard(
                  title: 'Compliance',
                  value: intelligenceLoading ? '...' : '${score.toInt()}%',
                  subtitle: intelligenceLoading
                      ? 'Loading'
                      : _scoreLabel(score),
                  icon: Icons.shield_rounded,
                  color: _scoreColor(score),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HomeMiniStatCard(
                  title: 'Active Alerts',
                  value: '${riskAlerts.length}',
                  subtitle: riskAlerts.isEmpty ? 'No urgent issues' : 'Needs review',
                  icon: riskAlerts.isEmpty
                      ? Icons.verified_rounded
                      : Icons.warning_rounded,
                  color: riskAlerts.isEmpty
                      ? AppColors.success
                      : AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _HomeMiniStatCard(
                  title: 'Today Schedule',
                  value: '$todayReminderCount',
                  subtitle: nextReminderText,
                  icon: Icons.event_note_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HomeMiniStatCard(
                  title: 'Health Tracking',
                  value: '$todayHealthCount',
                  subtitle: lastHealthLogText,
                  icon: Icons.favorite_rounded,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.sync_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _syncSummaryText(syncSnapshot),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '$todayMedicineCount meds',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.medication_rounded,
        label: 'Add Medicine',
        color: AppColors.primary,
        onTap: () => Navigator.pushNamed(context, AppRoutes.addMedicine),
      ),
      _QuickAction(
        icon: Icons.monitor_heart_rounded,
        label: 'Add Health Log',
        color: AppColors.accent,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddHealthLogScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.notifications_active_rounded,
        label: 'Reminders',
        color: const Color(0xFFF59E0B),
        onTap: () => Navigator.pushNamed(context, AppRoutes.reminderList),
      ),
      _QuickAction(
        icon: Icons.sos_rounded,
        label: 'SOS',
        color: AppColors.danger,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SosEmergencyScreen()),
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Quick Actions'),
        const SizedBox(height: 12),
        Row(
          children: actions
              .map(
                (action) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: action == actions.last ? 0 : 10,
                    ),
                    child: action,
                  ),
                ),
              )
              .toList(),
        ),
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
    final scoreColor = _scoreColor(score);

    return GradientCard(
      colors: const [AppColors.primary, AppColors.primaryDark],
      onTap: () => Navigator.pushNamed(context, AppRoutes.complianceOverview),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Compliance Insights',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  intelligenceLoading ? 'Loading' : _scoreLabel(score),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                intelligenceLoading ? '...' : '${score.toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InsightRow(
                      icon: Icons.warning_amber_rounded,
                      text: '$alertCount active alert${alertCount == 1 ? '' : 's'}',
                    ),
                    const SizedBox(height: 6),
                    _InsightRow(
                      icon: Icons.check_circle_outline_rounded,
                      text: intelligenceLoading
                          ? 'Preparing adherence summary'
                          : 'Track weekly trend and risk status',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: intelligenceLoading ? 0.2 : (score / 100).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: scoreColor == AppColors.warning || scoreColor == AppColors.danger
                      ? Colors.white
                      : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayMedicines(
    BuildContext context,
    MedicineState medicineState,
  ) {
    final active = medicineState.activeMedicines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Today Medicines',
          actionLabel: active.isEmpty ? null : 'View All',
          onAction: () => Navigator.pushNamed(context, AppRoutes.medicineList),
        ),
        const SizedBox(height: 12),
        if (medicineState.isLoading)
          const LoadingIndicator(message: 'Loading medicines...')
        else if (active.isEmpty)
          _HomeEmptyCard(
            icon: Icons.medication_outlined,
            title: 'No active medicines for today',
            subtitle:
                'Add a medicine to build your schedule and unlock better compliance tracking.',
            actionLabel: 'Add Medicine',
            onTap: () => Navigator.pushNamed(context, AppRoutes.addMedicine),
            color: AppColors.primary,
          )
        else
          Column(
            children: active.take(3).map((medicine) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MedicineOverviewCard(medicine: medicine),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildTodayReminders(
    BuildContext context,
    ReminderState reminderState,
  ) {
    final reminders = _sortedTodayReminders(reminderState.enabledReminders);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Today Reminders',
          actionLabel: reminders.isEmpty ? null : 'View All',
          onAction: () => Navigator.pushNamed(context, AppRoutes.reminderList),
        ),
        const SizedBox(height: 12),
        if (reminderState.isLoading)
          const LoadingIndicator(message: 'Loading reminders...')
        else if (reminders.isEmpty)
          _HomeEmptyCard(
            icon: Icons.alarm_outlined,
            title: 'No reminders scheduled',
            subtitle:
                'Create medicine or routine reminders so today feels guided and complete.',
            actionLabel: 'Add Reminder',
            onTap: () => Navigator.pushNamed(context, AppRoutes.addReminder),
            color: AppColors.accent,
          )
        else
          Column(
            children: reminders.take(3).map((reminder) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ReminderOverviewCard(reminder: reminder),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildHealthSummary(
    BuildContext context,
    HealthLogState healthState,
  ) {
    final latestByMetric = healthState.latestByMetric;
    final visibleMetrics = [
      MetricType.bloodPressure,
      MetricType.bloodSugar,
      MetricType.heartRate,
      MetricType.oxygen,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Health Snapshot',
          actionLabel: healthState.logs.isEmpty ? null : 'View All',
          onAction: () => Navigator.pushNamed(
            context,
            AppRoutes.healthLogsDashboard,
          ),
        ),
        const SizedBox(height: 12),
        if (healthState.isLoading)
          const LoadingIndicator(message: 'Loading health logs...')
        else if (healthState.logs.isEmpty)
          _HomeEmptyCard(
            icon: Icons.monitor_heart_outlined,
            title: 'No health readings logged',
            subtitle:
                'Start with one BP, sugar, oxygen, or heart-rate entry to make your dashboard feel live.',
            actionLabel: 'Log Reading',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddHealthLogScreen()),
            ),
            color: AppColors.accent,
          )
        else
          GridView.builder(
            itemCount: visibleMetrics.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.4,
            ),
            itemBuilder: (context, index) {
              final metric = visibleMetrics[index];
              final latest = latestByMetric[metric];
              return _HealthMiniCard(
                metric: metric,
                log: latest,
                color: _metricColor(metric),
              );
            },
          ),
      ],
    );
  }

  Widget _buildAlerts(BuildContext context, List<RiskAlert> alerts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Risk Alerts',
          actionLabel: alerts.isEmpty ? null : 'View All',
          onAction: () => Navigator.pushNamed(context, AppRoutes.riskAlerts),
        ),
        const SizedBox(height: 12),
        if (alerts.isEmpty)
          _HomeEmptyCard(
            icon: Icons.verified_outlined,
            title: 'No active alerts right now',
            subtitle:
                'That is a good sign. Keep following your schedule to maintain stable compliance.',
            actionLabel: 'Open Compliance',
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.complianceOverview,
            ),
            color: AppColors.success,
          )
        else
          Column(
            children: alerts.take(3).map((alert) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RiskAlertCard(alert: alert),
              );
            }).toList(),
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
        const SectionHeader(title: 'Sync & Offline'),
        const SizedBox(height: 12),
        syncStatusAsync.when(
          loading: () => const AppCard(
            child: LoadingIndicator(message: 'Checking sync status...'),
          ),
          error: (error, _) => AppCard(
            color: AppColors.danger.withOpacity(0.06),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.danger,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Unable to load sync status: $error',
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          data: (snapshot) {
            return AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: snapshot.hasFailures
                              ? AppColors.danger.withOpacity(0.1)
                              : snapshot.hasPendingWork
                                  ? AppColors.warning.withOpacity(0.1)
                                  : AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          snapshot.hasFailures
                              ? Icons.sync_problem_rounded
                              : snapshot.hasPendingWork
                                  ? Icons.sync_rounded
                                  : Icons.cloud_done_rounded,
                          color: snapshot.hasFailures
                              ? AppColors.danger
                              : snapshot.hasPendingWork
                                  ? AppColors.warning
                                  : AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.hasFailures
                                  ? 'Sync needs attention'
                                  : snapshot.hasPendingWork
                                      ? 'Sync in progress'
                                      : 'Everything synced',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _syncSummaryText(snapshot),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _SyncStatBox(
                          label: 'Pending',
                          value: '${snapshot.pendingCount}',
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SyncStatBox(
                          label: 'Failed',
                          value: '${snapshot.failedCount}',
                          color: AppColors.danger,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SyncStatBox(
                          label: 'Synced',
                          value: '${snapshot.syncedCount}',
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: syncActionState.isWorking ? 'Working...' : 'Sync Now',
                          onPressed: syncActionState.isWorking
                              ? null
                              : () => ref.read(syncActionProvider.notifier).syncNow(),
                          icon: Icons.sync_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(
                          label: 'Retry Failed',
                          outlined: true,
                          onPressed: syncActionState.isWorking
                              ? null
                              : () => ref.read(syncActionProvider.notifier).retryFailed(),
                          icon: Icons.refresh_rounded,
                        ),
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

  Color _metricColor(MetricType type) {
    switch (type) {
      case MetricType.bloodPressure:
        return const Color(0xFFDC2626);
      case MetricType.bloodSugar:
        return const Color(0xFFF59E0B);
      case MetricType.heartRate:
        return const Color(0xFFEC4899);
      case MetricType.weight:
        return const Color(0xFF7C3AED);
      case MetricType.oxygen:
        return const Color(0xFF14B8A6);
      case MetricType.temperature:
        return const Color(0xFF6366F1);
      case MetricType.mood:
        return const Color(0xFF16A34A);
    }
  }
}

class _HeaderPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderPill({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeMiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _HomeMiniStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InsightRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 14),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeEmptyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onTap;
  final Color color;

  const _HomeEmptyCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: actionLabel,
            onPressed: onTap,
            icon: Icons.arrow_forward_rounded,
          ),
        ],
      ),
    );
  }
}

class _MedicineOverviewCard extends StatelessWidget {
  final Medicine medicine;

  const _MedicineOverviewCard({required this.medicine});

  Color get _accent {
    try {
      return Color(int.parse(medicine.color.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accent;

    return AppCard(
      onTap: () => Navigator.pushNamed(context, AppRoutes.medicineList),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 62,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.medication_rounded,
              color: accent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${medicine.dosage} • ${medicine.frequency}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                if (medicine.scheduledTimes.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    medicine.scheduledTimes.take(3).join('  •  '),
                    style: TextStyle(
                      fontSize: 11,
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}

class _ReminderOverviewCard extends StatelessWidget {
  final Reminder reminder;

  const _ReminderOverviewCard({required this.reminder});

  Color get _accent {
    switch (reminder.type) {
      case 'medicine':
        return AppColors.primary;
      case 'measurement':
        return AppColors.accent;
      case 'appointment':
        return const Color(0xFF7C3AED);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  IconData get _icon {
    switch (reminder.type) {
      case 'medicine':
        return Icons.medication_rounded;
      case 'measurement':
        return Icons.monitor_heart_rounded;
      case 'appointment':
        return Icons.calendar_month_rounded;
      default:
        return Icons.alarm_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accent;

    return AppCard(
      onTap: () => Navigator.pushNamed(context, AppRoutes.reminderList),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, color: accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reminder.description.isEmpty
                      ? 'Reminder scheduled for ${reminder.time}'
                      : reminder.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                reminder.time,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: accent,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                reminder.isDaily ? 'Daily' : reminder.repeatDays.join(', '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HealthMiniCard extends StatelessWidget {
  final MetricType metric;
  final HealthLog? log;
  final Color color;

  const _HealthMiniCard({
    required this.metric,
    required this.log,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.pushNamed(context, AppRoutes.healthLogsDashboard),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _metricIcon(metric),
                  color: color,
                  size: 18,
                ),
              ),
              const Spacer(),
              if (log != null)
                Text(
                  _timeAgo(log!.recordedAt),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            log?.displayValue ?? '--',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _metricIcon(MetricType type) {
    switch (type) {
      case MetricType.bloodPressure:
        return Icons.bloodtype_rounded;
      case MetricType.bloodSugar:
        return Icons.water_drop_rounded;
      case MetricType.heartRate:
        return Icons.favorite_rounded;
      case MetricType.weight:
        return Icons.monitor_weight_outlined;
      case MetricType.oxygen:
        return Icons.air_rounded;
      case MetricType.temperature:
        return Icons.thermostat_rounded;
      case MetricType.mood:
        return Icons.sentiment_satisfied_rounded;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

class _RiskAlertCard extends StatelessWidget {
  final RiskAlert alert;

  const _RiskAlertCard({required this.alert});

  Color get _color {
    switch (alert.severity) {
      case 'high':
        return AppColors.danger;
      case 'medium':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  IconData get _icon {
    switch (alert.severity) {
      case 'high':
        return Icons.error_rounded;
      case 'medium':
        return Icons.warning_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;

    return AppCard(
      onTap: () => Navigator.pushNamed(context, AppRoutes.riskAlerts),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _timeAgo(alert.detectedAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day ago';
  }
}

class _SyncStatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SyncStatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}