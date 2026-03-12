import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';
import 'package:aayutrack/features/health_logs/presentation/providers/health_log_provider.dart';
import 'package:aayutrack/features/health_logs/presentation/screens/add_health_log_screen.dart';
import 'package:aayutrack/features/health_logs/presentation/screens/health_log_history_screen.dart';

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
        title: const Text('Health Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: AppColors.textMuted),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HealthLogHistoryScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.primary),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AddHealthLogScreen())),
          ),
        ],
      ),
      body: state.isLoading
          ? const LoadingIndicator(message: 'Loading health data...')
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              children: [
                _buildLogButton(context),
                const SizedBox(height: 20),
                const SectionHeader(title: 'Latest Readings'),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.25,
                  children: MetricType.values.map((type) {
                    final latest = state.latestOfType(type);
                    final color = _metricColor(type);
                    return _MetricCard(
                      type: type,
                      log: latest,
                      color: color,
                      icon: _metricIcon(type),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const AddHealthLogScreen())),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                SectionHeader(
                  title: 'Recent Logs',
                  actionLabel: 'View All',
                  onAction: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HealthLogHistoryScreen())),
                ),
                const SizedBox(height: 12),
                if (state.logs.isEmpty)
                  const _EmptyLogsCard()
                else
                  ...state.logs.take(5).map((log) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _LogListItem(log: log, color: _metricColor(log.type), icon: _metricIcon(log.type)),
                      )),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddHealthLogScreen())),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Log Reading',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildLogButton(BuildContext context) {
    return GradientCard(
      colors: const [AppColors.accent, Color(0xFF0D9488)],
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Log a Reading',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('Track BP, sugar, weight & more',
                style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12)),
          ]),
        ),
        ElevatedButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddHealthLogScreen())),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.accent,
            minimumSize: const Size(0, 38),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Log Now', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final MetricType type;
  final HealthLog? log;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _MetricCard({
    required this.type,
    required this.log,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            if (log != null)
              Text(_timeAgo(log!.recordedAt),
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ]),
          const Spacer(),
          Text(
            log?.displayValue ?? '--',
            style: TextStyle(
                fontSize: log != null ? 20 : 22,
                fontWeight: FontWeight.w800,
                color: log != null ? AppColors.textPrimary : AppColors.textMuted),
          ),
          if (log != null && type.unit.isNotEmpty)
            Text(type.unit,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          Text(type.label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _LogListItem extends StatelessWidget {
  final HealthLog log;
  final Color color;
  final IconData icon;

  const _LogListItem({required this.log, required this.color, required this.icon});

  String _formatDt(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month-1]}, $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(log.type.label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
          Text(_formatDt(log.recordedAt),
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(log.displayValue,
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: color)),
          if (log.type.unit.isNotEmpty)
            Text(log.type.unit,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ]),
      ]),
    );
  }
}

class _EmptyLogsCard extends StatelessWidget {
  const _EmptyLogsCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: const Column(children: [
        Icon(Icons.monitor_heart_outlined, color: AppColors.textMuted, size: 40),
        SizedBox(height: 12),
        Text('No readings yet',
            style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        SizedBox(height: 4),
        Text('Tap "Log Now" to record your first health reading.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
      ]),
    );
  }
}
