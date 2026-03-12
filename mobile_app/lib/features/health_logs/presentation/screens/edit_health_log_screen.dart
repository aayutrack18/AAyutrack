import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';
import 'package:aayutrack/features/health_logs/presentation/providers/health_log_provider.dart';

class EditHealthLogScreen extends ConsumerStatefulWidget {
  final HealthLog log;
  const EditHealthLogScreen({super.key, required this.log});

  @override
  ConsumerState<EditHealthLogScreen> createState() => _EditHealthLogScreenState();
}

class _EditHealthLogScreenState extends ConsumerState<EditHealthLogScreen> {
  late final TextEditingController _primaryCtrl;
  late final TextEditingController _secondaryCtrl;
  late final TextEditingController _notesCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final log = widget.log;
    _primaryCtrl = TextEditingController(text: log.value.toStringAsFixed(
      log.type == MetricType.weight || log.type == MetricType.temperature ? 1 : 0,
    ));
    _secondaryCtrl = TextEditingController(
        text: log.secondaryValue != null ? log.secondaryValue!.toInt().toString() : '');
    _notesCtrl = TextEditingController(text: log.notes);
  }

  @override
  void dispose() {
    _primaryCtrl.dispose();
    _secondaryCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Color get _metricColor {
    switch (widget.log.type) {
      case MetricType.bloodPressure: return const Color(0xFFDC2626);
      case MetricType.bloodSugar:   return const Color(0xFFF59E0B);
      case MetricType.heartRate:    return const Color(0xFFEC4899);
      case MetricType.weight:       return const Color(0xFF7C3AED);
      case MetricType.oxygen:       return const Color(0xFF14B8A6);
      case MetricType.temperature:  return const Color(0xFF6366F1);
      case MetricType.mood:         return const Color(0xFF16A34A);
    }
  }

  String get _normalRange {
    switch (widget.log.type) {
      case MetricType.bloodPressure: return 'Normal: 90–120 / 60–80 mmHg';
      case MetricType.bloodSugar:    return 'Fasting normal: 70–100 mg/dL';
      case MetricType.heartRate:     return 'Normal resting: 60–100 bpm';
      case MetricType.weight:        return 'Enter in kilograms (kg)';
      case MetricType.oxygen:        return 'Normal: 95–100%';
      case MetricType.temperature:   return 'Normal: 36.1–37.2°C';
      case MetricType.mood:          return 'Scale: 1 (very low) to 10 (excellent)';
    }
  }

  Future<void> _save() async {
    final primaryText = _primaryCtrl.text.trim();
    if (primaryText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a value'),
        backgroundColor: AppColors.danger,
      ));
      return;
    }

    final primaryVal = double.tryParse(primaryText);
    if (primaryVal == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a valid number'),
        backgroundColor: AppColors.danger,
      ));
      return;
    }

    double? secondaryVal;
    if (widget.log.type == MetricType.bloodPressure) {
      secondaryVal = double.tryParse(_secondaryCtrl.text.trim());
      if (secondaryVal == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter the diastolic (lower) value'),
          backgroundColor: AppColors.danger,
        ));
        return;
      }
    }

    setState(() => _isLoading = true);

    final updated = widget.log.copyWith(
      value: primaryVal,
      secondaryValue: secondaryVal,
      notes: _notesCtrl.text.trim(),
    );

    await ref.read(healthLogProvider.notifier).updateLog(updated);

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text('${widget.log.type.label} updated'),
          ]),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.log.type;
    final color = _metricColor;
    final isBP = type == MetricType.bloodPressure;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Edit ${type.label}'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _save,
            child: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.primary),
                  )
                : const Text('Save',
                    style: TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metric header
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(type.icon, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(type.label,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(_normalRange,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),

            // Value input(s)
            if (isBP) ...[
              const Text('Reading',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: AppTextField(
                    controller: _primaryCtrl,
                    label: 'Systolic (upper)',
                    hint: '120',
                    keyboardType: TextInputType.number,
                    suffixIcon: const Padding(padding: EdgeInsets.only(right: 12), child: Align(widthFactor: 0.5, child: Text('mmHg', style: TextStyle(color: AppColors.textMuted, fontSize: 12)))),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('/', style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w300,
                      color: AppColors.textMuted)),
                ),
                Expanded(
                  child: AppTextField(
                    controller: _secondaryCtrl,
                    label: 'Diastolic (lower)',
                    hint: '80',
                    keyboardType: TextInputType.number,
                    suffixIcon: const Padding(padding: EdgeInsets.only(right: 12), child: Align(widthFactor: 0.5, child: Text('mmHg', style: TextStyle(color: AppColors.textMuted, fontSize: 12)))),
                  ),
                ),
              ]),
            ] else ...[
              AppTextField(
                controller: _primaryCtrl,
                label: '${type.label} Value',
                hint: type == MetricType.mood ? '1–10' : 'Enter value',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                suffixIcon: type.unit.isNotEmpty ? Padding(padding: const EdgeInsets.only(right: 12), child: Align(widthFactor: 0.5, child: Text(type.unit, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)))) : null,
              ),
            ],
            const SizedBox(height: 16),

            // Notes
            AppTextField(
              controller: _notesCtrl,
              label: 'Notes (optional)',
              hint: 'Any additional notes…',
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            AppButton(
              label: _isLoading ? 'Saving…' : 'Save Changes',
              icon: Icons.check_rounded,
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}
