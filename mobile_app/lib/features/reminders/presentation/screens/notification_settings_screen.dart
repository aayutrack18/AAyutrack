import 'package:flutter/material.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _medicineAlerts = true;
  bool _healthLogReminders = true;
  bool _complianceReports = true;
  bool _appointmentAlerts = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _badgeEnabled = true;
  String _quietStart = '22:00';
  String _quietEnd = '07:00';
  bool _quietHoursEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Notification Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          _buildSection('Notification Types', [
            _ToggleRow(
              icon: Icons.medication_rounded,
              iconColor: AppColors.primary,
              title: 'Medicine Reminders',
              subtitle: 'Get notified for scheduled doses',
              value: _medicineAlerts,
              onChanged: (v) => setState(() => _medicineAlerts = v),
            ),
            const Divider(color: AppColors.border, height: 1),
            _ToggleRow(
              icon: Icons.monitor_heart_rounded,
              iconColor: AppColors.accent,
              title: 'Health Log Reminders',
              subtitle: 'Prompts to log your readings',
              value: _healthLogReminders,
              onChanged: (v) => setState(() => _healthLogReminders = v),
            ),
            const Divider(color: AppColors.border, height: 1),
            _ToggleRow(
              icon: Icons.bar_chart_rounded,
              iconColor: const Color(0xFF7C3AED),
              title: 'Weekly Reports',
              subtitle: 'Compliance summary every week',
              value: _complianceReports,
              onChanged: (v) => setState(() => _complianceReports = v),
            ),
            const Divider(color: AppColors.border, height: 1),
            _ToggleRow(
              icon: Icons.calendar_today_rounded,
              iconColor: const Color(0xFFF59E0B),
              title: 'Appointment Alerts',
              subtitle: 'Reminders for doctor visits',
              value: _appointmentAlerts,
              onChanged: (v) => setState(() => _appointmentAlerts = v),
            ),
          ]),
          const SizedBox(height: 16),

          _buildSection('Alert Style', [
            _ToggleRow(
              icon: Icons.volume_up_rounded,
              iconColor: AppColors.primary,
              title: 'Sound',
              subtitle: 'Play notification sound',
              value: _soundEnabled,
              onChanged: (v) => setState(() => _soundEnabled = v),
            ),
            const Divider(color: AppColors.border, height: 1),
            _ToggleRow(
              icon: Icons.vibration_rounded,
              iconColor: AppColors.textSecondary,
              title: 'Vibration',
              subtitle: 'Vibrate on notification',
              value: _vibrationEnabled,
              onChanged: (v) => setState(() => _vibrationEnabled = v),
            ),
            const Divider(color: AppColors.border, height: 1),
            _ToggleRow(
              icon: Icons.notifications_rounded,
              iconColor: AppColors.danger,
              title: 'Badge Count',
              subtitle: 'Show number badge on app icon',
              value: _badgeEnabled,
              onChanged: (v) => setState(() => _badgeEnabled = v),
            ),
          ]),
          const SizedBox(height: 16),

          _buildSection('Quiet Hours', [
            _ToggleRow(
              icon: Icons.bedtime_rounded,
              iconColor: const Color(0xFF6366F1),
              title: 'Enable Quiet Hours',
              subtitle: 'Silence notifications during this period',
              value: _quietHoursEnabled,
              onChanged: (v) => setState(() => _quietHoursEnabled = v),
            ),
            if (_quietHoursEnabled) ...[
              const Divider(color: AppColors.border, height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(children: [
                  Expanded(
                    child: _TimeSelector(
                      label: 'Start Time',
                      value: _quietStart,
                      onTap: () async {
                        final parts = _quietStart.split(':');
                        final t = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                              hour: int.parse(parts[0]),
                              minute: int.parse(parts[1])),
                        );
                        if (t != null) {
                          setState(() => _quietStart =
                              '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}');
                        }
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('to',
                        style: TextStyle(color: AppColors.textMuted)),
                  ),
                  Expanded(
                    child: _TimeSelector(
                      label: 'End Time',
                      value: _quietEnd,
                      onTap: () async {
                        final parts = _quietEnd.split(':');
                        final t = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                              hour: int.parse(parts[0]),
                              minute: int.parse(parts[1])),
                        );
                        if (t != null) {
                          setState(() => _quietEnd =
                              '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}');
                        }
                      },
                    ),
                  ),
                ]),
              ),
            ],
          ]),
          const SizedBox(height: 24),

          AppButton(
            label: 'Save Settings',
            icon: Icons.save_rounded,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification settings saved!'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.textMuted)),
        const SizedBox(height: 8),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary)),
            Text(subtitle,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textMuted)),
          ]),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ]),
    );
  }
}

class _TimeSelector extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _TimeSelector({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: AppColors.primary)),
        ]),
      ),
    );
  }
}
