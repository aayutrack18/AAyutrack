import 'package:drift/drift.dart';

import 'daos/dose_logs_dao.dart';
import 'daos/health_logs_dao.dart';
import 'daos/medicines_dao.dart';
import 'daos/reminders_dao.dart';
import 'database_connection.dart';
import 'tables/dose_logs.dart';
import 'tables/health_logs.dart';
import 'tables/intelligence_snapshots.dart';
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
    HealthLogs,
    IntelligenceSnapshots,
  ],
  daos: [
    MedicinesDao,
    RemindersDao,
    DoseLogsDao,
    HealthLogsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  static const int maxSyncRetries = 3;

  @override
  int get schemaVersion => 7;

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

          if (from < 6) {
            await m.createTable(intelligenceSnapshots);
          }

          if (from < 7) {
            await m.createTable(healthLogs);
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

  Future<SyncQueueData?> findLatestNonSyncedQueueItem({
    required String entityType,
    required String entityId,
    required String operation,
  }) {
    return (select(syncQueue)
          ..where((tbl) =>
              tbl.entityType.equals(entityType) &
              tbl.entityId.equals(entityId) &
              tbl.operation.equals(operation) &
              tbl.status.equals('synced').not())
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> updateSyncQueuePayload({
    required String id,
    required String payload,
    String? status,
    String? errorMessage,
  }) async {
    await (update(syncQueue)..where((tbl) => tbl.id.equals(id))).write(
      SyncQueueCompanion(
        payload: Value(payload),
        status: status == null ? const Value.absent() : Value(status),
        errorMessage: Value(errorMessage),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<SyncQueueData>> getPendingSyncItems() {
    return (select(syncQueue)
          ..where((tbl) =>
              tbl.status.equals('pending') |
              (tbl.status.equals('failed') &
                  tbl.retryCount.isSmallerThanValue(maxSyncRetries)))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .get();
  }

  Future<List<SyncQueueData>> getFailedSyncItems() {
    return (select(syncQueue)
          ..where((tbl) => tbl.status.equals('failed'))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.updatedAt)]))
        .get();
  }

  Future<List<SyncQueueData>> getSyncedSyncItems() {
    return (select(syncQueue)
          ..where((tbl) => tbl.status.equals('synced'))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.updatedAt)]))
        .get();
  }

  Future<List<SyncQueueData>> getAllSyncQueueItems() {
    return (select(syncQueue)
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .get();
  }

  Future<SyncQueueData?> getSyncQueueItemById(String id) {
    return (select(syncQueue)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
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
    final item = await getSyncQueueItemById(id);
    if (item == null) return;

    await (update(syncQueue)..where((tbl) => tbl.id.equals(id))).write(
      SyncQueueCompanion(
        retryCount: Value(item.retryCount + 1),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> resetSyncRetryCount(String id) async {
    await (update(syncQueue)..where((tbl) => tbl.id.equals(id))).write(
      SyncQueueCompanion(
        retryCount: const Value(0),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> markSyncQueueItemAsPending(String id) async {
    await (update(syncQueue)..where((tbl) => tbl.id.equals(id))).write(
      SyncQueueCompanion(
        status: const Value('pending'),
        errorMessage: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteSyncQueueItem(String id) async {
    await (delete(syncQueue)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> clearSyncedSyncQueueItems() {
    return (delete(syncQueue)..where((tbl) => tbl.status.equals('synced'))).go();
  }

  Future<Map<String, int>> getSyncQueueStatusCounts() async {
    final items = await getAllSyncQueueItems();

    int pending = 0;
    int syncing = 0;
    int synced = 0;
    int failed = 0;

    for (final item in items) {
      switch (item.status) {
        case 'pending':
          pending++;
          break;
        case 'syncing':
          syncing++;
          break;
        case 'synced':
          synced++;
          break;
        case 'failed':
          failed++;
          break;
      }
    }

    return {
      'pending': pending,
      'syncing': syncing,
      'synced': synced,
      'failed': failed,
      'total': items.length,
    };
  }

  Future<void> insertIntelligenceSnapshot(
    IntelligenceSnapshotsCompanion snapshot,
  ) async {
    await into(intelligenceSnapshots).insertOnConflictUpdate(snapshot);
  }

  Future<List<IntelligenceSnapshot>> getIntelligenceSnapshotsByPatientId(
    String patientId, {
    String? snapshotType,
    int? limit,
  }) {
    final query = select(intelligenceSnapshots)
      ..where((tbl) => tbl.patientId.equals(patientId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.generatedAt)]);

    if (snapshotType != null) {
      query.where((tbl) => tbl.snapshotType.equals(snapshotType));
    }

    if (limit != null) {
      query.limit(limit);
    }

    return query.get();
  }

  Future<IntelligenceSnapshot?> getLatestIntelligenceSnapshot(
    String patientId, {
    String? snapshotType,
  }) {
    final query = select(intelligenceSnapshots)
      ..where((tbl) => tbl.patientId.equals(patientId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.generatedAt)])
      ..limit(1);

    if (snapshotType != null) {
      query.where((tbl) => tbl.snapshotType.equals(snapshotType));
    }

    return query.getSingleOrNull();
  }

  Future<int> deleteOldIntelligenceSnapshots(
    String patientId, {
    required DateTime olderThan,
  }) {
    return (delete(intelligenceSnapshots)
          ..where((tbl) =>
              tbl.patientId.equals(patientId) &
              tbl.generatedAt.isSmallerThanValue(olderThan)))
        .go();
  }

  @override
  Future<void> close() => super.close();
}