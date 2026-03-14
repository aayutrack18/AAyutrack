import 'package:flutter/material.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';
import 'package:aayutrack/features/health_logs/presentation/providers/health_log_provider.dart';
import 'package:aayutrack/features/health_logs/presentation/screens/edit_health_log_screen.dart';

class MetricDetailScreen extends ConsumerWidget {
  final MetricType metricType;
  const MetricDetailScreen({super.key, required this.metricType});

  Color get _color {
    switch (metricType) {
      case MetricType.bloodPressure: return const Color(0xFFDC2626);
      case MetricType.bloodSugar:   return const Color(0xFFF59E0B);
      case MetricType.heartRate:    return const Color(0xFFEC4899);
      case MetricType.weight:       return const Color(0xFF7C3AED);
      case MetricType.oxygen:       return const Color(0xFF14B8A6);
      case MetricType.temperature:  return const Color(0xFF6366F1);
      case MetricType.mood:         return const Color(0xFF16A34A);
    }
  }

  String get _normalRange {
    switch (metricType) {
      case MetricType.bloodPressure: return '90–120 / 60–80 mmHg';
      case MetricType.bloodSugar:    return 'Fasting: 70–100 mg/dL';
      case MetricType.heartRate:     return '60–100 bpm (resting)';
      case MetricType.weight:        return 'Varies by individual';
      case MetricType.oxygen:        return '95–100%';
      case MetricType.temperature:   return '36.1–37.2°C';
      case MetricType.mood:          return 'Scale 1–10';
    }
  }

  IconData get _iconData {
    switch (metricType) {
      case MetricType.bloodPressure: return Icons.bloodtype_rounded;
      case MetricType.bloodSugar:    return Icons.water_drop_rounded;
      case MetricType.heartRate:     return Icons.favorite_rounded;
      case MetricType.weight:        return Icons.monitor_weight_outlined;
      case MetricType.oxygen:        return Icons.air_rounded;
      case MetricType.temperature:   return Icons.thermostat_rounded;
      case MetricType.mood:          return Icons.sentiment_satisfied_rounded;
    }
  }

  String _formatDt(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sep','Oct','Nov','Dec'];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]}, $h:$m';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(healthLogProvider);
    final logs = state.logsOfType(metricType);
    final color = _color;

    // Stats
    double? avgValue;
    double? minValue;
    double? maxValue;
    if (logs.isNotEmpty) {
      final values = logs.map((l) => l.value).toList();
      avgValue = values.reduce((a, b) => a + b) / values.length;
      minValue = values.reduce((a, b) => a < b ? a : b);
      maxValue = values.reduce((a, b) => a > b ? a : b);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(metricType.label),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: AppColors.textMuted),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(metricType.label),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Unit: ${metricType.unit.isEmpty ? 'N/A' : metricType.unit}',
                        style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Text('Normal range: $_normalRange',
                        style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    const Text(
                      'Readings are for tracking purposes only. Always consult your doctor for medical advice.',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Got it'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: logs.isEmpty
          ? EmptyState(
              icon: _iconData,
              title: 'No ${metricType.label} Readings',
              message: 'Start logging your ${metricType.label.toLowerCase()} readings to see trends here.',
            )
          : Column(
              children: [
                // Header card with latest + stats
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Column(children: [
                    // Latest reading hero
                    GradientCard(
                      colors: [color, color.withOpacity(0.7)],
                      child: Row(children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(metricType.icon,
                              style: const TextStyle(fontSize: 24)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Latest Reading',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 4),
                              Text(
                                '${logs.first.displayValue}${metricType.unit.isNotEmpty ? ' ${metricType.unit}' : ''}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    height: 1.1),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDt(logs.first.recordedAt),
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Normal\nrange:\n$_normalRange',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  height: 1.4)),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 12),

                    // Stats row
                    if (logs.length > 1)
                      Row(children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Average',
                            value: avgValue!.toStringAsFixed(1),
                            unit: metricType.unit,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatCard(
                            label: 'Lowest',
                            value: minValue!.toStringAsFixed(1),
                            unit: metricType.unit,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatCard(
                            label: 'Highest',
                            value: maxValue!.toStringAsFixed(1),
                            unit: metricType.unit,
                            color: AppColors.danger,
                          ),
                        ),
                      ]),
                    const SizedBox(height: 12),

                    // Mini bar chart (last 7 readings)
                    if (logs.length >= 3) ...[
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Recent Trend',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: AppColors.textPrimary)),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 80,
                              child: _MiniTrendChart(
                                  logs: logs.take(7).toList().reversed.toList(),
                                  color: color),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ]),
                ),

                // History list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                    itemCount: logs.length,
                    itemBuilder: (context, i) {
                      final log = logs[i];
                      return Dismissible(
                        key: Key(log.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.danger,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: const Icon(Icons.delete_outline,
                              color: Colors.white, size: 24),
                        ),
                        confirmDismiss: (_) => showConfirmationSheet(
                          context,
                          title: 'Delete Reading',
                          message: 'Remove this ${metricType.label} reading?',
                          confirmLabel: 'Delete',
                          isDangerous: true,
                        ),
                        onDismissed: (_) {
                          ref.read(healthLogProvider.notifier).deleteLog(log.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Reading deleted'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColors.danger,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AppCard(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            child: Row(children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(_iconData, color: color, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                  Text(_formatDt(log.recordedAt),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500)),
                                  if (log.notes.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(log.notes,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textMuted),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ]),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                Text(
                                  '${log.displayValue}${metricType.unit.isNotEmpty ? ' ${metricType.unit}' : ''}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: color),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            EditHealthLogScreen(log: log)),
                                  ),
                                  child: const Icon(Icons.edit_outlined,
                                      size: 16, color: AppColors.textMuted),
                                ),
                              ]),
                            ]),
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
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 18, color: color)),
        if (unit.isNotEmpty)
          Text(unit,
              style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(label,
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ]),
    );
  }
}

class _MiniTrendChart extends StatelessWidget {
  final List<HealthLog> logs;
  final Color color;

  const _MiniTrendChart({required this.logs, required this.color});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) return const SizedBox.shrink();
    final values = logs.map((l) => l.value).toList();
    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV).abs();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: logs.asMap().entries.map((entry) {
        final val = entry.value.value;
        final heightFraction = range < 0.01 ? 0.7 : (val - minV) / range * 0.8 + 0.1;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(entry.value.displayValue,
                style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: color)),
            const SizedBox(height: 3),
            Container(
              width: 24,
              height: 60 * heightFraction,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.4), color],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
