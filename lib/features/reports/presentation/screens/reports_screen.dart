import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/compliance/presentation/providers/compliance_provider.dart';
import 'package:aayutrack/features/health_logs/presentation/providers/health_log_provider.dart';
import 'package:aayutrack/features/medicine/presentation/providers/medicine_provider.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compliance = ref.watch(complianceProvider);
    final medicines = ref.watch(medicineProvider);
    final healthLogs = ref.watch(healthLogProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.textMuted),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sharing reports — coming soon!'),
                behavior: SnackBarBehavior.floating,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        children: [
          // Month selector
          _MonthHeader(),
          const SizedBox(height: 16),

          // Compliance snapshot
          GradientCard(
            colors: const [AppColors.primary, Color(0xFF1E40AF)],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Monthly Compliance',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 8),
                Row(children: [
                  Text('${compliance.overallScore.toInt()}%',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 44,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(compliance.scoreLabel,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${compliance.unreadAlertCount} active alert${compliance.unreadAlertCount == 1 ? '' : 's'}',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7), fontSize: 11),
                    ),
                  ]),
                ]),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: compliance.overallScore / 100,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Key metrics grid
          const SectionHeader(title: 'Key Metrics'),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _MetricTile(
                label: 'Medicine Adherence',
                value: '${compliance.medicineAdherence.toInt()}%',
                icon: Icons.medication_rounded,
                color: AppColors.primary,
              ),
              _MetricTile(
                label: 'Health Log Rate',
                value: '${compliance.logAdherence.toInt()}%',
                icon: Icons.monitor_heart_rounded,
                color: AppColors.accent,
              ),
              _MetricTile(
                label: 'Active Medicines',
                value: '${medicines.activeMedicines.length}',
                icon: Icons.tablet_rounded,
                color: const Color(0xFF7C3AED),
              ),
              _MetricTile(
                label: 'Readings Logged',
                value: '${healthLogs.logs.length}',
                icon: Icons.bar_chart_rounded,
                color: const Color(0xFFF59E0B),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Weekly trend
          const SectionHeader(title: 'Weekly Trend'),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: compliance.weeklyTrend.map((w) {
                      final pct = w.percentage / 100;
                      final barColor = w.percentage >= 90
                          ? AppColors.success
                          : w.percentage >= 60
                              ? AppColors.warning
                              : AppColors.danger;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${w.percentage.toInt()}',
                              style: TextStyle(
                                  fontSize: 9, fontWeight: FontWeight.w600, color: barColor)),
                          const SizedBox(height: 4),
                          Container(
                            width: 30,
                            height: 90 * pct,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [barColor.withOpacity(0.6), barColor],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(w.day,
                              style: const TextStyle(
                                  fontSize: 10, color: AppColors.textMuted)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Exportable report cards
          const SectionHeader(title: 'Download Reports'),
          const SizedBox(height: 10),
          _ReportCard(
            title: 'Medicine Adherence Report',
            description: 'Detailed history of all medicine doses taken and missed',
            icon: Icons.medication_rounded,
            color: AppColors.primary,
            onTap: () => _showComingSoon(context),
          ),
          const SizedBox(height: 10),
          _ReportCard(
            title: 'Health Vitals Summary',
            description: 'All BP, blood sugar, weight and other readings this month',
            icon: Icons.monitor_heart_rounded,
            color: AppColors.accent,
            onTap: () => _showComingSoon(context),
          ),
          const SizedBox(height: 10),
          _ReportCard(
            title: 'Doctor\'s Report',
            description: 'A shareable summary for your next doctor\'s appointment',
            icon: Icons.picture_as_pdf_rounded,
            color: const Color(0xFF7C3AED),
            onTap: () => _showComingSoon(context),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF reports — coming in next release!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return Row(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(children: [
          const Icon(Icons.calendar_month_rounded, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text('${months[now.month - 1]} ${now.year}',
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primary)),
        ]),
      ),
    ]);
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricTile({
    required this.label,
    required this.value,
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
          Icon(icon, size: 18, color: color),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 22, color: color)),
          Text(label,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ReportCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 3),
            Text(description,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                maxLines: 2),
          ],
        )),
        const SizedBox(width: 8),
        const Icon(Icons.download_rounded, color: AppColors.textMuted, size: 20),
      ]),
    );
  }
}
