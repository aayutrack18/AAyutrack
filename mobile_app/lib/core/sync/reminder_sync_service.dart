import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../database/app_database.dart';
import '../../features/reminders/data/models/reminder_model.dart';
import 'sync_queue_service.dart';

class ReminderSyncService {
  final AppDatabase database;
  final SyncQueueService syncQueueService;
  final FirebaseFirestore firestore;

  bool _isSyncing = false;

  ReminderSyncService({
    required this.database,
    required this.syncQueueService,
    required this.firestore,
  });

  Future<void> enqueueUnsyncedReminders() async {
    final unsyncedReminders = await database.remindersDao.getUnsyncedReminders();

    for (final reminder in unsyncedReminders) {
      final model = ReminderModel.fromDb(reminder);

      await syncQueueService.enqueue(
        entityType: 'reminder',
        entityId: model.id,
        operation: model.isDeleted ? 'delete' : 'upsert',
        payload: model.isDeleted
            ? {
                'id': model.id,
                'patientId': model.patientId,
              }
            : model.toSyncPayload(),
      );
    }
  }

  Future<void> syncPendingReminderItems() async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      await syncQueueService.processQueueSequentiallyByEntityType(
        entityType: 'reminder',
        processor: (item) async {
          final payload = jsonDecode(item.payload) as Map<String, dynamic>;
          final docRef = firestore.collection('reminders').doc(item.entityId);

          switch (item.operation) {
            case 'upsert':
              await docRef.set(payload, SetOptions(merge: true));
              await database.remindersDao.updateReminderSyncStatus(
                id: item.entityId,
                isSynced: true,
              );
              break;

            case 'delete':
              await docRef.delete();
              break;

            default:
              throw UnsupportedError(
                'Unsupported reminder sync operation: ${item.operation}',
              );
          }
        },
      );
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> syncAll() async {
    await enqueueUnsyncedReminders();
    await syncPendingReminderItems();
  }
}