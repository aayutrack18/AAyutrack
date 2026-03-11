import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/medicine.dart';
import '../providers/medicine_provider.dart';
import 'add_medicine_screen.dart';

class MedicineDetailScreen extends ConsumerWidget {
  final Medicine medicine;

  const MedicineDetailScreen({super.key, required this.medicine});

  Color get _color {
    try {
      return Color(
          int.parse(medicine.color.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: _color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddMedicineScreen(existing: medicine),
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                onSelected: (v) async {
                  if (v == 'delete') {
                    final confirm = await showConfirmationSheet(
                      context,
                      title: 'Delete Medicine',
                      message:
                          'Are you sure you want to delete ${medicine.name}?',
                      confirmLabel: 'Delete',
                      isDangerous: true,
                    );
                    if (confirm == true && context.mounted) {
                      await ref
                          .read(medicineProvider.notifier)
                          .deleteMedicine(medicine.id);
                      if (context.mounted) Navigator.pop(context);
                    }
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_color, _color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 80, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        medicine.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${medicine.dosage} · ${medicine.form}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.repeat_rounded,
                          label: 'Frequency',
                          value: medicine.frequency,
                          color: _color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoTile(
                          icon: medicine.isActive
                              ? Icons.check_circle_rounded
                              : Icons.pause_circle_rounded,
                          label: 'Status',
                          value: medicine.isActive ? 'Active' : 'Paused',
                          color: medicine.isActive
                              ? AppColors.success
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Schedule',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: medicine.scheduledTimes
                              .map((t) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _color.withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      border: Border.all(
                                          color:
                                              _color.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.access_time_rounded,
                                            size: 14, color: _color),
                                        const SizedBox(width: 6),
                                        Text(
                                          t,
                                          style: TextStyle(
                                            color: _color,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  if (medicine.instructions.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Instructions',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            medicine.instructions,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dates',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _DateRow(
                          label: 'Start Date',
                          date: medicine.startDate,
                        ),
                        if (medicine.endDate != null) ...[
                          const Divider(height: 16),
                          _DateRow(
                            label: 'End Date',
                            date: medicine.endDate!,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: medicine.isActive
                        ? 'Pause Medicine'
                        : 'Resume Medicine',
                    onPressed: () => ref
                        .read(medicineProvider.notifier)
                        .toggleActive(medicine.id, !medicine.isActive),
                    backgroundColor: medicine.isActive
                        ? AppColors.textMuted
                        : AppColors.success,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          Text(
            label,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final String label;
  final DateTime date;

  const _DateRow({required this.label, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
        Text(
          '${date.day}/${date.month}/${date.year}',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
