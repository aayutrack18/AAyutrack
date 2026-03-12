import 'package:drift/drift.dart';

import 'database_connection.dart';
import 'tables/patient_profiles.dart';
import 'tables/sync_queue.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    PatientProfiles,
    SyncQueue,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  // ---------------------------------------------------------------------------
  // Patient Profile
  // ---------------------------------------------------------------------------

  Future<void> insertOrUpdatePatientProfile(
    PatientProfilesCompanion profile,
  ) async {
    await into(patientProfiles).insertOnConflictUpdate(profile);
  }

  Future<PatientProfile?> getPatientProfileByUserId(String userId) {
    return (select(patientProfiles)
          ..where((tbl) => tbl.userId.equals(userId)))
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

  // ---------------------------------------------------------------------------
  // Sync Queue
  // ---------------------------------------------------------------------------

  Future<void> addToSyncQueue(
    SyncQueueCompanion syncItem,
  ) async {
    await into(syncQueue).insert(syncItem);
  }

  Future<List<SyncQueueData>> getPendingSyncItems() {
    return (select(syncQueue)
          ..where((tbl) => tbl.status.equals('pending'))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .get();
  }

  Future<List<SyncQueueData>> getFailedSyncItems() {
    return (select(syncQueue)
          ..where((tbl) => tbl.status.equals('failed'))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .get();
  }

  Future<SyncQueueData?> getSyncQueueItemById(String id) {
    return (select(syncQueue)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<bool> updateSyncQueueStatus({
    required String id,
    required String status,
    String? errorMessage,
    int? retryCount,
  }) async {
    final rowsUpdated =
        await (update(syncQueue)..where((tbl) => tbl.id.equals(id))).write(
      SyncQueueCompanion(
        status: Value(status),
        errorMessage: Value(errorMessage),
        retryCount: retryCount != null ? Value(retryCount) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return rowsUpdated > 0;
  }

  Future<bool> incrementSyncRetryCount(String id) async {
    final existing = await getSyncQueueItemById(id);
    if (existing == null) return false;

    final rowsUpdated =
        await (update(syncQueue)..where((tbl) => tbl.id.equals(id))).write(
      SyncQueueCompanion(
        retryCount: Value(existing.retryCount + 1),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return rowsUpdated > 0;
  }

  Future<bool> deleteSyncQueueItem(String id) async {
    final rowsDeleted =
        await (delete(syncQueue)..where((tbl) => tbl.id.equals(id))).go();
    return rowsDeleted > 0;
  }

  Future<void> clearSyncedQueueItems() async {
    await (delete(syncQueue)..where((tbl) => tbl.status.equals('synced'))).go();
  }
}