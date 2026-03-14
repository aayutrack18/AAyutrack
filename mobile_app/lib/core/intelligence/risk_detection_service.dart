import 'package:aayutrack/core/intelligence/compliance_score_service.dart';
import 'package:aayutrack/core/intelligence/missed_dose_detection_service.dart';
import 'package:aayutrack/features/compliance/domain/entities/dose_log.dart';
import 'package:aayutrack/features/medicine/domain/entities/medicine.dart';
import 'package:aayutrack/features/reminders/domain/entities/reminder.dart';

class RiskAlert {
  final String id;
  final String patientId;
  final String riskType;
  final String severity;
  final String title;
  final String description;
  final DateTime detectedAt;
  final Map<String, dynamic> metadata;

  const RiskAlert({
    required this.id,
    required this.patientId,
    required this.riskType,
    required this.severity,
    required this.title,
    required this.description,
    required this.detectedAt,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'riskType': riskType,
      'severity': severity,
      'title': title,
      'description': description,
      'detectedAt': detectedAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}

class RiskDetectionService {
  final ComplianceScoreService complianceScoreService;
  final MissedDoseDetectionService missedDoseDetectionService;

  const RiskDetectionService({
    required this.complianceScoreService,
    required this.missedDoseDetectionService,
  });

  List<RiskAlert> detectRisks({
    required String patientId,
    required List<DoseLog> doseLogs,
    required List<Medicine> medicines,
    required List<Reminder> reminders,
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();
    final alerts = <RiskAlert>[];

    alerts.addAll(
      _detectLowComplianceRisk(
        patientId: patientId,
        doseLogs: doseLogs,
        now: currentTime,
      ),
    );

    alerts.addAll(
      _detectRepeatedMissedDoseRisk(
        patientId: patientId,
        doseLogs: doseLogs,
        now: currentTime,
      ),
    );

    alerts.addAll(
      _detectInactiveMedicineReminderMismatch(
        patientId: patientId,
        medicines: medicines,
        reminders: reminders,
        now: currentTime,
      ),
    );

    alerts.sort((a, b) => _severityRank(b.severity).compareTo(_severityRank(a.severity)));
    return alerts;
  }

  List<RiskAlert> _detectLowComplianceRisk({
    required String patientId,
    required List<DoseLog> doseLogs,
    required DateTime now,
  }) {
    final start = now.subtract(const Duration(days: 6));
    final end = now;

    final summary = complianceScoreService.calculate(
      doseLogs: doseLogs,
      periodStart: start,
      periodEnd: end,
      now: now,
    );

    if (summary.totalScheduled == 0) {
      return const [];
    }

    if (summary.complianceScore >= 80) {
      return const [];
    }

    final severity = summary.complianceScore < 50
        ? 'high'
        : summary.complianceScore < 65
            ? 'medium'
            : 'low';

    return [
      RiskAlert(
        id: 'risk-low-compliance-$patientId',
        patientId: patientId,
        riskType: 'low_compliance',
        severity: severity,
        title: 'Low compliance detected',
        description:
            'The recent adherence score is below the recommended threshold.',
        detectedAt: now,
        metadata: summary.toJson(),
      ),
    ];
  }

  List<RiskAlert> _detectRepeatedMissedDoseRisk({
    required String patientId,
    required List<DoseLog> doseLogs,
    required DateTime now,
  }) {
    final start = now.subtract(const Duration(days: 3));
    final recentLogs = doseLogs
        .where((log) => !log.isDeleted)
        .where((log) => !log.scheduledAt.isBefore(start))
        .toList();

    final consecutiveMissed =
        missedDoseDetectionService.findConsecutiveMissedDoses(
      doseLogs: recentLogs,
      minimumStreak: 2,
    );

    if (consecutiveMissed.isEmpty) {
      return const [];
    }

    final streakCount = consecutiveMissed.length;
    final severity = streakCount >= 4
        ? 'high'
        : streakCount >= 3
            ? 'medium'
            : 'low';

    return [
      RiskAlert(
        id: 'risk-missed-streak-$patientId',
        patientId: patientId,
        riskType: 'repeated_missed_doses',
        severity: severity,
        title: 'Repeated missed doses detected',
        description:
            'The patient has a streak of missed medication events that may require intervention.',
        detectedAt: now,
        metadata: {
          'streakCount': streakCount,
          'logs': consecutiveMissed
              .map(
                (log) => {
                  'id': log.id,
                  'medicineId': log.medicineId,
                  'scheduledAt': log.scheduledAt.toIso8601String(),
                },
              )
              .toList(),
        },
      ),
    ];
  }

  List<RiskAlert> _detectInactiveMedicineReminderMismatch({
    required String patientId,
    required List<Medicine> medicines,
    required List<Reminder> reminders,
    required DateTime now,
  }) {
    final inactiveMedicineIds = medicines
        .where((medicine) => !medicine.isDeleted && !medicine.isActive)
        .map((medicine) => medicine.id)
        .toSet();

    final invalidEnabledReminders = reminders
        .where((reminder) => !reminder.isDeleted && reminder.isEnabled)
        .where(
          (reminder) =>
              reminder.linkedMedicineId != null &&
              inactiveMedicineIds.contains(reminder.linkedMedicineId),
        )
        .toList();

    if (invalidEnabledReminders.isEmpty) {
      return const [];
    }

    return [
      RiskAlert(
        id: 'risk-reminder-mismatch-$patientId',
        patientId: patientId,
        riskType: 'inactive_medicine_active_reminder',
        severity: 'medium',
        title: 'Reminder and medicine state mismatch',
        description:
            'One or more enabled reminders are linked to inactive medicines.',
        detectedAt: now,
        metadata: {
          'reminderCount': invalidEnabledReminders.length,
          'reminders': invalidEnabledReminders
              .map(
                (reminder) => {
                  'id': reminder.id,
                  'linkedMedicineId': reminder.linkedMedicineId,
                  'title': reminder.title,
                  'time': reminder.time,
                },
              )
              .toList(),
        },
      ),
    ];
  }

  int _severityRank(String severity) {
    switch (severity) {
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 0;
    }
  }
}