import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/reminder.dart';
import '../providers/reminder_provider.dart';
import 'add_reminder_screen.dart';

class ReminderListScreen extends ConsumerWidget {
  const ReminderListScreen({super.key});

  IconData _typeIcon(String type) {
    switch (type) {
      case 'medicine':
        return Icons.medication_rounded;
      case 'appointment':
        return Icons.calendar_today_rounded;
      case 'measurement':
        return Icons.monitor_heart_rounded;
      default:
        return Icons.alarm_rounded;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'medicine':
        return AppColors.primary;
      case 'appointment':
        return const Color(0xFF7C3AED);
      case 'measurement':
        return AppColors.accent;
      default:
        return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reminderProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Reminders',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.settings_outlined, color: AppColors.textMuted),
            onPressed: () => Navigator.pushNamed(
                context, AppRoutes.notificationSettings),
          ),
        ],
      ),
      body: state.isLoading
          ? const LoadingIndicator(message: 'Loading reminders...')
          : state.reminders.isEmpty
              ? EmptyState(
                  icon: Icons.alarm_outlined,
                  title: 'No Reminders',
                  message:
                      'Set up reminders for your medicines, appointments, and health measurements.',
                  actionLabel: 'Add Reminder',
                  onAction: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddReminderScreen()),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    ...state.reminders.map((r) => _ReminderCard(
                          reminder: r,
                          icon: _typeIcon(r.type),
                          color: _typeColor(r.type),
                        )),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddReminderScreen()),
        ),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}

class _ReminderCard extends ConsumerWidget {
  final Reminder reminder;
  final IconData icon;
  final Color color;

  const _ReminderCard({
    required this.reminder,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(reminder.isEnabled ? 0.12 : 0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: reminder.isEnabled ? color : color.withOpacity(0.35),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: reminder.isEnabled
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    reminder.time,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: reminder.isEnabled ? color : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reminder.isDaily
                        ? 'Every day'
                        : reminder.repeatDays.join(', '),
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Switch.adaptive(
                  value: reminder.isEnabled,
                  onChanged: (v) => ref
                      .read(reminderProvider.notifier)
                      .toggleReminder(reminder.id, v),
                  activeColor: color,
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded,
                      size: 18, color: AppColors.textMuted),
                  onSelected: (v) async {
                    if (v == 'edit') {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddReminderScreen(existing: reminder),
                        ),
                      );
                    } else if (v == 'delete') {
                      final confirm = await showConfirmationSheet(
                        context,
                        title: 'Delete Reminder',
                        message:
                            'Delete "${reminder.title}"?',
                        confirmLabel: 'Delete',
                        isDangerous: true,
                      );
                      if (confirm == true) {
                        ref
                            .read(reminderProvider.notifier)
                            .deleteReminder(reminder.id);
                      }
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
