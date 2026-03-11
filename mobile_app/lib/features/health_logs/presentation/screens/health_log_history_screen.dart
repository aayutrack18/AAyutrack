import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/health_log.dart';
import '../providers/health_log_provider.dart';

class HealthLogHistoryScreen extends ConsumerStatefulWidget {
  const HealthLogHistoryScreen({super.key});

  @override
  ConsumerState<HealthLogHistoryScreen> createState() =>
      _HealthLogHistoryScreenState();
}

class _HealthLogHistoryScreenState
    extends ConsumerState<HealthLogHistoryScreen> {
  MetricType? _filter;

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(healthLogProvider);
    final logs = _filter == null ? state.logs : state.logsOfType(_filter!);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'History',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: logs.isEmpty
                ? const EmptyState(
                    icon: Icons.history_rounded,
                    title: 'No Entries',
                    message: 'No health logs for the selected filter.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: logs.length,
                    itemBuilder: (_, i) {
                      final log = logs[i];
                      final color = _metricColor(log.type);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Dismissible(
                          key: Key(log.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppColors.danger.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.danger,
                            ),
                          ),
                          onDismissed: (_) {
                            ref
                                .read(healthLogProvider.notifier)
                                .deleteLog(log.id);
                          },
                          child: AppCard(
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _metricIcon(log.type),
                                    color: color,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        log.type.label,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        _formatDate(log.recordedAt),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                      if (log.notes.isNotEmpty)
                                        Text(
                                          log.notes,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textMuted,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${log.displayValue} ${log.type.unit}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: color,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isSelected: _filter == null,
            onTap: () => setState(() => _filter = null),
          ),
          ...MetricType.values.map(
            (type) => _FilterChip(
              label: type.label,
              isSelected: _filter == type,
              onTap: () => setState(
                () => _filter = _filter == type ? null : type,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}