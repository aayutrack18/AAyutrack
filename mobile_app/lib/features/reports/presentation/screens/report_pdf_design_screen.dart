import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/core/constants/app_constants.dart';
import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/compliance/presentation/providers/compliance_provider.dart';
import 'package:aayutrack/features/medicine/presentation/providers/medicine_provider.dart';
import 'package:aayutrack/features/profile/presentation/providers/profile_provider.dart';
import 'package:aayutrack/features/reports/presentation/providers/reports_provider.dart';

// ─── COLOR SCHEME MODEL ───────────────────────────────────────────────────────

class _PdfColorScheme {
  final String id;
  final String label;
  final Color primary;
  final Color accent;

  const _PdfColorScheme({
    required this.id,
    required this.label,
    required this.primary,
    required this.accent,
  });
}

const _colorSchemes = [
  _PdfColorScheme(
      id: 'blue',
      label: 'Ocean Blue',
      primary: Color(0xFF1D4ED8),
      accent: Color(0xFF1E40AF)),
  _PdfColorScheme(
      id: 'teal',
      label: 'Teal Health',
      primary: Color(0xFF0D9488),
      accent: Color(0xFF0F766E)),
  _PdfColorScheme(
      id: 'slate',
      label: 'Slate Pro',
      primary: Color(0xFF334155),
      accent: Color(0xFF1E293B)),
  _PdfColorScheme(
      id: 'violet',
      label: 'Violet Care',
      primary: Color(0xFF7C3AED),
      accent: Color(0xFF6D28D9)),
];

class ReportPdfDesignScreen extends ConsumerStatefulWidget {
  const ReportPdfDesignScreen({super.key});

  @override
  ConsumerState<ReportPdfDesignScreen> createState() =>
      _ReportPdfDesignScreenState();
}

class _ReportPdfDesignScreenState extends ConsumerState<ReportPdfDesignScreen> {
  late TextEditingController _doctorNameController;
  late TextEditingController _doctorNoteController;

  @override
  void initState() {
    super.initState();
    final design = ref.read(reportsProvider).pdfDesign;
    _doctorNameController = TextEditingController(text: design.doctorName);
    _doctorNoteController = TextEditingController(text: design.doctorNote);
  }

  @override
  void dispose() {
    _doctorNameController.dispose();
    _doctorNoteController.dispose();
    super.dispose();
  }

  void _saveDesignField() {
    final design = ref.read(reportsProvider).pdfDesign;
    ref.read(reportsProvider.notifier).updatePdfDesign(
          design.copyWith(
            doctorName: _doctorNameController.text.trim(),
            doctorNote: _doctorNoteController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final reportsState = ref.watch(reportsProvider);
    final design = reportsState.pdfDesign;
    final compliance = ref.watch(complianceProvider);
    final medicines = ref.watch(medicineProvider);
    final profileState = ref.watch(profileProvider);
    final profile = profileState.profile;

    final selectedScheme =
        _colorSchemes.firstWhere((c) => c.id == design.colorSchemeId,
            orElse: () => _colorSchemes.first);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('PDF Design'),
        actions: [
          TextButton(
            onPressed: reportsState.isExporting
                ? null
                : () async {
                    _saveDesignField();
                    await ref.read(reportsProvider.notifier).generateReport();
                    if (context.mounted) {
                      _showSuccessSheet(context);
                    }
                  },
            child: const Text(
              'Export',
              style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          // ── Live preview card ────────────────────────────────────────────
          const SectionHeader(title: 'Preview'),
          const SizedBox(height: 10),
          _LivePreviewCard(
            scheme: selectedScheme,
            patientName: profile?.fullName ?? 'Patient Name',
            bloodGroup: profile?.bloodGroup ?? '—',
            compliance: compliance,
            medicines: medicines,
            design: design,
          ),
          const SizedBox(height: 24),

          // ── Colour scheme picker ─────────────────────────────────────────
          const SectionHeader(title: 'Colour Scheme'),
          const SizedBox(height: 10),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _colorSchemes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final scheme = _colorSchemes[i];
                final isSelected = design.colorSchemeId == scheme.id;
                return GestureDetector(
                  onTap: () => ref
                      .read(reportsProvider.notifier)
                      .updatePdfDesign(
                          design.copyWith(colorSchemeId: scheme.id)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: isSelected
                            ? scheme.primary
                            : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: scheme.primary.withOpacity(0.18),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4))
                            ]
                          : [],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md - 1),
                      child: Column(children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [scheme.primary, scheme.accent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: isSelected
                                ? const Center(
                                    child: Icon(Icons.check_circle,
                                        color: Colors.white, size: 20))
                                : null,
                          ),
                        ),
                        Container(
                          color: AppColors.surface,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            scheme.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? scheme.primary
                                  : AppColors.textMuted,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // ── Layout options ───────────────────────────────────────────────
          const SectionHeader(title: 'Layout Options'),
          const SizedBox(height: 10),
          AppCard(
            child: Column(children: [
              _ToggleRow(
                icon: Icons.logo_dev_rounded,
                title: 'Show AAYUTRACK Logo',
                subtitle: 'Include branded header in the PDF',
                value: design.showLogo,
                onChanged: (v) => ref
                    .read(reportsProvider.notifier)
                    .updatePdfDesign(design.copyWith(showLogo: v)),
              ),
              const Divider(color: AppColors.border, height: 1),
              _ToggleRow(
                icon: Icons.format_list_numbered_rounded,
                title: 'Page Numbers',
                subtitle: 'Show page numbers in the footer',
                value: design.showPageNumbers,
                onChanged: (v) => ref
                    .read(reportsProvider.notifier)
                    .updatePdfDesign(design.copyWith(showPageNumbers: v)),
              ),
              const Divider(color: AppColors.border, height: 1),
              _ToggleRow(
                icon: Icons.account_circle_rounded,
                title: 'Patient Photo',
                subtitle: 'Include avatar in the cover section',
                value: design.showPatientPhoto,
                onChanged: (v) => ref
                    .read(reportsProvider.notifier)
                    .updatePdfDesign(design.copyWith(showPatientPhoto: v)),
              ),
            ]),
          ),
          const SizedBox(height: 24),

          // ── Doctor-share section ─────────────────────────────────────────
          const SectionHeader(title: "Doctor's Cover Note"),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ToggleRow(
                  icon: Icons.local_hospital_rounded,
                  title: "Include Doctor's Summary",
                  subtitle: 'Add a cover note when sharing with your physician',
                  value: design.includeDoctorSummary,
                  onChanged: (v) => ref
                      .read(reportsProvider.notifier)
                      .updatePdfDesign(
                          design.copyWith(includeDoctorSummary: v)),
                ),
                if (design.includeDoctorSummary) ...[
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: "Doctor's Name",
                    hint: 'e.g. Dr. Priya Sharma',
                    controller: _doctorNameController,
                    onChanged: (_) => _saveDesignField(),
                    prefixIcon: const Icon(Icons.person_outline,
                        color: AppColors.textMuted, size: 18),
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Personal Note (Optional)',
                    hint:
                        'Add a note for your doctor about this report period…',
                    controller: _doctorNoteController,
                    maxLines: 3,
                    onChanged: (_) => _saveDesignField(),
                  ),
                  const SizedBox(height: 8),
                  _DoctorSummaryPreview(
                    patientName: profile?.fullName ?? 'Patient',
                    doctorName: _doctorNameController.text.isNotEmpty
                        ? _doctorNameController.text
                        : 'Doctor',
                    compliance: compliance,
                    design: design,
                    scheme: selectedScheme,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── Export CTA ───────────────────────────────────────────────────
          AppButton(
            label: reportsState.isExporting ? 'Generating PDF…' : 'Export PDF',
            icon: Icons.picture_as_pdf_rounded,
            isLoading: reportsState.isExporting,
            onPressed: reportsState.isExporting
                ? null
                : () async {
                    _saveDesignField();
                    await ref.read(reportsProvider.notifier).generateReport();
                    if (context.mounted) {
                      _showSuccessSheet(context);
                    }
                  },
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'Share with Doctor',
            icon: Icons.share_rounded,
            outlined: true,
            isLoading: reportsState.isExporting,
            onPressed: reportsState.isExporting
                ? null
                : () async {
                    _saveDesignField();
                    await ref.read(reportsProvider.notifier).generateReport();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(children: [
                            Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 18),
                            SizedBox(width: 10),
                            Expanded(
                                child: Text('Report ready to share with doctor')),
                          ]),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }

  void _showSuccessSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 34),
            ),
            const SizedBox(height: 16),
            const Text(
              'PDF Exported!',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your report has been saved and added to History. You can now share it with your doctor.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: AppButton(
                  label: 'Share',
                  icon: Icons.share_rounded,
                  outlined: true,
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(children: [
                          Icon(Icons.share_rounded,
                              color: Colors.white, size: 16),
                          SizedBox(width: 10),
                          Text('Opening share sheet…'),
                        ]),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: 'Done',
                  onPressed: () {
                    Navigator.pop(context); // sheet
                    Navigator.pop(context); // pdf design screen
                    Navigator.pop(context); // preview screen back to reports
                  },
                ),
              ),
            ]),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ─── LIVE PREVIEW CARD ────────────────────────────────────────────────────────

class _LivePreviewCard extends StatelessWidget {
  final _PdfColorScheme scheme;
  final String patientName;
  final String bloodGroup;
  final ComplianceState compliance;
  final MedicineState medicines;
  final PdfDesignState design;

  const _LivePreviewCard({
    required this.scheme,
    required this.patientName,
    required this.bloodGroup,
    required this.compliance,
    required this.medicines,
    required this.design,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
              color: AppColors.shadow, blurRadius: 14, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simulated PDF header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [scheme.primary, scheme.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg - 1)),
            ),
            child: Row(children: [
              if (design.showLogo) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('AAYUTRACK',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1)),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text('Health Compliance Report',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                  Text(patientName,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 9)),
                ]),
              ),
              if (design.showPatientPhoto)
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  child: Text(
                    patientName.isNotEmpty
                        ? patientName[0].toUpperCase()
                        : 'P',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13),
                  ),
                ),
            ]),
          ),

          // Simulated body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(children: [
                _PreviewStatBox(
                    label: 'Compliance',
                    value: '${compliance.overallScore.toInt()}%',
                    color: scheme.primary),
                const SizedBox(width: 8),
                _PreviewStatBox(
                    label: 'Medicines',
                    value: '${medicines.activeMedicines.length} Active',
                    color: scheme.primary),
                const SizedBox(width: 8),
                _PreviewStatBox(
                    label: 'Blood Group',
                    value: bloodGroup,
                    color: scheme.primary),
              ]),
              const SizedBox(height: 10),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: AppColors.border,
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: compliance.overallScore / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Simulated rows
              ...List.generate(3, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(children: [
                    Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                            color: scheme.primary,
                            shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Container(
                        height: 7,
                        width: 100 - (i * 15.0),
                        decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(3))),
                    const Spacer(),
                    Container(
                        height: 7,
                        width: 40,
                        decoration: BoxDecoration(
                            color: scheme.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(3))),
                  ]),
                );
              }),
              if (design.showPageNumbers) ...[
                const SizedBox(height: 10),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 6),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  const Text('AAYUTRACK · Confidential',
                      style:
                          TextStyle(fontSize: 8, color: AppColors.textMuted)),
                  Text('1',
                      style: TextStyle(
                          fontSize: 8, color: scheme.primary)),
                ]),
              ],
            ]),
          ),
        ],
      ),
    );
  }
}

class _PreviewStatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _PreviewStatBox(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: color)),
          Text(label,
              style:
                  const TextStyle(fontSize: 7, color: AppColors.textMuted)),
        ]),
      ),
    );
  }
}

// ─── DOCTOR SUMMARY PREVIEW ───────────────────────────────────────────────────

class _DoctorSummaryPreview extends StatelessWidget {
  final String patientName;
  final String doctorName;
  final ComplianceState compliance;
  final PdfDesignState design;
  final _PdfColorScheme scheme;

  const _DoctorSummaryPreview({
    required this.patientName,
    required this.doctorName,
    required this.compliance,
    required this.design,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    final note = design.doctorNote.isNotEmpty
        ? design.doctorNote
        : 'Please review the attached compliance report for this period.';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.primary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.preview_rounded, size: 14, color: scheme.primary),
            const SizedBox(width: 6),
            Text('Cover Note Preview',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: scheme.primary)),
          ]),
          const SizedBox(height: 10),
          Text('To: $doctorName',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text('From: $patientName',
              style:
                  const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Text(
            'Overall Compliance: ${compliance.overallScore.toInt()}% · '
            'Medicine Adherence: ${compliance.medicineAdherence.toInt()}%',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: scheme.primary),
          ),
          const SizedBox(height: 8),
          Text(note,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.5)),
        ],
      ),
    );
  }
}

// ─── TOGGLE ROW ───────────────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textPrimary)),
            Text(subtitle,
                style:
                    const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ]),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ]),
    );
  }
}
