import 'package:drift/drift.dart';

import 'daos/dose_logs_dao.dart';
import 'daos/medicines_dao.dart';
import 'daos/reminders_dao.dart';
import 'database_connection.dart';
import 'tables/dose_logs.dart';
import 'tables/medicines.dart';
import 'tables/patient_profiles.dart';
import 'tables/reminders.dart';
import 'tables/sync_queue.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    PatientProfiles,
    SyncQueue,
    Medicines,
    Reminders,
    DoseLogs,
  ],
  daos: [
    MedicinesDao,
    RemindersDao,
    DoseLogsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(syncQueue);
          }

          if (from < 3) {
            await m.createTable(medicines);
            await m.createTable(reminders);
            await m.createTable(doseLogs);
          }

          if (from >= 3 && from < 4) {
            await m.addColumn(medicines, medicines.frequency);
            await m.addColumn(medicines, medicines.scheduledTimes);
            await m.addColumn(medicines, medicines.color);
          }

          if (from >= 4 && from < 5) {
            await m.addColumn(reminders, reminders.reminderType);
          }
        },
      );

  Future<void> insertOrUpdatePatientProfile(
    PatientProfilesCompanion profile,
  ) async {
    await into(patientProfiles).insertOnConflictUpdate(profile);
  }

  Future<PatientProfile?> getPatientProfileByUserId(String userId) {
    return (select(patientProfiles)..where((tbl) => tbl.userId.equals(userId)))
        .getSingleOrNull();
  }

  Future<List<PatientProfile>> getAllPatientProfiles() {
    return select(patientProfiles).get();
  }

  Future<bool> updatePatientProfileSyncStatus({
    required String id,
    required bool isSynced,
  }) async {
    final rowsUpdated =
        await (update(patientProfiles)..where((tbl) => tbl.id.equals(id))).write(
      PatientProfilesCompanion(
        isSynced: Value(isSynced),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return rowsUpdated > 0;
  }

  Future<bool> deletePatientProfile(String id) async {
    final rowsDeleted =
        await (delete(patientProfiles)..where((tbl) => tbl.id.equals(id))).go();
    return rowsDeleted > 0;
  }

  Future<void> addToSyncQueue(SyncQueueCompanion item) async {
    await into(syncQueue).insertOnConflictUpdate(item);
  }

  Future<List<SyncQueueData>> getPendingSyncItems() {
    return (select(syncQueue)
          ..where((tbl) => tbl.status.equals('pending'))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .get();
  }

  Future<void> updateSyncQueueStatus({
    required String id,
    required String status,
    String? errorMessage,
  }) async {
    await (update(syncQueue)..where((tbl) => tbl.id.equals(id))).write(
      SyncQueueCompanion(
        status: Value(status),
        errorMessage: Value(errorMessage),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> incrementSyncRetryCount(String id) async {
    final item = await (select(syncQueue)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    if (item == null) return;

    await (update(syncQueue)..where((tbl) => tbl.id.equals(id))).write(
      SyncQueueCompanion(
        retryCount: Value(item.retryCount + 1),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}