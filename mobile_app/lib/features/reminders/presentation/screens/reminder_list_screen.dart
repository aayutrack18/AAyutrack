import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/reminders/domain/entities/reminder.dart';
import 'package:aayutrack/features/reminders/presentation/providers/reminder_provider.dart';
import 'package:aayutrack/features/reminders/presentation/screens/add_reminder_screen.dart';
import 'package:aayutrack/features/reminders/presentation/screens/edit_reminder_screen.dart';
import 'package:aayutrack/features/reminders/presentation/screens/notification_settings_screen.dart';

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
        title: const Text('Reminders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.textMuted),
            tooltip: 'Notification Settings',
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NotificationSettingsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.primary),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AddReminderScreen())),
          ),
        ],
      ),
      body: state.isLoading
          ? const LoadingIndicator(message: 'Loading reminders...')
          : state.hasError
              ? ErrorState(
                  message: state.errorMessage!,
                  onRetry: () =>
                      ref.read(reminderProvider.notifier).loadReminders(),
                )
              : state.reminders.isEmpty
                  ? EmptyState(
                      icon: Icons.alarm_outlined,
                      title: 'No Reminders Yet',
                      message:
                          'Add reminders for medicines, appointments, and health measurements.',
                      actionLabel: 'Add Reminder',
                      onAction: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddReminderScreen())),
                    )
                  : _buildList(context, ref, state),
      floatingActionButton: state.reminders.isNotEmpty
          ? FloatingActionButton(
              heroTag: 'reminder_list_fab',
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AddReminderScreen())),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add_rounded, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildList(
      BuildContext context, WidgetRef ref, ReminderState state) {
    final enabled = state.enabledReminders;
    final disabled = state.reminders.where((r) => !r.isEnabled).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        // Summary chips
        Row(children: [
          _SummaryChip(
            label: '${enabled.length} Active',
            color: AppColors.success,
            icon: Icons.alarm_on_rounded,
          ),
          const SizedBox(width: 8),
          _SummaryChip(
            label: '${disabled.length} Paused',
            color: AppColors.textMuted,
            icon: Icons.alarm_off_rounded,
          ),
        ]),
        const SizedBox(height: 16),

        if (enabled.isNotEmpty) ...[
          const SectionHeader(title: 'Active Reminders'),
          const SizedBox(height: 12),
          ...enabled.map((r) => _ReminderCard(
                reminder: r,
                icon: _typeIcon(r.type),
                color: _typeColor(r.type),
              )),
          const SizedBox(height: 8),
        ],

        if (disabled.isNotEmpty) ...[
          const SectionHeader(title: 'Paused Reminders'),
          const SizedBox(height: 12),
          ...disabled.map((r) => _ReminderCard(
                reminder: r,
                icon: _typeIcon(r.type),
                color: _typeColor(r.type),
              )),
        ],
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _SummaryChip(
      {required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color)),
      ]),
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
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        child: Row(children: [
          // Color bar
          Container(
            width: 4,
            height: 64,
            decoration: BoxDecoration(
              color: reminder.isEnabled
                  ? color
                  : color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(reminder.isEnabled ? 0.12 : 0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,
                color: reminder.isEnabled ? color : color.withOpacity(0.4),
                size: 20),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: reminder.isEnabled
                          ? AppColors.textPrimary
                          : AppColors.textMuted),
                ),
                const SizedBox(height: 3),
                Row(children: [
                  Icon(Icons.access_time_rounded,
                      size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(reminder.time,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: reminder.isEnabled
                              ? color
                              : AppColors.textMuted)),
                  if (reminder.repeatDays.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        reminder.isDaily
                            ? 'Every day'
                            : reminder.repeatDays.join(', '),
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textMuted),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ]),
                if (reminder.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      reminder.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textMuted),
                    ),
                  ),
              ],
            ),
          ),
          // Controls
          Column(children: [
            Switch.adaptive(
              value: reminder.isEnabled,
              onChanged: (v) => ref
                  .read(reminderProvider.notifier)
                  .toggleReminder(reminder.id, v),
              activeColor: color,
            ),
            Row(children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          EditReminderScreen(reminder: reminder)),
                ),
                child: const Icon(Icons.edit_outlined,
                    size: 16, color: AppColors.textMuted),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () async {
                  final confirm = await showConfirmationSheet(context,
                    title: 'Delete Reminder',
                    message: 'Delete "${reminder.title}"?',
                    confirmLabel: 'Delete',
                    isDangerous: true,
                  );
                  if (confirm == true) {
                    ref
                        .read(reminderProvider.notifier)
                        .deleteReminder(reminder.id);
                  }
                },
                child: const Icon(Icons.delete_outline,
                    size: 16, color: AppColors.danger),
              ),
            ]),
          ]),
        ]),
      ),
    );
  }
}
