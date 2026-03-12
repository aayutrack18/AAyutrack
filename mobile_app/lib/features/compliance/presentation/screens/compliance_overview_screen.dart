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
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.riskAlerts),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications_rounded,
                        color: AppColors.textMuted),
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
                                color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
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
          _ScoreHero(state: state),
          const SizedBox(height: 16),
          _buildMetricCards(state),
          const SizedBox(height: 16),
          _buildWeeklyChart(state),
          const SizedBox(height: 16),
          _buildAlerts(context, state, ref),
          const SizedBox(height: 16),
          _buildTips(),
          const SizedBox(height: 16),
          _buildDoctorSummary(context),
        ],
      ),
    );
  }

  Widget _buildMetricCards(ComplianceState state) {
    return Row(children: [
      Expanded(
        child: AppCard(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [
              Icon(Icons.medication_rounded, size: 16, color: AppColors.primary),
              SizedBox(width: 6),
              Text('Medicine', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ]),
            const SizedBox(height: 8),
            Text('${state.medicineAdherence.toInt()}%',
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: state.medicineAdherence / 100,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              borderRadius: BorderRadius.circular(3),
              minHeight: 5,
            ),
          ]),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: AppCard(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [
              Icon(Icons.monitor_heart_rounded, size: 16, color: AppColors.accent),
              SizedBox(width: 6),
              Text('Health Logs', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ]),
            const SizedBox(height: 8),
            Text('${state.logAdherence.toInt()}%',
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: state.logAdherence / 100,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              borderRadius: BorderRadius.circular(3),
              minHeight: 5,
            ),
          ]),
        ),
      ),
    ]);
  }

  Widget _buildWeeklyChart(ComplianceState state) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Weekly Adherence',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'This week: ${state.weeklyScore.toInt()}%',
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
            ),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: state.weeklyTrend.map((w) {
                final pct = w.percentage / 100;
                final color = w.percentage >= 90
                    ? AppColors.success
                    : w.percentage >= 60
                        ? AppColors.warning
                        : AppColors.danger;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${w.percentage.toInt()}%',
                        style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.w600, color: color)),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      width: 28,
                      height: 80 * pct,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(w.day,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorSummary(BuildContext context) {
    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_hospital_rounded,
                color: Color(0xFF7C3AED), size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Share with Doctor',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: AppColors.textPrimary)),
              Text('Send your compliance report to your healthcare provider',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ]),
          ),
        ]),
        const SizedBox(height: 14),
        const Divider(color: AppColors.border, height: 1),
        const SizedBox(height: 14),
        Row(children: [
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
        ]),
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
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md)),
            ),
            icon: const Icon(Icons.description_rounded, size: 18),
            label: const Text('Generate Doctor Report',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }

  Widget _buildAlerts(BuildContext context, ComplianceState state, WidgetRef ref) {
    final unread = state.alerts.where((a) => !a.isRead).toList();
    if (unread.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Risk Alerts',
          actionLabel: 'View All',
          onAction: () => Navigator.pushNamed(context, AppRoutes.riskAlerts),
        ),
        const SizedBox(height: 10),
        ...unread.take(2).map((alert) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _AlertCard(alert: alert),
            )),
      ],
    );
  }

  Widget _buildTips() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.lightbulb_outline_rounded,
                size: 18, color: Color(0xFFF59E0B)),
            SizedBox(width: 8),
            Text('Today\'s Tip',
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
          ]),
          const SizedBox(height: 10),
          const Text(
            'Setting alarms for your medication times can improve your adherence by up to 40%. Try using the Reminders feature to never miss a dose.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.5, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ScoreHero extends StatelessWidget {
  final ComplianceState state;
  const _ScoreHero({required this.state});

  Color get _scoreColor {
    if (state.overallScore >= 90) return AppColors.success;
    if (state.overallScore >= 75) return AppColors.primary;
    if (state.overallScore >= 50) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      colors: [AppColors.primary, const Color(0xFF1E40AF)],
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Overall Compliance',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 4),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('${state.overallScore.toInt()}%',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900)),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(state.scoreLabel,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: state.overallScore / 100,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation(Colors.white),
                minHeight: 6,
              ),
            ),
          ]),
        ),
        const SizedBox(width: 16),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: state.overallScore / 100,
                strokeWidth: 6,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation(Colors.white),
              ),
            ),
            Text('${state.overallScore.toInt()}',
                style: const TextStyle(
                    color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          ],
        ),
      ]),
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
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 6),
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 12, color: color)),
        Text(description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
      ]),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final RiskAlert alert;
  const _AlertCard({required this.alert});

  Color get _severityColor {
    switch (alert.severity) {
      case 'high': return AppColors.danger;
      case 'medium': return AppColors.warning;
      default: return AppColors.primary;
    }
  }

  IconData get _severityIcon {
    switch (alert.severity) {
      case 'high': return Icons.error_rounded;
      case 'medium': return Icons.warning_rounded;
      default: return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _severityColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_severityIcon, size: 18, color: _severityColor),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(alert.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
          const SizedBox(height: 3),
          Text(alert.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4)),
        ])),
        Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: _severityColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(alert.severity.toUpperCase(),
              style: TextStyle(
                  fontSize: 9, fontWeight: FontWeight.w700, color: _severityColor)),
        ),
      ]),
    );
  }
}
