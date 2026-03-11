import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/medicine.dart';
import '../providers/medicine_provider.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  final Medicine? existing;

  const AddMedicineScreen({super.key, this.existing});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _dosageCtrl;
  late final TextEditingController _instructionsCtrl;
  String _frequency = 'Once Daily';
  String _form = 'Tablet';
  List<TimeOfDay> _times = [const TimeOfDay(hour: 8, minute: 0)];
  bool _isLoading = false;
  String _selectedColor = '#1D4ED8';

  final _frequencies = [
    'Once Daily',
    'Twice Daily',
    'Three Times Daily',
    'Every 6 Hours',
    'Weekly',
    'As Needed',
  ];

  final _forms = [
    'Tablet',
    'Capsule',
    'Syrup',
    'Injection',
    'Drops',
    'Inhaler',
    'Patch',
    'Cream',
  ];

  final _colors = [
    '#1D4ED8',
    '#14B8A6',
    '#7C3AED',
    '#F59E0B',
    '#DC2626',
    '#16A34A',
  ];

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _dosageCtrl = TextEditingController(text: e?.dosage ?? '');
    _instructionsCtrl = TextEditingController(text: e?.instructions ?? '');
    if (e != null) {
      _frequency = e.frequency;
      _form = e.form;
      _selectedColor = e.color;
      _times = e.scheduledTimes.map((t) {
        final parts = t.split(':');
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }).toList();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    _instructionsCtrl.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _pickTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _times[index],
    );
    if (picked != null) {
      setState(() => _times[index] = picked);
    }
  }

  void _addTime() {
    setState(() => _times.add(const TimeOfDay(hour: 12, minute: 0)));
  }

  void _removeTime(int index) {
    if (_times.length > 1) {
      setState(() => _times.removeAt(index));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final medicine = Medicine(
      id: _isEditing
          ? widget.existing!.id
          : 'med_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      dosage: _dosageCtrl.text.trim(),
      frequency: _frequency,
      form: _form,
      instructions: _instructionsCtrl.text.trim(),
      scheduledTimes: _times.map(_formatTime).toList(),
      startDate: _isEditing ? widget.existing!.startDate : DateTime.now(),
      isActive: _isEditing ? widget.existing!.isActive : true,
      color: _selectedColor,
      createdAt: _isEditing ? widget.existing!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final notifier = ref.read(medicineProvider.notifier);
    if (_isEditing) {
      await notifier.updateMedicine(medicine);
    } else {
      await notifier.addMedicine(medicine);
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
          _isEditing ? 'Edit Medicine' : 'Add Medicine',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppTextField(
              label: 'Medicine Name',
              hint: 'e.g. Metformin',
              controller: _nameCtrl,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Dosage',
              hint: 'e.g. 500mg',
              controller: _dosageCtrl,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Dosage is required' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            AppDropdown<String>(
              label: 'Form',
              value: _form,
              items: _forms
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (v) => setState(() => _form = v ?? _form),
            ),
            const SizedBox(height: AppSpacing.md),
            AppDropdown<String>(
              label: 'Frequency',
              value: _frequency,
              items: _frequencies
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (v) => setState(() => _frequency = v ?? _frequency),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildScheduleSection(),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Instructions (optional)',
              hint: 'e.g. Take with food',
              controller: _instructionsCtrl,
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildColorPicker(),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: _isEditing ? 'Save Changes' : 'Add Medicine',
              onPressed: _save,
              isLoading: _isLoading,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Schedule Times',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ..._times.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(e.key),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_rounded,
                                size: 18, color: AppColors.textMuted),
                            const SizedBox(width: 10),
                            Text(
                              e.value.format(context),
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: AppColors.danger),
                    onPressed: () => _removeTime(e.key),
                  ),
                ],
              ),
            )),
        TextButton.icon(
          onPressed: _addTime,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Add Time'),
        ),
      ],
    );
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color Label',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: _colors.map((c) {
            final color = Color(int.parse(c.replaceFirst('#', '0xFF')));
            final isSelected = _selectedColor == c;
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = c),
              child: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: AppColors.textPrimary, width: 2.5)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: isSelected
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 18)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
