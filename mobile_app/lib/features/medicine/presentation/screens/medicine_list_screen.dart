import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/medicine/domain/entities/medicine.dart';
import 'package:aayutrack/features/medicine/presentation/providers/medicine_provider.dart';
import 'package:aayutrack/features/medicine/presentation/screens/add_medicine_screen.dart';
import 'package:aayutrack/features/medicine/presentation/screens/medicine_detail_screen.dart';

class MedicineListScreen extends ConsumerWidget {
  const MedicineListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Medicines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.primary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
            ),
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
                      title: 'No Medicines Added',
                      message:
                          'Start tracking your medication schedule by adding your first medicine.',
                      actionLabel: 'Add Medicine',
                      onAction: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AddMedicineScreen()),
                      ),
                    )
                  : _buildContent(context, ref, state),
      floatingActionButton: state.medicines.isNotEmpty
          ? FloatingActionButton(
              heroTag: 'medicine_list_fab',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
              ),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add_rounded, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, MedicineState state) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        // Summary row
        Row(children: [
          _SummaryChip(
            label: '${state.activeMedicines.length} Active',
            color: AppColors.success,
            icon: Icons.check_circle_rounded,
          ),
          const SizedBox(width: 8),
          _SummaryChip(
            label: '${state.inactiveMedicines.length} Paused',
            color: AppColors.textMuted,
            icon: Icons.pause_circle_rounded,
          ),
        ]),
        const SizedBox(height: 16),

        if (state.activeMedicines.isNotEmpty) ...[
          const SectionHeader(title: 'Active Medicines'),
          const SizedBox(height: 10),
          ...state.activeMedicines
              .map((m) => _MedicineCard(medicine: m)),
          const SizedBox(height: 8),
        ],

        if (state.inactiveMedicines.isNotEmpty) ...[
          const SectionHeader(title: 'Paused'),
          const SizedBox(height: 10),
          ...state.inactiveMedicines
              .map((m) => _MedicineCard(medicine: m)),
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
                fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }
}

class _MedicineCard extends ConsumerWidget {
  final Medicine medicine;
  const _MedicineCard({required this.medicine});

  Color get _color {
    try {
      return Color(int.parse(medicine.color.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.primary;
    }
  }

  IconData get _formIcon {
    switch (medicine.form.toLowerCase()) {
      case 'capsule': return Icons.medication_rounded;
      case 'syrup': return Icons.local_drink_outlined;
      case 'injection': return Icons.vaccines_outlined;
      case 'drops': return Icons.water_drop_outlined;
      case 'inhaler': return Icons.air_rounded;
      default: return Icons.tablet_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _color;
    final isActive = medicine.isActive;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MedicineDetailScreen(medicine: medicine),
          ),
        ),
        child: Row(children: [
          // Color indicator bar
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: isActive ? color : color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          // Medicine icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(isActive ? 0.12 : 0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_formIcon,
                color: isActive ? color : color.withOpacity(0.4),
                size: 22),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: isActive
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${medicine.dosage} · ${medicine.frequency}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(height: 5),
                if (medicine.scheduledTimes.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    children: medicine.scheduledTimes
                        .take(3)
                        .map((t) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(t,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: color)),
                            ))
                        .toList(),
                  ),
              ],
            ),
          ),
          // Chevron + toggle
          Column(children: [
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted, size: 20),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () => ref
                  .read(medicineProvider.notifier)
                  .toggleActive(medicine.id, !isActive),
              child: Icon(
                isActive
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                size: 20,
                color: isActive ? AppColors.textMuted : AppColors.success,
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
