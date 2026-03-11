import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../providers/compliance_provider.dart';

class RiskAlertsScreen extends ConsumerWidget {
  const RiskAlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(complianceProvider);
    final notifier = ref.read(complianceProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Risk Alerts',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        actions: [
          if (state.unreadAlertCount > 0)
            TextButton(
              onPressed: notifier.markAllRead,
              child: const Text('Mark all read',
                  style: TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: state.alerts.isEmpty
          ? const EmptyState(
              icon: Icons.check_circle_rounded,
              title: 'No Alerts',
              message: 'You are on track! No risk alerts at the moment.',
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              itemCount: state.alerts.length,
              itemBuilder: (_, i) {
                final alert = state.alerts[i];
                final color = _severityColor(alert.severity);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    onTap: () => notifier.markAlertRead(alert.id),
                    color: alert.isRead ? null : color.withOpacity(0.03),
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
                              child: Icon(
                                _severityIcon(alert.severity),
                                color: color,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    alert.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary),
                                  ),
                                  Text(
                                    _timeAgo(alert.createdAt),
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                StatusChip(
                                  label: alert.severity.toUpperCase(),
                                  color: color,
                                ),
                                if (!alert.isRead) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          alert.description,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.5,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _severityColor(String severity) {
    switch (severity) {
      case 'high': return AppColors.danger;
      case 'medium': return const Color(0xFFF59E0B);
      default: return AppColors.accent;
    }
  }

  IconData _severityIcon(String severity) {
    switch (severity) {
      case 'high': return Icons.warning_rounded;
      case 'medium': return Icons.info_rounded;
      default: return Icons.lightbulb_outline_rounded;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
