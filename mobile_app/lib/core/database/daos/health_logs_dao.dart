import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/health_logs.dart';

part 'health_logs_dao.g.dart';

@DriftAccessor(tables: [HealthLogs])
class HealthLogsDao extends DatabaseAccessor<AppDatabase>
    with _$HealthLogsDaoMixin {
  HealthLogsDao(AppDatabase db) : super(db);

  Future<void> upsertHealthLog(HealthLogsCompanion healthLog) async {
    await into(healthLogs).insertOnConflictUpdate(healthLog);
  }

  Future<HealthLog?> getHealthLogById(String id) {
    return (select(healthLogs)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<HealthLog>> getHealthLogsByPatientId(String patientId) {
    return (select(healthLogs)
          ..where((tbl) =>
              tbl.patientId.equals(patientId) & tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.recordedAt)]))
        .get();
  }

  Future<List<HealthLog>> getHealthLogsByType({
    required String patientId,
    required String metricType,
  }) {
    return (select(healthLogs)
          ..where((tbl) =>
              tbl.patientId.equals(patientId) &
              tbl.metricType.equals(metricType) &
              tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.recordedAt)]))
        .get();
  }

  Future<HealthLog?> getLatestHealthLogByType({
    required String patientId,
    required String metricType,
  }) {
    return (select(healthLogs)
          ..where((tbl) =>
              tbl.patientId.equals(patientId) &
              tbl.metricType.equals(metricType) &
              tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.recordedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<HealthLog>> getUnsyncedHealthLogs() {
    return (select(healthLogs)
          ..where((tbl) =>
              tbl.isSynced.equals(false) & tbl.isDeleted.equals(false)))
        .get();
  }

  Future<bool> updateHealthLogSyncStatus({
    required String id,
    required bool isSynced,
  }) async {
    final rows = await (update(healthLogs)..where((tbl) => tbl.id.equals(id)))
        .write(
      HealthLogsCompanion(
        isSynced: Value(isSynced),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return rows > 0;
  }

  Future<bool> softDeleteHealthLog(String id) async {
    final rows = await (update(healthLogs)..where((tbl) => tbl.id.equals(id)))
        .write(
      HealthLogsCompanion(
        isDeleted: const Value(true),
        isSynced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return rows > 0;
  }

  Stream<List<HealthLog>> watchHealthLogsByPatientId(String patientId) {
    return (select(healthLogs)
          ..where((tbl) =>
              tbl.patientId.equals(patientId) & tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.recordedAt)]))
        .watch();
  }

  Stream<List<HealthLog>> watchHealthLogsByType({
    required String patientId,
    required String metricType,
  }) {
    return (select(healthLogs)
          ..where((tbl) =>
              tbl.patientId.equals(patientId) &
              tbl.metricType.equals(metricType) &
              tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.recordedAt)]))
        .watch();
  }
}