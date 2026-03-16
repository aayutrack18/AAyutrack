import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/dose_logs.dart';

part 'dose_logs_dao.g.dart';

@DriftAccessor(tables: [DoseLogs])
class DoseLogsDao extends DatabaseAccessor<AppDatabase>
    with _$DoseLogsDaoMixin {
  DoseLogsDao(AppDatabase db) : super(db);

  Future<void> upsertDoseLog(DoseLogsCompanion doseLog) async {
    await into(doseLogs).insertOnConflictUpdate(doseLog);
  }

  Future<DoseLog?> getDoseLogById(String id) {
    return (select(doseLogs)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<DoseLog>> getDoseLogsByPatientId(String patientId) {
    return (select(doseLogs)
          ..where((tbl) =>
              tbl.patientId.equals(patientId) & tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.scheduledAt)]))
        .get();
  }

  Future<List<DoseLog>> getDoseLogsByMedicineId(String medicineId) {
    return (select(doseLogs)
          ..where((tbl) =>
              tbl.medicineId.equals(medicineId) & tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.scheduledAt)]))
        .get();
  }

  Future<List<DoseLog>> getUnsyncedDoseLogs() {
    return (select(doseLogs)
          ..where((tbl) =>
              tbl.isSynced.equals(false) & tbl.isDeleted.equals(false)))
        .get();
  }

  Future<bool> updateDoseLogSyncStatus({
    required String id,
    required bool isSynced,
  }) async {
    final rows = await (update(doseLogs)..where((tbl) => tbl.id.equals(id)))
        .write(
      DoseLogsCompanion(
        isSynced: Value(isSynced),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return rows > 0;
  }

  Future<bool> softDeleteDoseLog(String id) async {
    final rows = await (update(doseLogs)..where((tbl) => tbl.id.equals(id)))
        .write(
      DoseLogsCompanion(
        isDeleted: const Value(true),
        isSynced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return rows > 0;
  }

  Stream<List<DoseLog>> watchDoseLogsByPatientId(String patientId) {
    return (select(doseLogs)
          ..where((tbl) =>
              tbl.patientId.equals(patientId) & tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.scheduledAt)]))
        .watch();
  }
}