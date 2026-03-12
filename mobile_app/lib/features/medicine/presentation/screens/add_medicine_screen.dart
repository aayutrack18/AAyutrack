import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/medicine/domain/entities/medicine.dart';
import 'package:aayutrack/features/medicine/presentation/providers/medicine_provider.dart';

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
    'Once Daily','Twice Daily','Three Times Daily',
    'Every 6 Hours','Weekly','As Needed',
  ];

  final _forms = [
    'Tablet','Capsule','Syrup','Injection',
    'Drops','Inhaler','Patch','Cream',
  ];

  final _colorOptions = [
    '#1D4ED8','#14B8A6','#7C3AED',
    '#F59E0B','#DC2626','#16A34A',
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
          hour: int.tryParse(parts[0]) ?? 8,
          minute: int.tryParse(parts[1]) ?? 0,
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

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _times[index],
    );
    if (picked != null) setState(() => _times[index] = picked);
  }

  void _addTime() => setState(() => _times.add(const TimeOfDay(hour: 12, minute: 0)));

  void _removeTime(int index) {
    if (_times.length > 1) setState(() => _times.removeAt(index));
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Medicine updated!' : 'Medicine added!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selColor = Color(
        int.parse(_selectedColor.replaceFirst('#', '0xFF')));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Medicine' : 'Add Medicine'),
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
            // Header color preview
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: selColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Basic Info',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.md),
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
                  Row(children: [
                    Expanded(
                      child: AppDropdown<String>(
                        label: 'Form',
                        value: _form,
                        items: _forms
                            .map((f) =>
                                DropdownMenuItem(value: f, child: Text(f)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _form = v ?? _form),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppDropdown<String>(
                        label: 'Frequency',
                        value: _frequency,
                        items: _frequencies
                            .map((f) =>
                                DropdownMenuItem(value: f, child: Text(f)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _frequency = v ?? _frequency),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Schedule Times',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.md),
                  ..._times.asMap().entries.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _pickTime(e.key),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.md),
                                  border:
                                      Border.all(color: AppColors.border),
                                ),
                                child: Row(children: [
                                  const Icon(Icons.access_time_rounded,
                                      size: 18, color: AppColors.textMuted),
                                  const SizedBox(width: 10),
                                  Text(
                                    e.value.format(context),
                                    style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline,
                                color: AppColors.danger),
                            onPressed: () => _removeTime(e.key),
                          ),
                        ]),
                      )),
                  TextButton.icon(
                    onPressed: _addTime,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add Time'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Instructions',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Special Instructions (optional)',
                    hint: 'e.g. Take with food, avoid alcohol',
                    controller: _instructionsCtrl,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Color Label',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text('Choose a color to identify this medicine',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 14),
                  Row(
                    children: _colorOptions.map((c) {
                      final color =
                          Color(int.parse(c.replaceFirst('#', '0xFF')));
                      final isSelected = _selectedColor == c;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = c),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 38,
                          height: 38,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.textPrimary,
                                    width: 3)
                                : Border.all(
                                    color: Colors.transparent, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.4),
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
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: _isEditing ? 'Save Changes' : 'Add Medicine',
              onPressed: _isLoading ? null : _save,
              isLoading: _isLoading,
              icon: _isEditing ? Icons.save_rounded : Icons.add_rounded,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
