import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/reminder.dart';
import '../providers/reminder_provider.dart';

class AddReminderScreen extends ConsumerStatefulWidget {
  final Reminder? existing;

  const AddReminderScreen({super.key, this.existing});

  @override
  ConsumerState<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends ConsumerState<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  List<String> _selectedDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  String _type = 'medicine';
  bool _isLoading = false;

  final _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final _types = ['medicine', 'appointment', 'measurement', 'custom'];

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _descCtrl = TextEditingController(text: e?.description ?? '');
    if (e != null) {
      final parts = e.time.split(':');
      _time = TimeOfDay(
          hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      _selectedDays = List.from(e.repeatDays);
      _type = e.type;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final h = _time.hour.toString().padLeft(2, '0');
    final m = _time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final reminder = Reminder(
      id: _isEditing
          ? widget.existing!.id
          : 'rem_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      time: _formattedTime,
      repeatDays: _selectedDays,
      isEnabled: _isEditing ? widget.existing!.isEnabled : true,
      type: _type,
      createdAt: _isEditing ? widget.existing!.createdAt : DateTime.now(),
    );

    final notifier = ref.read(reminderProvider.notifier);
    if (_isEditing) {
      await notifier.updateReminder(reminder);
    } else {
      await notifier.addReminder(reminder);
    }

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          _isEditing ? 'Edit Reminder' : 'Add Reminder',
          style: const TextStyle(
              fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppTextField(
              label: 'Title',
              hint: 'e.g. Morning Medicines',
              controller: _titleCtrl,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Description (optional)',
              hint: 'Additional notes',
              controller: _descCtrl,
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.md),
            // Time picker
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Time',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            color: AppColors.primary, size: 22),
                        const SizedBox(width: 12),
                        Text(
                          _time.format(context),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        const Text('Change',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDaySelector(),
            const SizedBox(height: AppSpacing.md),
            AppDropdown<String>(
              label: 'Type',
              value: _type,
              items: _types
                  .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(
                            t[0].toUpperCase() + t.substring(1)),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _type = v ?? _type),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: _isEditing ? 'Save Changes' : 'Add Reminder',
              onPressed: _save,
              isLoading: _isLoading,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Repeat Days',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _days.map((day) {
            final isSelected = _selectedDays.contains(day);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedDays.remove(day);
                  } else {
                    _selectedDays.add(day);
                  }
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Center(
                  child: Text(
                    day.substring(0, 1),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color:
                          isSelected ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            TextButton(
              onPressed: () =>
                  setState(() => _selectedDays = List.from(_days)),
              child: const Text('All'),
            ),
            TextButton(
              onPressed: () => setState(() => _selectedDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']),
              child: const Text('Weekdays'),
            ),
            TextButton(
              onPressed: () => setState(() => _selectedDays = ['Sat', 'Sun']),
              child: const Text('Weekend'),
            ),
          ],
        ),
      ],
    );
  }
}
