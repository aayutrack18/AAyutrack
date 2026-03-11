import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/health_log.dart';
import '../providers/health_log_provider.dart';
import 'add_health_log_screen.dart';
import 'health_log_history_screen.dart';

class HealthLogsDashboardScreen extends ConsumerWidget {
  const HealthLogsDashboardScreen({super.key});

  Color _metricColor(MetricType type) {
    switch (type) {
      case MetricType.bloodPressure: return const Color(0xFFDC2626);
      case MetricType.bloodSugar: return const Color(0xFFF59E0B);
      case MetricType.heartRate: return const Color(0xFFEC4899);
      case MetricType.weight: return const Color(0xFF7C3AED);
      case MetricType.oxygen: return const Color(0xFF14B8A6);
      case MetricType.temperature: return const Color(0xFF6366F1);
      case MetricType.mood: return const Color(0xFF16A34A);
    }
  }

  IconData _metricIcon(MetricType type) {
    switch (type) {
      case MetricType.bloodPressure: return Icons.bloodtype_rounded;
      case MetricType.bloodSugar: return Icons.water_drop_rounded;
      case MetricType.heartRate: return Icons.favorite_rounded;
      case MetricType.weight: return Icons.monitor_weight_outlined;
      case MetricType.oxygen: return Icons.air_rounded;
      case MetricType.temperature: return Icons.thermostat_rounded;
      case MetricType.mood: return Icons.sentiment_satisfied_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(healthLogProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Health Logs',
          style: TextStyle(
              fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: AppColors.textMuted),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const HealthLogHistoryScreen()),
            ),
          ),
        ],
      ),
      body: state.isLoading
          ? const LoadingIndicator(message: 'Loading health data...')
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              children: [
                _buildLatestReadings(context, state),
                const SizedBox(height: 20),
                _buildRecentLogs(context, state, ref),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddHealthLogScreen()),
        ),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Log Reading',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildLatestReadings(
      BuildContext context, HealthLogState state) {
    final metrics = MetricType.values
        .where((t) => t != MetricType.mood)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Latest Readings'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          itemCount: metrics.length,
          itemBuilder: (_, i) {
            final type = metrics[i];
            final latest = state.latestOfType(type);
            final color = _metricColor(type);

            return MetricTile(
              label: type.label,
              value: latest?.displayValue ?? '--',
              unit: latest != null ? type.unit : '',
              icon: _metricIcon(type),
              color: color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentLogs(
      BuildContext context, HealthLogState state, WidgetRef ref) {
    final recent = state.logs.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recent Entries',
          actionLabel: 'View All',
          onAction: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const HealthLogHistoryScreen()),
          ),
        ),
        const SizedBox(height: 12),
        if (recent.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No logs yet. Start tracking!',
                  style: TextStyle(color: AppColors.textMuted)),
            ),
          )
        else
          ...recent.map((log) => _LogEntryTile(
                log: log,
                color: _metricColor(log.type),
                icon: _metricIcon(log.type),
                onDelete: () => ref
                    .read(healthLogProvider.notifier)
                    .deleteLog(log.id),
              )),
      ],
    );
  }
}

class _LogEntryTile extends StatelessWidget {
  final HealthLog log;
  final Color color;
  final IconData icon;
  final VoidCallback onDelete;

  const _LogEntryTile({
    required this.log,
    required this.color,
    required this.icon,
    required this.onDelete,
  });

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log.type.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                  if (log.notes.isNotEmpty)
                    Text(
                      log.notes,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${log.displayValue} ${log.type.unit}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: color,
                    fontSize: 15,
                  ),
                ),
                Text(
                  _timeAgo(log.recordedAt),
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
