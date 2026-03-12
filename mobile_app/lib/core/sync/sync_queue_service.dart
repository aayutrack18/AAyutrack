import 'dart:convert';

import 'package:drift/drift.dart';
import '../database/app_database.dart';

class SyncQueueService {
  final AppDatabase database;

  SyncQueueService(this.database);

  /// Add operation to sync queue
  Future<void> enqueue({
    required String entityType,
    required String entityId,
    required String operation,
    required Map<String, dynamic> payload,
  }) async {
    final item = SyncQueueCompanion(
      id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(jsonEncode(payload)),
      status: const Value('pending'),
      retryCount: const Value(0),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );

    await database.addToSyncQueue(item);
  }

  /// Fetch all pending sync items
  Future<List<SyncQueueData>> getPendingItems() {
    return database.getPendingSyncItems();
  }

  /// Mark item syncing
  Future<void> markSyncing(String id) async {
    await database.updateSyncQueueStatus(
      id: id,
      status: 'syncing',
    );
  }

  /// Mark item synced
  Future<void> markSynced(String id) async {
    await database.updateSyncQueueStatus(
      id: id,
      status: 'synced',
    );
  }

  /// Mark item failed
  Future<void> markFailed(String id, String error) async {
    await database.updateSyncQueueStatus(
      id: id,
      status: 'failed',
      errorMessage: error,
    );

    await database.incrementSyncRetryCount(id);
  }
}