import 'package:aayutrack/core/intelligence/compliance_score_service.dart';
import 'package:aayutrack/core/intelligence/risk_detection_service.dart';

class DigitalTwinAdherencePattern {
  final int totalScheduledDoses;
  final int totalTakenDoses;
  final int totalMissedDoses;
  final int totalSkippedDoses;
  final double averageComplianceScore;
  final int currentMissedDoseStreak;
  final int totalActiveAlerts;

  const DigitalTwinAdherencePattern({
    required this.totalScheduledDoses,
    required this.totalTakenDoses,
    required this.totalMissedDoses,
    required this.totalSkippedDoses,
    required this.averageComplianceScore,
    required this.currentMissedDoseStreak,
    required this.totalActiveAlerts,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalScheduledDoses': totalScheduledDoses,
      'totalTakenDoses': totalTakenDoses,
      'totalMissedDoses': totalMissedDoses,
      'totalSkippedDoses': totalSkippedDoses,
      'averageComplianceScore': averageComplianceScore,
      'currentMissedDoseStreak': currentMissedDoseStreak,
      'totalActiveAlerts': totalActiveAlerts,
    };
  }
}

class DigitalTwinMedicationBehavior {
  final String medicineId;
  final double complianceScore;
  final int scheduledCount;
  final int takenCount;
  final int missedCount;
  final int skippedCount;

  const DigitalTwinMedicationBehavior({
    required this.medicineId,
    required this.complianceScore,
    required this.scheduledCount,
    required this.takenCount,
    required this.missedCount,
    required this.skippedCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'medicineId': medicineId,
      'complianceScore': complianceScore,
      'scheduledCount': scheduledCount,
      'takenCount': takenCount,
      'missedCount': missedCount,
      'skippedCount': skippedCount,
    };
  }
}

class DigitalTwinModel {
  final String patientId;
  final DateTime generatedAt;
  final ComplianceSummary overallCompliance;
  final DigitalTwinAdherencePattern adherencePattern;
  final List<DigitalTwinMedicationBehavior> medicationBehaviors;
  final List<RiskAlert> activeRiskAlerts;
  final String riskLevel;

  const DigitalTwinModel({
    required this.patientId,
    required this.generatedAt,
    required this.overallCompliance,
    required this.adherencePattern,
    required this.medicationBehaviors,
    required this.activeRiskAlerts,
    required this.riskLevel,
  });

  DigitalTwinModel copyWith({
    String? patientId,
    DateTime? generatedAt,
    ComplianceSummary? overallCompliance,
    DigitalTwinAdherencePattern? adherencePattern,
    List<DigitalTwinMedicationBehavior>? medicationBehaviors,
    List<RiskAlert>? activeRiskAlerts,
    String? riskLevel,
  }) {
    return DigitalTwinModel(
      patientId: patientId ?? this.patientId,
      generatedAt: generatedAt ?? this.generatedAt,
      overallCompliance: overallCompliance ?? this.overallCompliance,
      adherencePattern: adherencePattern ?? this.adherencePattern,
      medicationBehaviors: medicationBehaviors ?? this.medicationBehaviors,
      activeRiskAlerts: activeRiskAlerts ?? this.activeRiskAlerts,
      riskLevel: riskLevel ?? this.riskLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'generatedAt': generatedAt.toIso8601String(),
      'overallCompliance': overallCompliance.toJson(),
      'adherencePattern': adherencePattern.toJson(),
      'medicationBehaviors':
          medicationBehaviors.map((behavior) => behavior.toJson()).toList(),
      'activeRiskAlerts':
          activeRiskAlerts.map((alert) => alert.toJson()).toList(),
      'riskLevel': riskLevel,
    };
  }
}