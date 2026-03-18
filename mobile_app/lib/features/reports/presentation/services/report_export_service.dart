import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import 'package:aayutrack/features/compliance/presentation/providers/compliance_provider.dart';
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';
import 'package:aayutrack/features/health_logs/presentation/providers/health_log_provider.dart';
import 'package:aayutrack/features/medicine/presentation/providers/medicine_provider.dart';
import 'package:aayutrack/features/profile/domain/entities/patient_profile.dart';
import 'package:aayutrack/features/reports/presentation/providers/reports_provider.dart';

class ReportExportResult {
  final File file;
  final String title;
  final String dateRange;
  final int pageCount;
  final String templateId;

  const ReportExportResult({
    required this.file,
    required this.title,
    required this.dateRange,
    required this.pageCount,
    required this.templateId,
  });
}

class ReportExportService {
  ReportExportService._();

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String _formatDate(DateTime dt) {
    return '${dt.day} ${_months[dt.month - 1]} ${dt.year}';
  }

  static String _formatDateTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${_formatDate(dt)}  $hour:$minute';
  }

  static String _templateName(String templateId) {
    switch (templateId) {
      case 'template_doctor':
        return "Doctor's Report";
      case 'template_compliance':
        return 'Compliance Report';
      case 'template_vitals':
        return 'Vitals Summary';
      default:
        return 'Health Report';
    }
  }

  static PdfColor _schemePrimary(String id) {
    switch (id) {
      case 'teal':
        return PdfColor.fromInt(0xFF0D9488);
      case 'slate':
        return PdfColor.fromInt(0xFF334155);
      case 'violet':
        return PdfColor.fromInt(0xFF7C3AED);
      case 'blue':
      default:
        return PdfColor.fromInt(0xFF1D4ED8);
    }
  }

  static PdfColor _schemeAccent(String id) {
    switch (id) {
      case 'teal':
        return PdfColor.fromInt(0xFF0F766E);
      case 'slate':
        return PdfColor.fromInt(0xFF1E293B);
      case 'violet':
        return PdfColor.fromInt(0xFF6D28D9);
      case 'blue':
      default:
        return PdfColor.fromInt(0xFF1E40AF);
    }
  }

  static String _safeValue(
    String value, {
    String fallback = 'Not available',
  }) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? fallback : trimmed;
  }

  static String _dateRange(ReportsState reportsState) {
    return '${_formatDate(reportsState.startDate)} – ${_formatDate(reportsState.endDate)}';
  }

  static Future<Uint8List> buildPdf({
    required ReportsState reportsState,
    required ComplianceState compliance,
    required MedicineState medicines,
    required HealthLogState healthLogs,
    required PatientProfile? profile,
  }) async {
    final pdf = pw.Document();
    final primary = _schemePrimary(reportsState.pdfDesign.colorSchemeId);
    final accent = _schemeAccent(reportsState.pdfDesign.colorSchemeId);
    final enabledSections = reportsState.enabledSections;
    final reportTitle = _templateName(reportsState.selectedTemplateId);
    final period = _dateRange(reportsState);
    final generatedOn = _formatDateTime(DateTime.now());

    final patientName = profile?.fullName.trim().isNotEmpty == true
        ? profile!.fullName
        : 'Patient';

    final bmi = (profile?.heightCm != null &&
            profile?.weightKg != null &&
            profile!.heightCm! > 0)
        ? (profile.weightKg! /
                ((profile.heightCm! / 100) * (profile.heightCm! / 100)))
            .toStringAsFixed(1)
        : 'N/A';

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(24),
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
          ),
        ),
        footer: reportsState.pdfDesign.showPageNumbers
            ? (context) => pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(top: 12),
                  child: pw.Text(
                    'Page ${context.pageNumber} / ${context.pagesCount}',
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey700,
                    ),
                  ),
                )
            : null,
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(18),
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(12),
              gradient: pw.LinearGradient(
                colors: [primary, accent],
              ),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (reportsState.pdfDesign.showLogo)
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Text(
                      'AAYUTRACK',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: primary,
                        fontSize: 9,
                      ),
                    ),
                  ),
                if (reportsState.pdfDesign.showLogo) pw.SizedBox(height: 10),
                pw.Text(
                  reportTitle,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  'Patient: $patientName',
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 11,
                  ),
                ),
                pw.Text(
                  'Period: $period',
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 11,
                  ),
                ),
                pw.Text(
                  'Generated: $generatedOn',
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 18),

          if (reportsState.pdfDesign.includeDoctorSummary) ...[
            pw.Container(
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: primary, width: 1),
                borderRadius: pw.BorderRadius.circular(10),
                color: PdfColors.blue50,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Doctor's Cover Note",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                      color: primary,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    "Doctor: ${_safeValue(
                      reportsState.pdfDesign.doctorName,
                      fallback: 'Doctor',
                    )}",
                  ),
                  pw.Text('Patient: $patientName'),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    reportsState.pdfDesign.doctorNote.trim().isNotEmpty
                        ? reportsState.pdfDesign.doctorNote.trim()
                        : 'Please review the attached report for this reporting period.',
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),
          ],

          pw.Text(
            'Patient Profile',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 16,
              color: primary,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(
              color: PdfColors.grey300,
              width: 0.6,
            ),
            children: [
              _row('Full Name', _safeValue(profile?.fullName ?? '')),
              _row('Age', profile != null ? '${profile.age} yrs' : 'N/A'),
              _row('Gender', _safeValue(profile?.gender ?? '')),
              _row('Blood Group', _safeValue(profile?.bloodGroup ?? '')),
              _row('Phone', _safeValue(profile?.phoneNumber ?? '')),
              _row('Email', _safeValue(profile?.email ?? '')),
              _row(
                'Height / Weight',
                '${profile?.heightCm?.toStringAsFixed(1) ?? 'N/A'} cm / '
                    '${profile?.weightKg?.toStringAsFixed(1) ?? 'N/A'} kg',
              ),
              _row('BMI', bmi),
              _row('Address', _safeValue(profile?.address ?? '')),
              _row('Allergies', _safeValue(profile?.allergies ?? '')),
              _row(
                'Medical Conditions',
                _safeValue(profile?.medicalConditions ?? ''),
              ),
              _row(
                'Emergency Contact',
                '${_safeValue(profile?.emergencyContactName ?? '')} / '
                    '${_safeValue(profile?.emergencyContactPhone ?? '')}',
              ),
              _row(
                'Sync Status',
                profile?.isSynced == true ? 'Synced' : 'Pending sync',
              ),
            ],
          ),
          pw.SizedBox(height: 18),

          if (enabledSections.any((s) => s.id == 'compliance')) ...[
            _sectionTitle('Compliance Summary', primary),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: _boxDecoration(),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Overall Compliance: ${compliance.overallScore.toInt()}%',
                  ),
                  pw.Text(
                    'Medicine Adherence: ${compliance.medicineAdherence.toInt()}%',
                  ),
                  pw.Text(
                    'Health Log Adherence: ${compliance.logAdherence.toInt()}%',
                  ),
                  pw.Text('Compliance Label: ${compliance.scoreLabel}'),
                  pw.Text('Active Alerts: ${compliance.unreadAlertCount}'),
                ],
              ),
            ),
            pw.SizedBox(height: 16),
          ],

          if (enabledSections.any((s) => s.id == 'medicines')) ...[
            _sectionTitle('Medicine Schedule', primary),
            if (medicines.medicines.isEmpty)
              _emptyBox('No medicines recorded')
            else
              pw.Column(
                children: medicines.medicines.map((m) {
                  final times = m.scheduledTimes.isEmpty
                      ? 'No times'
                      : m.scheduledTimes.join(', ');
                  return pw.Container(
                    width: double.infinity,
                    margin: const pw.EdgeInsets.only(bottom: 8),
                    padding: const pw.EdgeInsets.all(10),
                    decoration: _boxDecoration(),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          m.name,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text('Dosage: ${m.dosage}'),
                        pw.Text('Frequency: ${m.frequency}'),
                        pw.Text('Times: $times'),
                        pw.Text('Status: ${m.isActive ? 'Active' : 'Paused'}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            pw.SizedBox(height: 16),
          ],

          if (enabledSections.any((s) => s.id == 'vitals')) ...[
            _sectionTitle('Health Vitals', primary),
            if (healthLogs.latestByMetric.values.every((e) => e == null))
              _emptyBox('No health readings recorded')
            else
              pw.Column(
                children: MetricType.values.map((type) {
                  final log = healthLogs.latestByMetric[type];
                  if (log == null) return pw.SizedBox.shrink();

                  return pw.Container(
                    width: double.infinity,
                    margin: const pw.EdgeInsets.only(bottom: 8),
                    padding: const pw.EdgeInsets.all(10),
                    decoration: _boxDecoration(),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                type.label,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                'Recorded: ${_formatDateTime(log.recordedAt)}',
                                style: const pw.TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        pw.Text(
                          '${log.displayValue}${type.unit.isNotEmpty ? ' ${type.unit}' : ''}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            pw.SizedBox(height: 16),
          ],

          if (enabledSections.any((s) => s.id == 'alerts')) ...[
            _sectionTitle('Risk Alerts', primary),
            if (compliance.alerts.isEmpty)
              _emptyBox('No active alerts')
            else
              pw.Column(
                children: compliance.alerts.map((alert) {
                  return pw.Container(
                    width: double.infinity,
                    margin: const pw.EdgeInsets.only(bottom: 8),
                    padding: const pw.EdgeInsets.all(10),
                    decoration: _boxDecoration(),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          alert.title,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(alert.description),
                        pw.SizedBox(height: 4),
                        pw.Text('Severity: ${alert.severity.toUpperCase()}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            pw.SizedBox(height: 16),
          ],

          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Text(
              'Generated by AAYUTRACK · Digital Compliance & Remote Patient Monitoring Platform',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.TableRow _row(String left, String right) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            left,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            right,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }

  static pw.Widget _sectionTitle(String title, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 16,
          color: color,
        ),
      ),
    );
  }

  static pw.BoxDecoration _boxDecoration() {
    return pw.BoxDecoration(
      border: pw.Border.all(
        color: PdfColors.grey300,
        width: 0.7,
      ),
      borderRadius: pw.BorderRadius.circular(8),
    );
  }

  static pw.Widget _emptyBox(String text) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: pw.Text(text),
    );
  }

  static Future<ReportExportResult> saveReport({
    required ReportsState reportsState,
    required ComplianceState compliance,
    required MedicineState medicines,
    required HealthLogState healthLogs,
    required PatientProfile? profile,
  }) async {
    final bytes = await buildPdf(
      reportsState: reportsState,
      compliance: compliance,
      medicines: medicines,
      healthLogs: healthLogs,
      profile: profile,
    );

    final dir = await getApplicationDocumentsDirectory();
    final now = DateTime.now();

    final fileName =
        'aayutrack_report_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}.pdf';

    final file = File(p.join(dir.path, fileName));
    await file.writeAsBytes(bytes, flush: true);

    return ReportExportResult(
      file: file,
      title:
          '${_templateName(reportsState.selectedTemplateId)} – ${_months[now.month - 1]} ${now.year}',
      dateRange: _dateRange(reportsState),
      pageCount: reportsState.enabledSections.length +
          (reportsState.pdfDesign.includeDoctorSummary ? 1 : 0),
      templateId: reportsState.selectedTemplateId,
    );
  }

  static Future<ReportExportResult> shareReport({
    required ReportsState reportsState,
    required ComplianceState compliance,
    required MedicineState medicines,
    required HealthLogState healthLogs,
    required PatientProfile? profile,
  }) async {
    final result = await saveReport(
      reportsState: reportsState,
      compliance: compliance,
      medicines: medicines,
      healthLogs: healthLogs,
      profile: profile,
    );

    await Share.shareXFiles(
      [XFile(result.file.path)],
      text: 'AAYUTRACK Patient Health Report',
      subject: result.title,
    );

    return result;
  }
}