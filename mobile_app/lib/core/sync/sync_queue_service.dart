import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

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
    final now = DateTime.now();

    final item = SyncQueueCompanion.insert(
      id: _uuid.v4(),
      entityType: entityType,
      entityId: entityId,
      operation: operation,
      payload: jsonEncode(payload),
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