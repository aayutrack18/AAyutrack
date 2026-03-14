import 'package:aayutrack/core/intelligence/compliance_score_service.dart';
import 'package:aayutrack/core/intelligence/digital_twin_model.dart';
import 'package:aayutrack/core/intelligence/risk_detection_service.dart';
import 'package:aayutrack/features/compliance/domain/entities/dose_log.dart';
import 'package:aayutrack/features/medicine/domain/entities/medicine.dart';
import 'package:aayutrack/features/reminders/domain/entities/reminder.dart';

class DigitalTwinService {
  final ComplianceScoreService complianceScoreService;
  final RiskDetectionService riskDetectionService;

  const DigitalTwinService({
    required this.complianceScoreService,
    required this.riskDetectionService,
  });

  DigitalTwinModel build({
    required String patientId,
    required List<DoseLog> doseLogs,
    required List<Medicine> medicines,
    required List<Reminder> reminders,
    DateTime? now,
    int analysisWindowDays = 7,
  }) {
    final currentTime = now ?? DateTime.now();
    final periodStart = currentTime.subtract(Duration(days: analysisWindowDays - 1));
    final periodEnd = currentTime;

    final filteredDoseLogs = doseLogs
        .where((log) => log.patientId == patientId && !log.isDeleted)
        .toList();

    final filteredMedicines = medicines
        .where((medicine) => medicine.patientId == patientId && !medicine.isDeleted)
        .toList();

    final filteredReminders = reminders
        .where((reminder) => reminder.patientId == patientId && !reminder.isDeleted)
        .toList();

    final overallCompliance = complianceScoreService.calculate(
      doseLogs: filteredDoseLogs,
      periodStart: periodStart,
      periodEnd: periodEnd,
      now: currentTime,
    );

    final medicineCompliance = complianceScoreService.calculateByMedicine(
      doseLogs: filteredDoseLogs,
      periodStart: periodStart,
      periodEnd: periodEnd,
      now: currentTime,
    );

    final activeRiskAlerts = riskDetectionService.detectRisks(
      patientId: patientId,
      doseLogs: filteredDoseLogs,
      medicines: filteredMedicines,
      reminders: filteredReminders,
      now: currentTime,
    );

    final adherencePattern = DigitalTwinAdherencePattern(
      totalScheduledDoses: overallCompliance.totalScheduled,
      totalTakenDoses: overallCompliance.takenCount,
      totalMissedDoses: overallCompliance.missedCount,
      totalSkippedDoses: overallCompliance.skippedCount,
      averageComplianceScore: overallCompliance.complianceScore,
      currentMissedDoseStreak: _calculateCurrentMissedDoseStreak(filteredDoseLogs),
      totalActiveAlerts: activeRiskAlerts.length,
    );

    final medicationBehaviors = medicineCompliance
        .map(
          (item) => DigitalTwinMedicationBehavior(
            medicineId: item.medicineId,
            complianceScore: item.complianceScore,
            scheduledCount: item.totalScheduled,
            takenCount: item.takenCount,
            missedCount: item.missedCount,
            skippedCount: item.skippedCount,
          ),
        )
        .toList()
      ..sort((a, b) => a.medicineId.compareTo(b.medicineId));

    return DigitalTwinModel(
      patientId: patientId,
      generatedAt: currentTime,
      overallCompliance: overallCompliance,
      adherencePattern: adherencePattern,
      medicationBehaviors: medicationBehaviors,
      activeRiskAlerts: activeRiskAlerts,
      riskLevel: _deriveRiskLevel(
        complianceScore: overallCompliance.complianceScore,
        activeAlerts: activeRiskAlerts,
        missedStreak: adherencePattern.currentMissedDoseStreak,
      ),
    );
  }

  int _calculateCurrentMissedDoseStreak(List<DoseLog> doseLogs) {
    final sortedLogs = doseLogs
        .where((log) => !log.isDeleted)
        .toList()
      ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

    var streak = 0;
    for (final log in sortedLogs) {
      if (log.isMissed) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  String _deriveRiskLevel({
    required double complianceScore,
    required List<RiskAlert> activeAlerts,
    required int missedStreak,
  }) {
    final highAlerts = activeAlerts.where((alert) => alert.severity == 'high').length;
    final mediumAlerts =
        activeAlerts.where((alert) => alert.severity == 'medium').length;

    if (highAlerts > 0 || complianceScore < 50 || missedStreak >= 4) {
      return 'high';
    }

    if (mediumAlerts > 0 || complianceScore < 80 || missedStreak >= 2) {
      return 'medium';
    }

    return 'low';
  }
}