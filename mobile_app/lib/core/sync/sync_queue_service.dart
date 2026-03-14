import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

class SyncStatusSnapshot {
  final int pendingCount;
  final int syncingCount;
  final int syncedCount;
  final int failedCount;
  final int totalCount;
  final DateTime generatedAt;

  const SyncStatusSnapshot({
    required this.pendingCount,
    required this.syncingCount,
    required this.syncedCount,
    required this.failedCount,
    required this.totalCount,
    required this.generatedAt,
  });

  bool get hasPendingWork => pendingCount > 0 || syncingCount > 0;
  bool get hasFailures => failedCount > 0;
}

class SyncQueueService {
  final AppDatabase database;

  static const _uuid = Uuid();
  static const int maxRetries = AppDatabase.maxSyncRetries;

  SyncQueueService(this.database);

  Future<void> enqueue({
    required String entityType,
    required String entityId,
    required String operation,
    required Map<String, dynamic> payload,
  }) async {
    final existing = await database.findLatestNonSyncedQueueItem(
      entityType: entityType,
      entityId: entityId,
      operation: operation,
    );

    final encodedPayload = jsonEncode(payload);
    final now = DateTime.now();

    if (existing != null) {
      await database.updateSyncQueuePayload(
        id: existing.id,
        payload: encodedPayload,
        status: 'pending',
        errorMessage: null,
      );
      return;
    }

    final item = SyncQueueCompanion.insert(
      id: _uuid.v4(),
      entityType: entityType,
      entityId: entityId,
      operation: operation,
      payload: encodedPayload,
      status: const Value('pending'),
      retryCount: const Value(0),
      errorMessage: const Value(null),
      createdAt: now,
      updatedAt: now,
    );

    await database.addToSyncQueue(item);
  }

  Future<List<SyncQueueData>> getPendingItems() async {
    return database.getPendingSyncItems();
  }

  Future<List<SyncQueueData>> getFailedItems() async {
    return database.getFailedSyncItems();
  }

  Future<List<SyncQueueData>> getSyncedItems() async {
    return database.getSyncedSyncItems();
  }

  Future<List<SyncQueueData>> getPendingItemsByEntityType(
    String entityType,
  ) async {
    final items = await database.getPendingSyncItems();
    return items.where((item) => item.entityType == entityType).toList();
  }

  Future<List<SyncQueueData>> getAllItems() async {
    return database.getAllSyncQueueItems();
  }

  Future<Map<String, int>> getStatusCounts() async {
    return database.getSyncQueueStatusCounts();
  }

  Future<SyncStatusSnapshot> getStatusSnapshot() async {
    final counts = await getStatusCounts();
    return SyncStatusSnapshot(
      pendingCount: counts['pending'] ?? 0,
      syncingCount: counts['syncing'] ?? 0,
      syncedCount: counts['synced'] ?? 0,
      failedCount: counts['failed'] ?? 0,
      totalCount: counts['total'] ?? 0,
      generatedAt: DateTime.now(),
    );
  }

  Future<void> markSyncing(String id) async {
    await database.updateSyncQueueStatus(
      id: id,
      status: 'syncing',
      errorMessage: null,
    );
  }

  Future<void> markSynced(String id) async {
    await database.updateSyncQueueStatus(
      id: id,
      status: 'synced',
      errorMessage: null,
    );
  }

  Future<void> markPending(String id) async {
    await database.markSyncQueueItemAsPending(id);
  }

  Future<void> markFailed(String id, String error) async {
    await database.incrementSyncRetryCount(id);

    final updatedItem = await database.getSyncQueueItemById(id);
    final retries = updatedItem?.retryCount ?? 0;
    final hasRetriesLeft = retries < maxRetries;

    await database.updateSyncQueueStatus(
      id: id,
      status: hasRetriesLeft ? 'pending' : 'failed',
      errorMessage: error,
    );
  }

  Future<void> retryFailedItems() async {
    final failedItems = await getFailedItems();

    for (final item in failedItems) {
      if (canRetry(item)) {
        await database.resetSyncRetryCount(item.id);
        await markPending(item.id);
      }
    }
  }

  Future<int> clearSyncedItems() async {
    return database.clearSyncedSyncQueueItems();
  }

  Future<void> deleteQueueItem(String id) async {
    await database.deleteSyncQueueItem(id);
  }

  bool canRetry(SyncQueueData item) {
    return item.retryCount < maxRetries;
  }

  Future<void> processQueueSequentially({
    required Future<void> Function(SyncQueueData item) processor,
  }) async {
    final pendingItems = await getPendingItems();

    for (final item in pendingItems) {
      try {
        await markSyncing(item.id);
        await processor(item);
        await markSynced(item.id);
      } catch (e) {
        await markFailed(item.id, e.toString());
      }
    }
  }

  Future<void> processQueueSequentiallyByEntityType({
    required String entityType,
    required Future<void> Function(SyncQueueData item) processor,
  }) async {
    final pendingItems = await getPendingItemsByEntityType(entityType);

    for (final item in pendingItems) {
      try {
        await markSyncing(item.id);
        await processor(item);
        await markSynced(item.id);
      } catch (e) {
        await markFailed(item.id, e.toString());
      }
    }
  }
}