import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/reminders/domain/entities/reminder.dart';
import 'package:aayutrack/features/reminders/presentation/providers/reminder_provider.dart';

class EditReminderScreen extends ConsumerStatefulWidget {
  final Reminder reminder;
  const EditReminderScreen({super.key, required this.reminder});

  @override
  ConsumerState<EditReminderScreen> createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends ConsumerState<EditReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late TimeOfDay _time;
  late String _type;
  late List<String> _selectedDays;
  bool _isLoading = false;

  final _types = [
    {'value': 'medicine', 'label': 'Medicine', 'icon': Icons.medication_rounded},
    {'value': 'appointment', 'label': 'Appointment', 'icon': Icons.calendar_today_rounded},
    {'value': 'measurement', 'label': 'Measurement', 'icon': Icons.monitor_heart_rounded},
    {'value': 'custom', 'label': 'Custom', 'icon': Icons.alarm_rounded},
  ];

  final _allDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.reminder.title);
    _descCtrl = TextEditingController(text: widget.reminder.description);
    final parts = widget.reminder.time.split(':');
    _time = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 8,
      minute: int.tryParse(parts[1]) ?? 0,
    );
    _type = widget.reminder.type;
    _selectedDays = List.from(widget.reminder.repeatDays);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one day.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final updated = widget.reminder.copyWith(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      time: _formatTime(_time),
      repeatDays: _selectedDays,
      type: _type,
    );

    await ref.read(reminderProvider.notifier).updateReminder(updated);

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminder updated!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selColor = _typeColor(_type);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Reminder'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _save,
            child: const Text('Save',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Reminder Type',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  Row(
                    children: _types.map((t) {
                      final isSelected = _type == t['value'];
                      final color = _typeColor(t['value'] as String);
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _type = t['value'] as String),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color.withOpacity(0.12)
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isSelected ? color : AppColors.border,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Column(children: [
                              Icon(t['icon'] as IconData,
                                  color: isSelected
                                      ? color
                                      : AppColors.textMuted,
                                  size: 20),
                              const SizedBox(height: 4),
                              Text(t['label'] as String,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? color
                                          : AppColors.textMuted)),
                            ]),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Details',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Reminder Title',
                    hint: 'e.g. Morning Medicine',
                    controller: _titleCtrl,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Title is required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Description (optional)',
                    hint: 'e.g. Take with water after food',
                    controller: _descCtrl,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Time',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _pickTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: selColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border:
                            Border.all(color: selColor.withOpacity(0.3)),
                      ),
                      child: Row(children: [
                        Icon(Icons.access_time_rounded,
                            color: selColor, size: 22),
                        const SizedBox(width: 12),
                        Text(_time.format(context),
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: selColor)),
                        const Spacer(),
                        Text('Tap to change',
                            style: TextStyle(
                                fontSize: 12,
                                color: selColor.withOpacity(0.7))),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Repeat Days',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.textPrimary)),
                      TextButton(
                        onPressed: () => setState(() {
                          if (_selectedDays.length == 7) {
                            _selectedDays = [];
                          } else {
                            _selectedDays = List.from(_allDays);
                          }
                        }),
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap),
                        child: Text(
                          _selectedDays.length == 7
                              ? 'Clear All'
                              : 'Select All',
                          style: const TextStyle(
                              color: AppColors.primary, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: _allDays.map((day) {
                      final isSelected = _selectedDays.contains(day);
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            if (isSelected) {
                              _selectedDays.remove(day);
                            } else {
                              _selectedDays.add(day);
                            }
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? selColor : AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: isSelected
                                      ? selColor
                                      : AppColors.border),
                            ),
                            child: Text(
                              day.substring(0, 1),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textMuted),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Save Changes',
              icon: Icons.save_rounded,
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _save,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
