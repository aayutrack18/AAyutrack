import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aayutrack/features/compliance/presentation/providers/dose_log_provider.dart';
import 'package:aayutrack/features/medicine/presentation/providers/medicine_provider.dart';
import 'package:aayutrack/features/reminders/presentation/providers/reminder_provider.dart';

import 'compliance_score_service.dart';
import 'digital_twin_model.dart';
import 'digital_twin_service.dart';
import 'missed_dose_detection_service.dart';
import 'risk_detection_service.dart';

final complianceScoreServiceProvider = Provider<ComplianceScoreService>((ref) {
  return const ComplianceScoreService();
});

final missedDoseDetectionServiceProvider =
    Provider<MissedDoseDetectionService>((ref) {
  return const MissedDoseDetectionService();
});

final riskDetectionServiceProvider = Provider<RiskDetectionService>((ref) {
  return RiskDetectionService(
    complianceScoreService: ref.watch(complianceScoreServiceProvider),
    missedDoseDetectionService: ref.watch(missedDoseDetectionServiceProvider),
  );
});

final digitalTwinServiceProvider = Provider<DigitalTwinService>((ref) {
  return DigitalTwinService(
    complianceScoreService: ref.watch(complianceScoreServiceProvider),
    riskDetectionService: ref.watch(riskDetectionServiceProvider),
  );
});

final currentPatientIdProvider = Provider<String>((ref) {
  return 'default_patient';
});

final complianceSummaryProvider = Provider<ComplianceSummary>((ref) {
  final doseLogState = ref.watch(doseLogProvider);
  final complianceService = ref.watch(complianceScoreServiceProvider);

  final now = DateTime.now();
  final periodStart = now.subtract(const Duration(days: 6));
  final periodEnd = now;

  return complianceService.calculate(
    doseLogs: doseLogState.doseLogs,
    periodStart: periodStart,
    periodEnd: periodEnd,
    now: now,
  );
});

final medicineComplianceSummariesProvider =
    Provider<List<MedicineComplianceSummary>>((ref) {
  final doseLogState = ref.watch(doseLogProvider);
  final complianceService = ref.watch(complianceScoreServiceProvider);

  final now = DateTime.now();
  final periodStart = now.subtract(const Duration(days: 6));
  final periodEnd = now;

  return complianceService.calculateByMedicine(
    doseLogs: doseLogState.doseLogs,
    periodStart: periodStart,
    periodEnd: periodEnd,
    now: now,
  );
});

final missedDoseAlertsProvider = Provider<List<MissedDoseAlert>>((ref) {
  final doseLogState = ref.watch(doseLogProvider);
  final detectionService = ref.watch(missedDoseDetectionServiceProvider);

  return detectionService.detectMissedDoses(
    doseLogs: doseLogState.doseLogs,
    now: DateTime.now(),
  );
});

final riskAlertsProvider = Provider<List<RiskAlert>>((ref) {
  final patientId = ref.watch(currentPatientIdProvider);
  final doseLogState = ref.watch(doseLogProvider);
  final medicineState = ref.watch(medicineProvider);
  final reminderState = ref.watch(reminderProvider);
  final riskService = ref.watch(riskDetectionServiceProvider);

  return riskService.detectRisks(
    patientId: patientId,
    doseLogs: doseLogState.doseLogs,
    medicines: medicineState.medicines,
    reminders: reminderState.reminders,
    now: DateTime.now(),
  );
});

final digitalTwinProvider = Provider<DigitalTwinModel>((ref) {
  final patientId = ref.watch(currentPatientIdProvider);
  final doseLogState = ref.watch(doseLogProvider);
  final medicineState = ref.watch(medicineProvider);
  final reminderState = ref.watch(reminderProvider);
  final digitalTwinService = ref.watch(digitalTwinServiceProvider);

  return digitalTwinService.build(
    patientId: patientId,
    doseLogs: doseLogState.doseLogs,
    medicines: medicineState.medicines,
    reminders: reminderState.reminders,
    now: DateTime.now(),
  );
});

final intelligenceLoadingProvider = Provider<bool>((ref) {
  final doseLogState = ref.watch(doseLogProvider);
  final medicineState = ref.watch(medicineProvider);
  final reminderState = ref.watch(reminderProvider);

  return doseLogState.isLoading ||
      medicineState.isLoading ||
      reminderState.isLoading;
});

final intelligenceErrorsProvider = Provider<List<String>>((ref) {
  final doseLogState = ref.watch(doseLogProvider);
  final medicineState = ref.watch(medicineProvider);
  final reminderState = ref.watch(reminderProvider);

  final errors = <String>[];

  if (doseLogState.errorMessage != null &&
      doseLogState.errorMessage!.trim().isNotEmpty) {
    errors.add(doseLogState.errorMessage!);
  }

  if (medicineState.errorMessage != null &&
      medicineState.errorMessage!.trim().isNotEmpty) {
    errors.add(medicineState.errorMessage!);
  }

  if (reminderState.errorMessage != null &&
      reminderState.errorMessage!.trim().isNotEmpty) {
    errors.add(reminderState.errorMessage!);
  }

  return errors;
});