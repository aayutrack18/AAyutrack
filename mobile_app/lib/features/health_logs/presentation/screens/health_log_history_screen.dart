import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';
import 'package:aayutrack/features/health_logs/presentation/providers/health_log_provider.dart';

class HealthLogHistoryScreen extends ConsumerStatefulWidget {
  const HealthLogHistoryScreen({super.key});

  @override
  ConsumerState<HealthLogHistoryScreen> createState() => _HealthLogHistoryScreenState();
}

class _HealthLogHistoryScreenState extends ConsumerState<HealthLogHistoryScreen> {
  MetricType? _filterType;

  Color _metricColor(MetricType t) {
    switch (t) {
      case MetricType.bloodPressure: return const Color(0xFFDC2626);
      case MetricType.bloodSugar: return const Color(0xFFF59E0B);
      case MetricType.heartRate: return const Color(0xFFEC4899);
      case MetricType.weight: return const Color(0xFF7C3AED);
      case MetricType.oxygen: return const Color(0xFF14B8A6);
      case MetricType.temperature: return const Color(0xFF6366F1);
      case MetricType.mood: return const Color(0xFF16A34A);
    }
  }

  IconData _metricIcon(MetricType t) {
    switch (t) {
      case MetricType.bloodPressure: return Icons.bloodtype_rounded;
      case MetricType.bloodSugar: return Icons.water_drop_rounded;
      case MetricType.heartRate: return Icons.favorite_rounded;
      case MetricType.weight: return Icons.monitor_weight_outlined;
      case MetricType.oxygen: return Icons.air_rounded;
      case MetricType.temperature: return Icons.thermostat_rounded;
      case MetricType.mood: return Icons.sentiment_satisfied_rounded;
    }
  }

  String _formatDt(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(healthLogProvider);
    final logs = _filterType != null
        ? state.logsOfType(_filterType!)
        : state.logs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Health History')),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _filterType == null,
                  color: AppColors.primary,
                  onTap: () => setState(() => _filterType = null),
                ),
                const SizedBox(width: 8),
                ...MetricType.values.map((t) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FilterChip(
                        label: t.label.split(' ').first,
                        isSelected: _filterType == t,
                        color: _metricColor(t),
                        onTap: () =>
                            setState(() => _filterType = _filterType == t ? null : t),
                      ),
                    )),
              ],
            ),
          ),
          // Stats bar
          if (logs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem('Total', '${logs.length}'),
                    _statItem('This Week',
                        '${logs.where((l) => DateTime.now().difference(l.recordedAt).inDays < 7).length}'),
                    _statItem('Today',
                        '${logs.where((l) => DateTime.now().difference(l.recordedAt).inDays == 0).length}'),
                  ],
                ),
              ),
            ),
          Expanded(
            child: logs.isEmpty
                ? const EmptyState(
                    icon: Icons.monitor_heart_outlined,
                    title: 'No Records Found',
                    message: 'No health logs match your current filter.')
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    itemCount: logs.length,
                    itemBuilder: (ctx, i) {
                      final log = logs[i];
                      final color = _metricColor(log.type);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: AppCard(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          child: Row(children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(_metricIcon(log.type),
                                  color: color, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(log.type.label,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: AppColors.textPrimary)),
                                Text(_formatDt(log.recordedAt),
                                    style: const TextStyle(
                                        fontSize: 11, color: AppColors.textMuted)),
                                if (log.notes.isNotEmpty)
                                  Text(log.notes,
                                      style: const TextStyle(
                                          fontSize: 11, color: AppColors.textMuted),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                              ],
                            )),
                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              Text(log.displayValue,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      color: color)),
                              if (log.type.unit.isNotEmpty)
                                Text(log.type.unit,
                                    style: const TextStyle(
                                        fontSize: 11, color: AppColors.textMuted)),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(log.source,
                                    style: const TextStyle(
                                        fontSize: 9, color: AppColors.textMuted)),
                              ),
                            ]),
                          ]),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(children: [
      Text(value,
          style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: AppColors.textPrimary)),
      Text(label,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
    ]);
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textMuted),
        ),
      ),
    );
  }
}
