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
              onPressed: () => ref.read(reportsProvider.notifier).clearExportSuccess(),
              child: const Text('Dismiss'),
            ),
          ),
          const SizedBox(height: 12),
        ],
        GradientCard(
          colors: const [AppColors.primary, Color(0xFF1E40AF)],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Monthly Compliance',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${compliance.overallScore.toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 44,
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
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            compliance.scoreLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${compliance.unreadAlertCount} active alert${compliance.unreadAlertCount == 1 ? '' : 's'}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
        _DataReadinessCard(
          hasSupportingData: hasSupportingData,
          profileAvailable: profileState.profile != null,
          activeMedicineCount: medicines.activeMedicines.length,
          totalLogCount: healthLogs.logs.length,
          enabledSectionCount: reportsState.enabledSections.length,
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Key Metrics'),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.55,
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
        const SectionHeader(title: 'Weekly Adherence Trend'),
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
          AppCard(
            child: SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: compliance.weeklyTrend.map((entry) {
                  final pct = entry.percentage / 100;
                  final barColor = entry.percentage >= 90
                      ? AppColors.success
                      : entry.percentage >= 60
                          ? AppColors.warning
                          : AppColors.danger;
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${entry.percentage.toInt()}',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: barColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 26,
                          height: 90 * pct.clamp(0.0, 1.0),
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
                        Text(
                          entry.day,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Report Template'),
        const SizedBox(height: 10),
        ...templates.map((template) {
          final isSelected = reportsState.selectedTemplateId == template.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () => ref.read(reportsProvider.notifier).setTemplate(template.id),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Include Sections'),
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
        _DateRangeSelector(
          startDate: reportsState.startDate,
          endDate: reportsState.endDate,
          onChanged: (start, end) =>
              ref.read(reportsProvider.notifier).setDateRange(start, end),
        ),
        const SizedBox(height: 24),
        AppButton(
          label: reportsState.isExporting ? 'Preparing…' : 'Preview Report',
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
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Export PDF',
                icon: Icons.picture_as_pdf_rounded,
                outlined: true,
                isLoading: reportsState.isExporting,
                onPressed: reportsState.isExporting ||
                        isBaseDataLoading ||
                        !reportsState.canGenerate
                    ? null
                    : () => _quickSave(context, ref),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AppButton(
                label: 'Share PDF',
                icon: Icons.share_rounded,
                isLoading: false,
                onPressed: reportsState.isExporting ||
                        isBaseDataLoading ||
                        !reportsState.canGenerate
                    ? null
                    : () => _quickShare(context, ref),
              ),
            ),
          ],
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
        AppCard(
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
                      '${history.length} report${history.length == 1 ? '' : 's'} generated',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'Saved PDFs can be reshared from here.',
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
        ),
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
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Preview Current Setup',
                          icon: Icons.visibility_rounded,
                          outlined: true,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ReportPreviewScreen(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(
                          label: 'Share Again',
                          icon: Icons.share_rounded,
                          onPressed: () => _shareHistoryItem(context, item),
                        ),
                      ),
                    ],
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
                          ref.read(reportsProvider.notifier).deleteHistory(item.id);
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
          Row(
            children: [
              Expanded(
                child: GestureDetector(
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.textMuted,
                  size: 18,
                ),
              ),
              Expanded(
                child: GestureDetector(
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
            maxLines: 1,
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
