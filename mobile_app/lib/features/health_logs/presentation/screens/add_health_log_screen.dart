import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';
import 'package:aayutrack/features/health_logs/presentation/providers/health_log_provider.dart';

class AddHealthLogScreen extends ConsumerStatefulWidget {
  const AddHealthLogScreen({super.key});

  @override
  ConsumerState<AddHealthLogScreen> createState() => _AddHealthLogScreenState();
}

class _AddHealthLogScreenState extends ConsumerState<AddHealthLogScreen> {
  MetricType _selectedType = MetricType.bloodPressure;
  final _primaryCtrl = TextEditingController();
  final _secondaryCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _isLoading = false;

  Color _metricColor(MetricType t) {
    switch (t) {
      case MetricType.bloodPressure:
        return const Color(0xFFDC2626);
      case MetricType.bloodSugar:
        return const Color(0xFFF59E0B);
      case MetricType.heartRate:
        return const Color(0xFFEC4899);
      case MetricType.weight:
        return const Color(0xFF7C3AED);
      case MetricType.oxygen:
        return const Color(0xFF14B8A6);
      case MetricType.temperature:
        return const Color(0xFF6366F1);
      case MetricType.mood:
        return const Color(0xFF16A34A);
    }
  }

  IconData _metricIcon(MetricType t) {
    switch (t) {
      case MetricType.bloodPressure:
        return Icons.bloodtype_rounded;
      case MetricType.bloodSugar:
        return Icons.water_drop_rounded;
      case MetricType.heartRate:
        return Icons.favorite_rounded;
      case MetricType.weight:
        return Icons.monitor_weight_outlined;
      case MetricType.oxygen:
        return Icons.air_rounded;
      case MetricType.temperature:
        return Icons.thermostat_rounded;
      case MetricType.mood:
        return Icons.sentiment_satisfied_rounded;
    }
  }

  @override
  void dispose() {
    _primaryCtrl.dispose();
    _secondaryCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final primaryText = _primaryCtrl.text.trim();
    if (primaryText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a value.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final primary = double.tryParse(primaryText);
    if (primary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid number.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    double? secondary;
    if (_selectedType == MetricType.bloodPressure) {
      final secText = _secondaryCtrl.text.trim();
      secondary = double.tryParse(secText);
      if (secondary == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enter diastolic pressure.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    final log = HealthLog(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      type: _selectedType,
      value: primary,
      secondaryValue: secondary,
      notes: _notesCtrl.text.trim(),
      recordedAt: DateTime.now(),
      source: 'manual',
    );

    await ref.read(healthLogProvider.notifier).addLog(log);

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reading logged successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selColor = _metricColor(_selectedType);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Log Health Reading'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _save,
            child: const Text(
              'Save',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Text(
            'Select Metric',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: MetricType.values.length,
              itemBuilder: (ctx, i) {
                final type = MetricType.values[i];
                final isSelected = _selectedType == type;
                final color = _metricColor(type);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = type;
                      _primaryCtrl.clear();
                      _secondaryCtrl.clear();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 84,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? color : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? color : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(type.icon, style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 4),
                        Text(
                          type.label.split(' ').first,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color:
                                isSelected ? Colors.white : AppColors.textMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _metricIcon(_selectedType),
                        color: selColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedType.label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (_selectedType.unit.isNotEmpty)
                          Text(
                            'in ${_selectedType.unit}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_selectedType == MetricType.bloodPressure) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Systolic (mmHg)',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _primaryCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: selColor,
                              ),
                              decoration: InputDecoration(
                                hintText: '120',
                                hintStyle: TextStyle(
                                  color: selColor.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '/',
                          style: TextStyle(
                            fontSize: 32,
                            color: selColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Diastolic (mmHg)',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _secondaryCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: selColor,
                              ),
                              decoration: InputDecoration(
                                hintText: '80',
                                hintStyle: TextStyle(
                                  color: selColor.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  TextField(
                    controller: _primaryCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: selColor,
                    ),
                    decoration: InputDecoration(
                      hintText: _selectedType == MetricType.mood ? '7' : '0',
                      hintStyle: TextStyle(
                        fontSize: 24,
                        color: selColor.withOpacity(0.3),
                      ),
                      suffixText: _selectedType.unit,
                      suffixStyle: TextStyle(
                        fontSize: 16,
                        color: selColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                _buildNormalRange(),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notes (optional)',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Additional notes',
                  hint: 'e.g. Taken after breakfast, feeling rested',
                  controller: _notesCtrl,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: _isLoading ? 'Saving...' : 'Save Reading',
            icon: Icons.save_rounded,
            onPressed: _isLoading ? null : _save,
            isLoading: _isLoading,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildNormalRange() {
    String range = '';

    switch (_selectedType) {
      case MetricType.bloodPressure:
        range = 'Normal: < 120/80 mmHg';
        break;
      case MetricType.bloodSugar:
        range = 'Fasting: 70–100 mg/dL';
        break;
      case MetricType.heartRate:
        range = 'Normal: 60–100 bpm';
        break;
      case MetricType.oxygen:
        range = 'Normal: 95–100%';
        break;
      case MetricType.temperature:
        range = 'Normal: 36.1–37.2°C';
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: AppColors.accent,
          ),
          const SizedBox(width: 6),
          Text(
            range,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.accent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
