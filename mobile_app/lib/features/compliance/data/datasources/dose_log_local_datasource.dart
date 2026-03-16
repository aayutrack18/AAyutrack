import 'package:aayutrack/core/database/daos/dose_logs_dao.dart';
import 'package:aayutrack/features/compliance/data/models/dose_log_model.dart';

class DoseLogLocalDataSource {
  final DoseLogsDao doseLogsDao;

  const DoseLogLocalDataSource({
    required this.doseLogsDao,
  });

  Future<List<DoseLogModel>> getDoseLogs({
    String patientId = 'default_patient',
  }) async {
    final rows = await doseLogsDao.getDoseLogsByPatientId(patientId);
    return rows.map(DoseLogModel.fromDb).toList();
  }

  Future<List<DoseLogModel>> getDoseLogsByMedicineId(String medicineId) async {
    final rows = await doseLogsDao.getDoseLogsByMedicineId(medicineId);
    return rows.map(DoseLogModel.fromDb).toList();
  }

  Future<DoseLogModel?> getDoseLogById(String id) async {
    final row = await doseLogsDao.getDoseLogById(id);
    if (row == null) return null;
    return DoseLogModel.fromDb(row);
  }

  Future<void> saveDoseLog(DoseLogModel doseLog) async {
    await doseLogsDao.upsertDoseLog(doseLog.toCompanion());
  }

  Future<void> updateDoseLog(DoseLogModel doseLog) async {
    await doseLogsDao.upsertDoseLog(doseLog.toCompanion());
  }

  Future<void> deleteDoseLog(String id) async {
    await doseLogsDao.softDeleteDoseLog(id);
  }

  Future<void> markDoseLogAsSynced(String id) async {
    await doseLogsDao.updateDoseLogSyncStatus(
      id: id,
      isSynced: true,
    );
  }

  Future<void> markDoseLogAsPendingSync(String id) async {
    await doseLogsDao.updateDoseLogSyncStatus(
      id: id,
      isSynced: false,
    );
  }
}
