import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/compliance/presentation/providers/compliance_provider.dart';
import 'package:aayutrack/features/reports/presentation/screens/reports_screen.dart';

class ComplianceOverviewScreen extends ConsumerWidget {
  const ComplianceOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(complianceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Compliance'),
        actions: [
          if (state.unreadAlertCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.riskAlerts),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.notifications_rounded,
                      color: AppColors.textMuted,
                    ),
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.danger,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${state.unreadAlertCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: state.isLoading
          ? const LoadingIndicator(message: 'Loading compliance data...')
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              children: [
                if (state.hasError) ...[
                  _ErrorBanner(message: state.errorMessage!),
                  const SizedBox(height: 12),
                ],
                if (!state.hasAnyData) ...[
                  EmptyState(
                    icon: Icons.insights_outlined,
                    title: 'No Compliance Insights Yet',
                    message:
                        'Compliance becomes useful when medicines, reminders, and dose activity start working together. Once that data is available, this screen will show your adherence story.',
                    accentColor: AppColors.primary,
                    highlights: const [
                      'Adherence score',
                      'Weekly trends',
                      'Risk alerts',
                    ],
                    actionLabel: 'Open Reports',
                    onAction: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReportsScreen(),
                      ),
                    ),
                    secondaryActionLabel: 'View Alerts',
                    onSecondaryAction: () =>
                        Navigator.pushNamed(context, AppRoutes.riskAlerts),
                  ),
                  const SizedBox(height: 16),
                  _buildDoctorSummary(context),
                ] else ...[
                  _ScoreHero(state: state),
                  const SizedBox(height: 16),
                  _buildMetricCards(context, state),
                  const SizedBox(height: 16),
                  _buildWeeklyChart(context, state),
                  const SizedBox(height: 16),
                  _buildAlerts(context, state, ref),
                  const SizedBox(height: 16),
                  _buildTips(state),
                  const SizedBox(height: 16),
                  _buildDoctorSummary(context),
                ],
              ],
            ),
    );
  }

  Widget _buildMetricCards(BuildContext context, ComplianceState state) {
    final isCompact = MediaQuery.of(context).size.width < 380;

    if (isCompact) {
      return Column(
        children: [
          _MetricCard(
            icon: Icons.medication_rounded,
            iconColor: AppColors.primary,
            label: 'Medicine',
            value: '${state.medicineAdherence.toInt()}%',
            progress: state.medicineAdherence / 100,
            progressColor: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _MetricCard(
            icon: Icons.monitor_heart_rounded,
            iconColor: AppColors.accent,
            label: 'Health Logs',
            value: '${state.logAdherence.toInt()}%',
            progress: state.logAdherence / 100,
            progressColor: AppColors.accent,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.medication_rounded,
            iconColor: AppColors.primary,
            label: 'Medicine',
            value: '${state.medicineAdherence.toInt()}%',
            progress: state.medicineAdherence / 100,
            progressColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            icon: Icons.monitor_heart_rounded,
            iconColor: AppColors.accent,
            label: 'Health Logs',
            value: '${state.logAdherence.toInt()}%',
            progress: state.logAdherence / 100,
            progressColor: AppColors.accent,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart(BuildContext context, ComplianceState state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 380;
    final chartHeight = isCompact ? 124.0 : 138.0;
    final barMaxHeight = isCompact ? 64.0 : 76.0;
    final barWidth = isCompact ? 22.0 : 28.0;
    final labelFontSize = isCompact ? 9.0 : 10.0;
    final percentFontSize = isCompact ? 8.0 : 9.0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 8,
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Weekly Adherence',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'This week: ${state.weeklyScore.toInt()}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (state.weeklyTrend.isEmpty)
            const Text(
              'No adherence trend available yet.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            )
          else
            SizedBox(
              height: chartHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: state.weeklyTrend.map((w) {
                  final pct = (w.percentage / 100).clamp(0.0, 1.0);
                  final color = w.percentage >= 90
                      ? AppColors.success
                      : w.percentage >= 60
                          ? AppColors.warning
                          : AppColors.danger;

                  return Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${w.percentage.toInt()}%',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: percentFontSize,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              width: barWidth,
                              height: barMaxHeight * pct,
                              constraints: BoxConstraints(
                                minHeight: pct > 0 ? 8 : 0,
                                maxHeight: barMaxHeight,
                              ),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              w.day,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: labelFontSize,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDoctorSummary(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 380;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_hospital_rounded,
                  color: Color(0xFF7C3AED),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share with Doctor',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Send your compliance report to your healthcare provider',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 14),
          isCompact
              ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryPoint(
                            icon: Icons.medication_rounded,
                            color: AppColors.primary,
                            label: 'Medicine',
                            description: 'Adherence data',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _SummaryPoint(
                            icon: Icons.monitor_heart_rounded,
                            color: AppColors.accent,
                            label: 'Vitals',
                            description: 'Trend charts',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryPoint(
                            icon: Icons.warning_rounded,
                            color: AppColors.warning,
                            label: 'Alerts',
                            description: 'Risk flags',
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _SummaryPoint(
                        icon: Icons.medication_rounded,
                        color: AppColors.primary,
                        label: 'Medicine',
                        description: 'Adherence data',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SummaryPoint(
                        icon: Icons.monitor_heart_rounded,
                        color: AppColors.accent,
                        label: 'Vitals',
                        description: 'Trend charts',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SummaryPoint(
                        icon: Icons.warning_rounded,
                        color: AppColors.warning,
                        label: 'Alerts',
                        description: 'Risk flags',
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportsScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.ios_share_rounded, size: 18),
              label: const Text(
                'Open Reports',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlerts(
    BuildContext context,
    ComplianceState state,
    WidgetRef ref,
  ) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warning,
                size: 18,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Risk Alerts',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (state.alerts.isNotEmpty)
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.riskAlerts),
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (state.alerts.isEmpty)
            const Text(
              'No active risk alerts right now.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            )
          else
            ...state.alerts.take(3).map(
                  (alert) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _AlertTile(alert: alert),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTips(ComplianceState state) {
    final tips = <String>[
      if (state.medicineAdherence < 80)
        'Try to mark every scheduled dose on time to improve medicine adherence.',
      if (state.logAdherence < 60)
        'Add at least one health reading on most days to improve your log consistency.',
      if (state.alerts.isNotEmpty)
        'Review active alerts and act on the high-priority ones first.',
      if (state.medicineAdherence >= 80 && state.logAdherence >= 60)
        'You are doing well. Keep your daily tracking consistent this week.',
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tips to Improve',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      size: 16,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreHero extends StatelessWidget {
  final ComplianceState state;

  const _ScoreHero({required this.state});

  Color _scoreColor(double score) {
    if (score >= 90) return AppColors.success;
    if (score >= 75) return AppColors.primary;
    if (score >= 50) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(state.overallScore);
    final isCompact = MediaQuery.of(context).size.width < 380;

    return GradientCard(
      colors: [AppColors.primary, const Color(0xFF1E40AF)],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overall Compliance',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.overallScore.toInt()}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isCompact ? 34 : 38,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    state.scoreLabel,
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
            width: isCompact ? 74 : 84,
            height: isCompact ? 74 : 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 8),
            ),
            child: Center(
              child: Icon(
                Icons.shield_rounded,
                color: color == AppColors.warning || color == AppColors.danger
                    ? Colors.white
                    : Colors.white,
                size: isCompact ? 30 : 34,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final RiskAlert alert;

  const _AlertTile({required this.alert});

  Color _severityColor(String severity) {
    switch (severity) {
      case 'high':
        return AppColors.danger;
      case 'medium':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  IconData _severityIcon(String severity) {
    switch (severity) {
      case 'high':
        return Icons.error_rounded;
      case 'medium':
        return Icons.warning_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(alert.severity);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_severityIcon(alert.severity), color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  alert.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _timeAgo(alert.createdAt),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (!alert.isRead)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(left: 8, top: 4),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryPoint extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String description;

  const _SummaryPoint({
    required this.icon,
    required this.color,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          description,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textMuted,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.danger.withOpacity(0.06),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.danger,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.danger,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final double progress;
  final Color progressColor;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.progress,
    required this.progressColor,
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
              Icon(
                icon,
                size: 16,
                color: iconColor,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(progressColor),
            borderRadius: BorderRadius.circular(3),
            minHeight: 5,
          ),
        ],
      ),
    );
  }
}