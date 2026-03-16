import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/compliance/presentation/providers/compliance_provider.dart';

class RiskAlertsScreen extends ConsumerWidget {
  const RiskAlertsScreen({super.key});

  Color _severityColor(String severity) {
    switch (severity) {
      case 'high': return AppColors.danger;
      case 'medium': return AppColors.warning;
      default: return AppColors.primary;
    }
  }

  IconData _severityIcon(String severity) {
    switch (severity) {
      case 'high': return Icons.error_rounded;
      case 'medium': return Icons.warning_rounded;
      default: return Icons.info_rounded;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(complianceProvider);
    final alerts = state.alerts;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Risk Alerts'),
        actions: [
          if (state.unreadAlertCount > 0)
            TextButton(
              onPressed: () => ref.read(complianceProvider.notifier).markAllRead(),
              child: const Text('Mark All Read',
                  style: TextStyle(color: AppColors.primary, fontSize: 13)),
            ),
        ],
      ),
      body: alerts.isEmpty
          ? const EmptyState(
              icon: Icons.shield_outlined,
              title: 'No Alerts',
              message: 'Great job! You have no risk alerts right now. Keep up the good work.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              children: [
                // Summary banner
                AppCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.notifications_active_rounded,
                          color: AppColors.danger, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${state.unreadAlertCount} Unread Alert${state.unreadAlertCount == 1 ? '' : 's'}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: AppColors.textPrimary)),
                        const Text('Review and address these to improve compliance',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    )),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('${alerts.length}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),

                // High severity first
                ...['high', 'medium', 'low'].expand((severity) {
                  final group = alerts.where((a) => a.severity == severity).toList();
                  if (group.isEmpty) return <Widget>[];
                  return [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _severityColor(severity),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          severity == 'high'
                              ? 'High Priority'
                              : severity == 'medium'
                                  ? 'Medium Priority'
                                  : 'Low Priority',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: _severityColor(severity)),
                        ),
                      ]),
                    ),
                    ...group.map((alert) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _AlertDetailCard(
                            alert: alert,
                            color: _severityColor(alert.severity),
                            icon: _severityIcon(alert.severity),
                            timeAgo: _timeAgo(alert.createdAt),
                            onMarkRead: () =>
                                ref.read(complianceProvider.notifier).markAlertRead(alert.id),
                          ),
                        )),
                    const SizedBox(height: 8),
                  ];
                }),
              ],
            ),
    );
  }
}

class _AlertDetailCard extends StatelessWidget {
  final RiskAlert alert;
  final Color color;
  final IconData icon;
  final String timeAgo;
  final VoidCallback onMarkRead;

  const _AlertDetailCard({
    required this.alert,
    required this.color,
    required this.icon,
    required this.timeAgo,
    required this.onMarkRead,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Text(alert.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textPrimary)),
                  ),
                  if (!alert.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: color, shape: BoxShape.circle),
                    ),
                ]),
                const SizedBox(height: 2),
                Text(timeAgo,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted)),
              ],
            )),
          ]),
          const SizedBox(height: 12),
          Text(alert.description,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5)),
          const SizedBox(height: 12),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(alert.severity.toUpperCase(),
                  style: TextStyle(
                      fontSize: 9, fontWeight: FontWeight.w700, color: color)),
            ),
            const Spacer(),
            if (!alert.isRead)
              TextButton(
                onPressed: onMarkRead,
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text('Mark as Read',
                    style: TextStyle(color: AppColors.primary, fontSize: 12)),
              )
            else
              const Text('Read',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontStyle: FontStyle.italic)),
          ]),
        ],
      ),
    );
  }
}
