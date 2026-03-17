import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/compliance/presentation/providers/compliance_provider.dart';
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';
import 'package:aayutrack/features/health_logs/presentation/providers/health_log_provider.dart';
import 'package:aayutrack/features/medicine/presentation/providers/medicine_provider.dart';
import 'package:aayutrack/features/profile/presentation/providers/profile_provider.dart';
import 'package:aayutrack/features/reports/presentation/providers/reports_provider.dart';
import 'package:aayutrack/features/reports/presentation/screens/report_pdf_design_screen.dart';
import 'package:aayutrack/features/reports/presentation/services/report_export_service.dart';

class ReportPreviewScreen extends ConsumerWidget {
  const ReportPreviewScreen({super.key});

  String _fmt(DateTime dt) {
    const m = [
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
      'Dec'
    ];
    return '${dt.day} ${m[dt.month - 1]} ${dt.year}';
  }

  Future<void> _saveReport(BuildContext context, WidgetRef ref) async {
    final reportsState = ref.read(reportsProvider);
    final compliance = ref.read(complianceProvider);
    final medicines = ref.read(medicineProvider);
    final healthLogs = ref.read(healthLogProvider);
    final profile = ref.read(profileProvider).profile;

    final notifier = ref.read(reportsProvider.notifier);

    try {
      notifier.setExporting(true);

      final result = await ReportExportService.saveReport(
        reportsState: reportsState,
        compliance: compliance,
        medicines: medicines,
        healthLogs: healthLogs,
        profile: profile,
      );

      notifier.addGeneratedReport(
        title: result.title,
        dateRange: result.dateRange,
        pageCount: result.pageCount,
        filePath: result.file.path,
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report saved successfully.\n${result.file.path}'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      notifier.setExporting(false);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save report: $e'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _shareReport(BuildContext context, WidgetRef ref) async {
    final reportsState = ref.read(reportsProvider);
    final compliance = ref.read(complianceProvider);
    final medicines = ref.read(medicineProvider);
    final healthLogs = ref.read(healthLogProvider);
    final profile = ref.read(profileProvider).profile;

    final notifier = ref.read(reportsProvider.notifier);

    try {
      notifier.setExporting(true);

      final result = await ReportExportService.shareReport(
        reportsState: reportsState,
        compliance: compliance,
        medicines: medicines,
        healthLogs: healthLogs,
        profile: profile,
      );

      notifier.addGeneratedReport(
        title: result.title,
        dateRange: result.dateRange,
        pageCount: result.pageCount,
        filePath: result.file.path,
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report shared successfully'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      notifier.setExporting(false);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share report: $e'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsState = ref.watch(reportsProvider);
    final compliance = ref.watch(complianceProvider);
    final medicines = ref.watch(medicineProvider);
    final healthLogs = ref.watch(healthLogProvider);
    final profileState = ref.watch(profileProvider);
    final profile = profileState.profile;

    final enabledSections = reportsState.enabledSections;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Report Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.primary),
            onPressed: reportsState.isExporting
                ? null
                : () => _shareReport(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded, color: AppColors.primary),
            onPressed: reportsState.isExporting
                ? null
                : () => _saveReport(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ReportHeader(
              patientName: profile?.fullName ?? 'Patient',
              dateRange:
                  '${_fmt(reportsState.startDate)} – ${_fmt(reportsState.endDate)}',
              generatedOn: _fmt(DateTime.now()),
            ),
            const SizedBox(height: 20),

            if (enabledSections.any((s) => s.id == 'compliance')) ...[
              _SectionDivider(title: 'Compliance Summary'),
              const SizedBox(height: 12),
              _ComplianceSection(compliance: compliance),
              const SizedBox(height: 20),
            ],

            if (enabledSections.any((s) => s.id == 'medicines')) ...[
              _SectionDivider(title: 'Medicine Schedule'),
              const SizedBox(height: 12),
              _MedicinesSection(medicines: medicines),
              const SizedBox(height: 20),
            ],

            if (enabledSections.any((s) => s.id == 'vitals')) ...[
              _SectionDivider(title: 'Health Vitals'),
              const SizedBox(height: 12),
              _VitalsSection(healthLogs: healthLogs),
              const SizedBox(height: 20),
            ],

            if (enabledSections.any((s) => s.id == 'alerts')) ...[
              _SectionDivider(title: 'Risk Alerts'),
              const SizedBox(height: 12),
              _AlertsSection(compliance: compliance),
              const SizedBox(height: 20),
            ],

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.primary.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'AAYUTRACK Report',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Generated on ${_fmt(DateTime.now())} · Digital Compliance & Remote Patient Monitoring Platform · This report is for informational purposes only.',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Design & Export PDF',
              icon: Icons.picture_as_pdf_rounded,
              isLoading: reportsState.isExporting,
              onPressed: reportsState.isExporting
                  ? null
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReportPdfDesignScreen(),
                        ),
                      ),
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Save Report',
              icon: Icons.download_rounded,
              outlined: true,
              isLoading: reportsState.isExporting,
              onPressed: reportsState.isExporting
                  ? null
                  : () => _saveReport(context, ref),
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Share Report',
              icon: Icons.share_rounded,
              outlined: true,
              isLoading: reportsState.isExporting,
              onPressed: reportsState.isExporting
                  ? null
                  : () => _shareReport(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportHeader extends StatelessWidget {
  final String patientName;
  final String dateRange;
  final String generatedOn;

  const _ReportHeader({
    required this.patientName,
    required this.dateRange,
    required this.generatedOn,
  });

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      colors: const [AppColors.primary, Color(0xFF1E3A8A)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.description_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AAYUTRACK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      'Health Compliance Report',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 12),
          _headerRow('Patient', patientName),
          const SizedBox(height: 6),
          _headerRow('Period', dateRange),
          const SizedBox(height: 6),
          _headerRow('Generated', generatedOn),
        ],
      ),
    );
  }

  Widget _headerRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget {
  final String title;

  const _SectionDivider({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _ComplianceSection extends StatelessWidget {
  final ComplianceState compliance;

  const _ComplianceSection({required this.compliance});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          child: Row(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: compliance.overallScore / 100,
                      strokeWidth: 6,
                      backgroundColor: AppColors.border,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.primary,
                      ),
                    ),
                    Text(
                      '${compliance.overallScore.toInt()}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overall Compliance Score',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _ScoreBadge(
                          label: 'Medicine',
                          value: '${compliance.medicineAdherence.toInt()}%',
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        _ScoreBadge(
                          label: 'Logs',
                          value: '${compliance.logAdherence.toInt()}%',
                          color: AppColors.accent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    StatusChip(
                      label: compliance.scoreLabel,
                      color: compliance.overallScore >= 75
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ScoreBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _MedicinesSection extends StatelessWidget {
  final MedicineState medicines;

  const _MedicinesSection({required this.medicines});

  @override
  Widget build(BuildContext context) {
    if (medicines.medicines.isEmpty) {
      return AppCard(
        child: const Row(
          children: [
            Icon(Icons.medication_outlined, color: AppColors.textMuted),
            SizedBox(width: 12),
            Text(
              'No medicines recorded',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return Column(
      children: medicines.medicines.map((m) {
        Color color;
        try {
          color = Color(int.parse(m.color.replaceFirst('#', '0xFF')));
        } catch (_) {
          color = AppColors.primary;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.tablet_rounded, color: color, size: 18),
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
                StatusChip(
                  label: m.isActive ? 'Active' : 'Paused',
                  color:
                      m.isActive ? AppColors.success : AppColors.textMuted,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _VitalsSection extends StatelessWidget {
  final HealthLogState healthLogs;

  const _VitalsSection({required this.healthLogs});

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Color _metricColor(MetricType t) {
    switch (t) {
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

  @override
  Widget build(BuildContext context) {
    final latestByMetric = healthLogs.latestByMetric;
    final hasData = latestByMetric.values.any((v) => v != null);

    if (!hasData) {
      return AppCard(
        child: const Row(
          children: [
            Icon(Icons.monitor_heart_outlined, color: AppColors.textMuted),
            SizedBox(width: 12),
            Text(
              'No health readings recorded',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return Column(
      children: MetricType.values.map((type) {
        final log = latestByMetric[type];
        if (log == null) return const SizedBox.shrink();

        final color = _metricColor(type);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(type.icon, style: const TextStyle(fontSize: 14)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        _timeAgo(log.recordedAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${log.displayValue}${type.unit.isNotEmpty ? ' ${type.unit}' : ''}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _AlertsSection extends StatelessWidget {
  final ComplianceState compliance;

  const _AlertsSection({required this.compliance});

  @override
  Widget build(BuildContext context) {
    final alerts = compliance.alerts;

    if (alerts.isEmpty) {
      return AppCard(
        child: const Row(
          children: [
            Icon(Icons.shield_outlined, color: AppColors.success),
            SizedBox(width: 12),
            Text(
              'No active alerts',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return Column(
      children: alerts.map((alert) {
        final color = alert.severity == 'high'
            ? AppColors.danger
            : alert.severity == 'medium'
                ? AppColors.warning
                : AppColors.primary;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: AppCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    alert.severity == 'high'
                        ? Icons.error_rounded
                        : Icons.warning_rounded,
                    color: color,
                    size: 16,
                  ),
                ),
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
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        alert.description,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
      }).toList(),
    );
  }
}