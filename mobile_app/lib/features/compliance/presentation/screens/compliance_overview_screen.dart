import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../providers/compliance_provider.dart';

class ComplianceOverviewScreen extends ConsumerWidget {
  const ComplianceOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(complianceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Compliance',
          style: TextStyle(
              fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        actions: [
          if (state.unreadAlertCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, AppRoutes.riskAlerts),
                child: Stack(
                  children: [
                    const Icon(Icons.notifications_rounded,
                        color: AppColors.textMuted),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: AppColors.danger,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${state.unreadAlertCount}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 9),
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        children: [
          _ComplianceScoreCard(state: state),
          const SizedBox(height: 16),
          _buildDetailCards(context, state),
          const SizedBox(height: 20),
          _buildWeeklyProgress(context, state),
          const SizedBox(height: 20),
          _buildRecentAlerts(context, state, ref),
        ],
      ),
    );
  }

  Widget _buildDetailCards(
      BuildContext context, ComplianceState state) {
    return Row(
      children: [
        Expanded(
          child: _ScoreTile(
            label: 'Medicine\nAdherence',
            score: state.medicineAdherence,
            icon: Icons.medication_rounded,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ScoreTile(
            label: 'Log\nAdherence',
            score: state.logAdherence,
            icon: Icons.edit_note_rounded,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ScoreTile(
            label: 'Weekly\nScore',
            score: state.weeklyScore,
            icon: Icons.calendar_today_rounded,
            color: const Color(0xFF7C3AED),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyProgress(
      BuildContext context, ComplianceState state) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Weekly Adherence'),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: state.weeklyTrend.map((d) {
                final barHeight = 80 * d.percentage / 100;
                final color = d.percentage >= 80
                    ? AppColors.success
                    : d.percentage >= 50
                        ? const Color(0xFFF59E0B)
                        : AppColors.danger;
                final isToday = d.day ==
                    ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat',
                        'Sun'][DateTime.now().weekday - 1];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${d.percentage.toInt()}%',
                      style: TextStyle(
                          fontSize: 9,
                          color: color,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 30,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: color.withOpacity(isToday ? 1 : 0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      d.day,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isToday
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isToday
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAlerts(
      BuildContext context, ComplianceState state, WidgetRef ref) {
    final recentAlerts = state.alerts.take(3).toList();

    return Column(
      children: [
        SectionHeader(
          title: 'Risk Alerts',
          actionLabel: 'View All',
          onAction: () =>
              Navigator.pushNamed(context, AppRoutes.riskAlerts),
        ),
        const SizedBox(height: 12),
        ...recentAlerts.map((alert) => _AlertCard(
              alert: alert,
              onTap: () {
                ref
                    .read(complianceProvider.notifier)
                    .markAlertRead(alert.id);
              },
            )),
      ],
    );
  }
}

class _ComplianceScoreCard extends StatelessWidget {
  final ComplianceState state;

  const _ComplianceScoreCard({required this.state});

  Color get _scoreColor {
    if (state.overallScore >= 90) return AppColors.success;
    if (state.overallScore >= 75) return AppColors.primary;
    if (state.overallScore >= 50) return const Color(0xFFF59E0B);
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      colors: [AppColors.primary, AppColors.primaryDark],
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
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  '${state.overallScore.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    state.scoreLabel,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: state.overallScore / 100,
                  strokeWidth: 10,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  color: Colors.white,
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Icon(
                    Icons.verified_rounded,
                    color: Colors.white.withOpacity(0.9),
                    size: 36,
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

class _ScoreTile extends StatelessWidget {
  final String label;
  final double score;
  final IconData icon;
  final Color color;

  const _ScoreTile({
    required this.label,
    required this.score,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            '${score.toInt()}%',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: color,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 10, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final RiskAlert alert;
  final VoidCallback onTap;

  const _AlertCard({required this.alert, required this.onTap});

  Color get _severityColor {
    switch (alert.severity) {
      case 'high': return AppColors.danger;
      case 'medium': return const Color(0xFFF59E0B);
      default: return AppColors.accent;
    }
  }

  IconData get _severityIcon {
    switch (alert.severity) {
      case 'high': return Icons.warning_rounded;
      case 'medium': return Icons.info_rounded;
      default: return Icons.lightbulb_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _severityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_severityIcon, color: _severityColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          alert.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              fontSize: 13),
                        ),
                      ),
                      if (!alert.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert.description,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
