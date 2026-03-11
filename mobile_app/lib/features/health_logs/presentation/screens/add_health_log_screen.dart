import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/health_log.dart';
import '../providers/health_log_provider.dart';

class AddHealthLogScreen extends ConsumerStatefulWidget {
  final MetricType? initialType;

  const AddHealthLogScreen({super.key, this.initialType});

  @override
  ConsumerState<AddHealthLogScreen> createState() => _AddHealthLogScreenState();
}

class _AddHealthLogScreenState extends ConsumerState<AddHealthLogScreen> {
  MetricType _selectedType = MetricType.bloodPressure;
  final _valueCtrl = TextEditingController();
  final _secondaryCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null) {
      _selectedType = widget.initialType!;
    }
  }

  @override
  void dispose() {
    _valueCtrl.dispose();
    _secondaryCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  bool get _needsSecondaryValue =>
      _selectedType == MetricType.bloodPressure;

  String get _valuePlaceholder {
    switch (_selectedType) {
      case MetricType.bloodPressure: return 'e.g. 120 (systolic)';
      case MetricType.bloodSugar: return 'e.g. 96';
      case MetricType.heartRate: return 'e.g. 72';
      case MetricType.weight: return 'e.g. 72.5';
      case MetricType.oxygen: return 'e.g. 98';
      case MetricType.temperature: return 'e.g. 36.6';
      case MetricType.mood: return '1–5 (1=bad, 5=great)';
    }
  }

  Future<void> _save() async {
    final valueText = _valueCtrl.text.trim();
    if (valueText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a value')),
      );
      return;
    }

    final value = double.tryParse(valueText);
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid number')),
      );
      return;
    }

    double? secondary;
    if (_needsSecondaryValue) {
      secondary = double.tryParse(_secondaryCtrl.text.trim());
    }

    setState(() => _isLoading = true);

    final log = HealthLog(
      id: 'hl_${DateTime.now().millisecondsSinceEpoch}',
      type: _selectedType,
      value: value,
      secondaryValue: secondary,
      notes: _notesCtrl.text.trim(),
      recordedAt: DateTime.now(),
      source: 'manual',
    );

    await ref.read(healthLogProvider.notifier).addLog(log);

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
        title: const Text(
          'Log Reading',
          style: TextStyle(
              fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Text(
            'Metric Type',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          _buildTypeSelector(),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: _needsSecondaryValue
                ? 'Systolic (${MetricType.bloodPressure.unit})'
                : '${_selectedType.label} (${_selectedType.unit})',
            hint: _valuePlaceholder,
            controller: _valueCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
          ),
          if (_needsSecondaryValue) ...[
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Diastolic (${MetricType.bloodPressure.unit})',
              hint: 'e.g. 80',
              controller: _secondaryCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Notes (optional)',
            hint: 'e.g. Fasting, after exercise...',
            controller: _notesCtrl,
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Save Reading',
            onPressed: _save,
            isLoading: _isLoading,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: MetricType.values.map((type) {
        final isSelected = _selectedType == type;
        return GestureDetector(
          onTap: () => setState(() {
            _selectedType = type;
            _valueCtrl.clear();
            _secondaryCtrl.clear();
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  type.icon,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 6),
                Text(
                  type.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color:
                        isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
