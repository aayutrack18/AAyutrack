import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/medicine.dart';
import '../providers/medicine_provider.dart';

class MedicineListScreen extends ConsumerWidget {
  const MedicineListScreen({super.key});

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.primary;
    }
  }

  IconData _formIcon(String form) {
    switch (form.toLowerCase()) {
      case 'capsule':
        return Icons.medication_rounded;
      case 'syrup':
        return Icons.local_drink_outlined;
      case 'injection':
        return Icons.vaccines_outlined;
      case 'drops':
        return Icons.water_drop_outlined;
      default:
        return Icons.tablet_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Medicines',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.primary),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.addMedicine),
          ),
        ],
      ),
      body: state.isLoading
          ? const LoadingIndicator(message: 'Loading medicines...')
          : state.hasError
              ? ErrorState(
                  message: state.errorMessage!,
                  onRetry: () =>
                      ref.read(medicineProvider.notifier).loadMedicines(),
                )
              : state.medicines.isEmpty
                  ? EmptyState(
                      icon: Icons.medication_outlined,
                      title: 'No Medicines Yet',
                      message:
                          'Add your prescribed medicines to track your schedule and compliance.',
                      actionLabel: 'Add Medicine',
                      onAction: () =>
                          Navigator.pushNamed(context, AppRoutes.addMedicine),
                    )
                  : _MedicineList(
                      state: state,
                      parseColor: _parseColor,
                      formIcon: _formIcon,
                    ),
      floatingActionButton: state.medicines.isNotEmpty
          ? FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.addMedicine),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add_rounded, color: Colors.white),
            )
          : null,
    );
  }
}

class _MedicineList extends ConsumerWidget {
  final MedicineState state;
  final Color Function(String) parseColor;
  final IconData Function(String) formIcon;

  const _MedicineList({
    required this.state,
    required this.parseColor,
    required this.formIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        if (state.activeMedicines.isNotEmpty) ...[
          const SectionHeader(title: 'Active Medicines'),
          const SizedBox(height: 12),
          ...state.activeMedicines
              .map((m) => _MedicineCard(
                    medicine: m,
                    color: parseColor(m.color),
                    icon: formIcon(m.form),
                  ))
              .toList(),
          const SizedBox(height: 8),
        ],
        if (state.inactiveMedicines.isNotEmpty) ...[
          const SectionHeader(title: 'Inactive Medicines'),
          const SizedBox(height: 12),
          ...state.inactiveMedicines
              .map((m) => _MedicineCard(
                    medicine: m,
                    color: parseColor(m.color),
                    icon: formIcon(m.form),
                  ))
              .toList(),
        ],
      ],
    );
  }
}

class _MedicineCard extends ConsumerWidget {
  final Medicine medicine;
  final Color color;
  final IconData icon;

  const _MedicineCard({
    required this.medicine,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.medicineDetail,
          arguments: medicine,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(medicine.isActive ? 0.12 : 0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: medicine.isActive
                    ? color
                    : color.withOpacity(0.4),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          medicine.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: medicine.isActive
                                    ? AppColors.textPrimary
                                    : AppColors.textMuted,
                              ),
                        ),
                      ),
                      StatusChip(
                        label: medicine.isActive ? 'Active' : 'Paused',
                        color: medicine.isActive
                            ? AppColors.success
                            : AppColors.textMuted,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${medicine.dosage} · ${medicine.frequency}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: medicine.scheduledTimes
                        .map((t) => Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(6),
                                  border:
                                      Border.all(color: AppColors.border),
                                ),
                                child: Text(
                                  t,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
