import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

class SyncQueueService {
  final AppDatabase database;
  static const _uuid = Uuid();

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

  Future<void> markFailed(String id, String error) async {
    await database.incrementSyncRetryCount(id);
    await database.updateSyncQueueStatus(
      id: id,
      status: 'failed',
      errorMessage: error,
    );
  }
}