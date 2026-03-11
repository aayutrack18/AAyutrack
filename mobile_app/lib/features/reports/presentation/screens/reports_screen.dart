import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../compliance/presentation/providers/compliance_provider.dart';
import '../../../health_logs/domain/entities/health_log.dart';
import '../../../health_logs/presentation/providers/health_log_provider.dart';
import '../../../medicine/presentation/providers/medicine_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).profile;
    final medicines = ref.watch(medicineProvider);
    final healthLogs = ref.watch(healthLogProvider);
    final compliance = ref.watch(complianceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Reports',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textMuted),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Export/Share feature coming soon!')),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        children: [
          // Header summary card
          GradientCard(
            colors: const [AppColors.primary, AppColors.primaryDark],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.summarize_rounded,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Text('Health Summary Report',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _monthYear(),
                  style:
                      const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _HeaderStat(
                        label: 'Compliance',
                        value:
                            '${compliance.overallScore.toInt()}%'),
                    _HeaderStat(
                        label: 'Medicines',
                        value:
                            '${medicines.activeMedicines.length} active'),
                    _HeaderStat(
                        label: 'Logs',
                        value: '${healthLogs.logs.length} entries'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Profile section
          _ReportSection(
            title: 'Patient Profile',
            icon: Icons.person_rounded,
            color: AppColors.primary,
            children: [
              _ReportRow('Name', profile?.fullName ?? 'Not set'),
              _ReportRow('Age', profile != null ? '${profile.age} years' : '--'),
              _ReportRow('Blood Group', profile?.bloodGroup ?? '--'),
              _ReportRow('Conditions', profile?.medicalConditions.isNotEmpty == true
                  ? profile!.medicalConditions
                  : 'None listed'),
            ],
          ),
          const SizedBox(height: 16),

          // Medicine section
          _ReportSection(
            title: 'Medicine Summary',
            icon: Icons.medication_rounded,
            color: const Color(0xFF14B8A6),
            children: [
              _ReportRow('Total Medicines',
                  '${medicines.medicines.length}'),
              _ReportRow('Active',
                  '${medicines.activeMedicines.length}'),
              _ReportRow('Paused',
                  '${medicines.inactiveMedicines.length}'),
              ...medicines.activeMedicines.take(3).map((m) =>
                  _ReportRow(m.name, '${m.dosage} · ${m.frequency}')),
            ],
          ),
          const SizedBox(height: 16),

          // Health Logs Section
          _ReportSection(
            title: 'Health Log Summary',
            icon: Icons.monitor_heart_rounded,
            color: const Color(0xFFEC4899),
            children: [
              _ReportRow('Total Entries', '${healthLogs.logs.length}'),
              ...MetricType.values.map((type) {
                final latest = healthLogs.latestOfType(type);
                return _ReportRow(
                  type.label,
                  latest != null
                      ? '${latest.displayValue} ${type.unit}'
                      : 'No data',
                );
              }),
            ],
          ),
          const SizedBox(height: 16),

          // Compliance section
          _ReportSection(
            title: 'Compliance Summary',
            icon: Icons.verified_rounded,
            color: const Color(0xFF7C3AED),
            children: [
              _ReportRow('Overall Score',
                  '${compliance.overallScore.toInt()}% (${compliance.scoreLabel})'),
              _ReportRow('Medicine Adherence',
                  '${compliance.medicineAdherence.toInt()}%'),
              _ReportRow('Log Adherence',
                  '${compliance.logAdherence.toInt()}%'),
              _ReportRow('Risk Alerts',
                  '${compliance.alerts.length} total'),
              _ReportRow('Unread Alerts',
                  '${compliance.unreadAlertCount}'),
            ],
          ),
          const SizedBox(height: 24),

          // Export button
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Export Report',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Share your health report with your doctor or caregiver.',
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Share PDF',
                        icon: Icons.picture_as_pdf_rounded,
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('PDF export coming soon!')),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        label: 'Share Link',
                        icon: Icons.link_rounded,
                        outlined: true,
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Share link coming soon!')),
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
    );
  }

  String _monthYear() {
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[now.month - 1]} ${now.year}';
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;

  const _HeaderStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16)),
          Text(label,
              style:
                  const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

class _ReportSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _ReportSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ],
          ),
          const Divider(height: 20, color: AppColors.border),
          ...children,
        ],
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReportRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textMuted)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
