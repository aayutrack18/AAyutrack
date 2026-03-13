import 'package:aayutrack/features/compliance/domain/entities/dose_log.dart';

abstract class DoseLogRepository {
  Future<List<DoseLog>> getDoseLogs();
  Future<List<DoseLog>> getDoseLogsByMedicineId(String medicineId);

  Future<void> saveDoseLog(DoseLog doseLog);
  Future<void> updateDoseLog(DoseLog doseLog);
  Future<void> deleteDoseLog(String id);

  Future<void> markAsTaken({
    required String id,
    required DateTime takenAt,
    String? notes,
  });

  Future<void> markAsMissed({
    required String id,
    String? notes,
  });

  Future<void> markAsSkipped({
    required String id,
    String? notes,
  });
}
