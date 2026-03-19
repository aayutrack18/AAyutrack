import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/compliance/presentation/providers/compliance_provider.dart';
import 'package:aayutrack/features/health_logs/presentation/providers/health_log_provider.dart';
import 'package:aayutrack/features/medicine/presentation/providers/medicine_provider.dart';
import 'package:aayutrack/features/profile/presentation/providers/profile_provider.dart';
import 'package:aayutrack/features/reports/presentation/providers/reports_provider.dart';
import 'package:aayutrack/features/reports/presentation/screens/report_preview_screen.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reports'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          indicatorWeight: 2.5,
          tabs: const [
            Tab(text: 'Generate'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _GenerateTab(),
          _HistoryTab(),
        ],
      ),
    );
  }
}

class _GenerateTab extends ConsumerWidget {
  const _GenerateTab();

  Future<void> _quickSave(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(reportsProvider.notifier);
    final result = await notifier.generateReport();
    final state = ref.read(reportsProvider);

    if (!context.mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF report saved.\n${result.file.path}'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage!),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _quickShare(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(reportsProvider.notifier);
    final result = await notifier.shareLatestReport();
    final state = ref.read(reportsProvider);

    if (!context.mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report shared successfully.'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage!),
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
    final templates = ref.watch(reportTemplatesProvider);

    final isBaseDataLoading = compliance.isLoading ||
        medicines.isLoading ||
        healthLogs.isLoading ||
        profileState.isLoading;

    final providerErrors = <String>[
      if (compliance.hasError) compliance.errorMessage ?? '',
      if (medicines.hasError) medicines.errorMessage ?? '',
      if (healthLogs.hasError) healthLogs.errorMessage ?? '',
      if (profileState.errorMessage != null &&
          profileState.errorMessage!.trim().isNotEmpty)
        profileState.errorMessage!,
    ].where((message) => message.trim().isNotEmpty).toList();

    final hasSupportingData = medicines.medicines.isNotEmpty ||
        healthLogs.logs.isNotEmpty ||
        profileState.profile != null ||
        compliance.hasAnyData ||
        compliance.alerts.isNotEmpty;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        _ReportsHeroCard(
          overallScore: compliance.overallScore,
          scoreLabel: compliance.scoreLabel,
          activeAlerts: compliance.unreadAlertCount,
          canGenerate: reportsState.canGenerate,
          isBusy: isBaseDataLoading || reportsState.isExporting,
        ),
        const SizedBox(height: 16),
        if (isBaseDataLoading) ...[
          const _InlineMessageCard(
            icon: Icons.sync_rounded,
            title: 'Preparing report data',
            message:
                'AAYUTRACK is loading your latest profile, medicines, health logs, and compliance summary.',
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
        ],
        if (reportsState.hasError) ...[
          _InlineMessageCard(
            icon: Icons.error_outline_rounded,
            title: 'Report action failed',
            message: reportsState.errorMessage!,
            color: AppColors.danger,
            trailing: TextButton(
              onPressed: () => ref.read(reportsProvider.notifier).clearError(),
              child: const Text('Dismiss'),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (providerErrors.isNotEmpty) ...[
          _InlineMessageCard(
            icon: Icons.warning_amber_rounded,
            title: 'Some report data could not be loaded',
            message: providerErrors.join('\n'),
            color: AppColors.warning,
          ),
          const SizedBox(height: 12),
        ],
        if (reportsState.exportSuccess) ...[
          _InlineMessageCard(
            icon: Icons.check_circle_outline_rounded,
            title: 'Latest report ready',
            message:
                'Your report has been added to history and is ready to share again from the History tab.',
            color: AppColors.success,
            trailing: TextButton(
              onPressed: () =>
                  ref.read(reportsProvider.notifier).clearExportSuccess(),
              child: const Text('Dismiss'),
            ),
          ),
          const SizedBox(height: 12),
        ],
        _DataReadinessCard(
          hasSupportingData: hasSupportingData,
          profileAvailable: profileState.profile != null,
          activeMedicineCount: medicines.activeMedicines.length,
          totalLogCount: healthLogs.logs.length,
          enabledSectionCount: reportsState.enabledSections.length,
        ),
        const SizedBox(height: 20),
        const _SectionIntro(
          title: 'Key metrics',
          subtitle:
              'A concise snapshot of adherence, activity, and reporting coverage.',
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 380;
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isCompact ? 1.28 : 1.55,
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
            );
          },
        ),
        const SizedBox(height: 20),
        const _SectionIntro(
          title: 'Weekly adherence trend',
          subtitle:
              'Use this to explain how the report turns daily actions into a simple care summary.',
        ),
        const SizedBox(height: 10),
        if (compliance.weeklyTrend.isEmpty)
          const AppCard(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No weekly adherence trend is available yet. Add dose activity to see real report insights here.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  height: 1.5,
                ),
              ),
            ),
          )
        else
          _WeeklyAdherenceChart(trend: compliance.weeklyTrend),
        const SizedBox(height: 20),
        const _SectionIntro(
          title: 'Report template',
          subtitle:
              'Choose the presentation style that best fits your demo or doctor-sharing flow.',
        ),
        const SizedBox(height: 10),
        ...templates.map((template) {
          final isSelected = reportsState.selectedTemplateId == template.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () =>
                  ref.read(reportsProvider.notifier).setTemplate(template.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.06)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 12,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(template.icon, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            template.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textMuted.withOpacity(0.5),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        const _SectionIntro(
          title: 'Include sections',
          subtitle:
              'Turn sections on or off to generate a report with the exact level of detail you want.',
        ),
        const SizedBox(height: 10),
        AppCard(
          child: Column(
            children: reportsState.sections.asMap().entries.map((entry) {
              final index = entry.key;
              final section = entry.value;

              return Column(
                children: [
                  if (index > 0)
                    const Divider(color: AppColors.border, height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                section.description,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: section.isEnabled,
                          onChanged: (_) => ref
                              .read(reportsProvider.notifier)
                              .toggleSection(section.id),
                          activeColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        if (!reportsState.hasEnabledSections) ...[
          const SizedBox(height: 10),
          const Text(
            'Select at least one section to generate a report.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.danger,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const SizedBox(height: 20),
        const _SectionIntro(
          title: 'Date range',
          subtitle:
              'Control which period is reflected in the exported report and preview.',
        ),
        const SizedBox(height: 10),
        _DateRangeSelector(
          startDate: reportsState.startDate,
          endDate: reportsState.endDate,
          onChanged: (start, end) =>
              ref.read(reportsProvider.notifier).setDateRange(start, end),
        ),
        const SizedBox(height: 24),
        AppButton(
          label: reportsState.isExporting ? 'Preparing…' : 'Preview report',
          icon: Icons.visibility_rounded,
          isLoading: false,
          onPressed: reportsState.isExporting ||
                  isBaseDataLoading ||
                  !reportsState.canGenerate
              ? null
              : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReportPreviewScreen(),
                    ),
                  ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 380;

            final exportButton = AppButton(
              label: 'Export PDF',
              icon: Icons.picture_as_pdf_rounded,
              outlined: true,
              isLoading: reportsState.isExporting,
              onPressed: reportsState.isExporting ||
                      isBaseDataLoading ||
                      !reportsState.canGenerate
                  ? null
                  : () => _quickSave(context, ref),
            );

            final shareButton = AppButton(
              label: 'Share PDF',
              icon: Icons.share_rounded,
              isLoading: false,
              onPressed: reportsState.isExporting ||
                      isBaseDataLoading ||
                      !reportsState.canGenerate
                  ? null
                  : () => _quickShare(context, ref),
            );

            if (compact) {
              return Column(
                children: [
                  exportButton,
                  const SizedBox(height: 10),
                  shareButton,
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: exportButton),
                const SizedBox(width: 10),
                Expanded(child: shareButton),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _HistoryTab extends ConsumerWidget {
  const _HistoryTab();

  String _formatDate(DateTime dt) {
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
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  Future<void> _shareHistoryItem(
    BuildContext context,
    ReportHistoryItem item,
  ) async {
    if (item.filePath == null || item.filePath!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This report file is not available to share yet.'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final file = File(item.filePath!);
    if (!await file.exists()) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved report file was not found on device.'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await Share.shareXFiles(
      [XFile(file.path)],
      text: item.title,
      subject: item.title,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportsProvider);
    final history = state.history;

    if (history.isEmpty) {
      return const EmptyState(
        icon: Icons.history_rounded,
        title: 'No Reports Yet',
        message:
            'Generated reports will appear here. Create your first report from the Generate tab.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        _HistorySummaryCard(reportCount: history.length),
        const SizedBox(height: 16),
        ...history.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.picture_as_pdf_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.dateRange,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                StatusChip(
                                  label: item.templateName,
                                  color: AppColors.primary,
                                ),
                                Text(
                                  '${item.pageCount} pages',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                Text(
                                  _formatDate(item.generatedAt),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 420;

                      final previewButton = AppButton(
                        label: compact ? 'Preview' : 'Preview Current Setup',
                        icon: Icons.visibility_rounded,
                        outlined: true,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReportPreviewScreen(),
                          ),
                        ),
                      );

                      final shareButton = AppButton(
                        label: compact ? 'Share' : 'Share Again',
                        icon: Icons.share_rounded,
                        onPressed: () => _shareHistoryItem(context, item),
                      );

                      if (compact) {
                        return Column(
                          children: [
                            previewButton,
                            const SizedBox(height: 10),
                            shareButton,
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(child: previewButton),
                          const SizedBox(width: 10),
                          Expanded(child: shareButton),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () async {
                        final confirm = await showConfirmationSheet(
                          context,
                          title: 'Delete Report',
                          message: 'Delete "${item.title}"?',
                          confirmLabel: 'Delete',
                          isDangerous: true,
                        );
                        if (confirm == true) {
                          ref
                              .read(reportsProvider.notifier)
                              .deleteHistory(item.id);
                        }
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: AppColors.danger,
                      ),
                      label: const Text(
                        'Delete',
                        style: TextStyle(color: AppColors.danger),
                      ),
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
}

class _WeeklyAdherenceChart extends StatelessWidget {
  final List<dynamic> trend;

  const _WeeklyAdherenceChart({required this.trend});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 380;
        final double chartHeight = compact ? 168 : 182;
        final double barMaxHeight = compact ? 96 : 108;
        final double barWidth = compact ? 24 : 28;
        final double labelFont = compact ? 9 : 10;
        final double valueFont = compact ? 10 : 11;

        return AppCard(
          child: SizedBox(
            height: chartHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: trend.map((entry) {
                final double percentage =
                    ((entry.percentage as num?)?.toDouble() ?? 0)
                        .clamp(0, 100)
                        .toDouble();
                final double pct = percentage / 100;

                final Color barColor = percentage >= 90
                    ? AppColors.success
                    : percentage >= 60
                        ? AppColors.warning
                        : AppColors.danger;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          percentage.toInt().toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: valueFont,
                            fontWeight: FontWeight.w700,
                            color: barColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: barMaxHeight,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: barWidth,
                              height: (barMaxHeight * pct).clamp(
                                percentage <= 0 ? 4 : 12,
                                barMaxHeight,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    barColor.withOpacity(0.65),
                                    barColor,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 16,
                          child: Center(
                            child: Text(
                              '${entry.day}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: labelFont,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _DateRangeSelector extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function(DateTime start, DateTime end) onChanged;

  const _DateRangeSelector({
    required this.startDate,
    required this.endDate,
    required this.onChanged,
  });

  String _fmt(DateTime dt) {
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
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final hasInvalidRange = endDate.isBefore(startDate);
    final screenWidth = MediaQuery.of(context).size.width;
    final compact = screenWidth < 380;

    final fromCard = GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: startDate,
          firstDate: DateTime(2020),
          lastDate: endDate,
        );
        if (picked != null) onChanged(picked, endDate);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'From',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _fmt(startDate),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );

    final toCard = GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: endDate,
          firstDate: startDate,
          lastDate: DateTime.now(),
        );
        if (picked != null) onChanged(startDate, picked);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'To',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _fmt(endDate),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date Range',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (compact)
            Column(
              children: [
                fromCard,
                const SizedBox(height: 10),
                const Icon(
                  Icons.arrow_downward_rounded,
                  color: AppColors.textMuted,
                  size: 18,
                ),
                const SizedBox(height: 10),
                toCard,
              ],
            )
          else
            Row(
              children: [
                Expanded(child: fromCard),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                ),
                Expanded(child: toCard),
              ],
            ),
          if (hasInvalidRange) ...[
            const SizedBox(height: 8),
            const Text(
              'End date cannot be earlier than start date.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.danger,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _PresetChip(
                label: 'This Month',
                onTap: () {
                  final now = DateTime.now();
                  onChanged(DateTime(now.year, now.month, 1), now);
                },
              ),
              _PresetChip(
                label: 'Last 30 days',
                onTap: () {
                  final now = DateTime.now();
                  onChanged(now.subtract(const Duration(days: 30)), now);
                },
              ),
              _PresetChip(
                label: 'Last 3 months',
                onTap: () {
                  final now = DateTime.now();
                  final month = now.month - 3;
                  onChanged(DateTime(now.year, month, now.day), now);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PresetChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
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
          const SizedBox(height: 12),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: color,
                ),
              ),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _InlineMessageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color color;
  final Widget? trailing;

  const _InlineMessageCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: color.withOpacity(0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (trailing != null) ...[
            const SizedBox(height: 8),
            Align(alignment: Alignment.centerRight, child: trailing!),
          ],
        ],
      ),
    );
  }
}

class _DataReadinessCard extends StatelessWidget {
  final bool hasSupportingData;
  final bool profileAvailable;
  final int activeMedicineCount;
  final int totalLogCount;
  final int enabledSectionCount;

  const _DataReadinessCard({
    required this.hasSupportingData,
    required this.profileAvailable,
    required this.activeMedicineCount,
    required this.totalLogCount,
    required this.enabledSectionCount,
  });

  @override
  Widget build(BuildContext context) {
    final title = hasSupportingData
        ? 'Report data is connected to live providers'
        : 'Start adding data for richer reports';

    final message = hasSupportingData
        ? 'This report will use your current profile, medicines, health logs, and compliance insights from the live app state.'
        : 'You can still generate a basic report, but adding profile details, medicines, and health logs will make the report more useful for demos and doctor sharing.';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.verified_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusChip(
                label: profileAvailable ? 'Profile ready' : 'Profile missing',
                color: profileAvailable ? AppColors.success : AppColors.warning,
              ),
              StatusChip(
                label: '$activeMedicineCount medicines',
                color: AppColors.primary,
              ),
              StatusChip(
                label: '$totalLogCount logs',
                color: AppColors.accent,
              ),
              StatusChip(
                label: '$enabledSectionCount sections enabled',
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportsHeroCard extends StatelessWidget {
  final double overallScore;
  final String scoreLabel;
  final int activeAlerts;
  final bool canGenerate;
  final bool isBusy;

  const _ReportsHeroCard({
    required this.overallScore,
    required this.scoreLabel,
    required this.activeAlerts,
    required this.canGenerate,
    required this.isBusy,
  });

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      colors: const [AppColors.primary, Color(0xFF1E40AF)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroPill(
                label: canGenerate ? 'Ready to generate' : 'Setup required',
                icon: canGenerate
                    ? Icons.check_circle_rounded
                    : Icons.info_rounded,
              ),
              _HeroPill(
                label: activeAlerts == 0
                    ? 'No active alerts'
                    : '$activeAlerts active alert${activeAlerts == 1 ? '' : 's'}',
                icon: Icons.notifications_active_rounded,
              ),
              _HeroPill(
                label: isBusy ? 'Syncing data' : 'Live provider data',
                icon: Icons.sync_rounded,
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Care reports built for sharing',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate a clean patient summary using medicines, health logs, and adherence insights from the current app state.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.86),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                '${overallScore.toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        scoreLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Monthly compliance score reflected in the report summary.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.78),
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: overallScore / 100,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistorySummaryCard extends StatelessWidget {
  final int reportCount;

  const _HistorySummaryCard({required this.reportCount});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.history_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$reportCount report${reportCount == 1 ? '' : 's'} generated',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Saved PDFs can be reshared, reviewed, or deleted from here.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
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

class _SectionIntro extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionIntro({
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
            fontSize: 12,
            color: AppColors.textMuted,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _HeroPill extends StatelessWidget {
  final String label;
  final IconData icon;

  const _HeroPill({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}