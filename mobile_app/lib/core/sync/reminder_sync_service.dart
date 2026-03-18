import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../database/app_database.dart';
import '../../features/reminders/data/models/reminder_model.dart';
import 'sync_queue_service.dart';

class ReminderSyncService {
  final AppDatabase database;
  final SyncQueueService syncQueueService;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  bool _isSyncing = false;

  ReminderSyncService({
    required this.database,
    required this.syncQueueService,
    required this.firestore,
    required this.auth,
  });

  String get _uid {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw Exception('User not authenticated');
    }
    return uid;
  }

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
              }
            : {
                ...model.toSyncPayload(),
                'patientId': _uid,
              },
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
          final operation = item.operation;

          final reminderId =
              (payload['id'] as String?)?.trim().isNotEmpty == true
                  ? (payload['id'] as String).trim()
                  : item.entityId;

          if (reminderId.isEmpty && operation != 'delete') {
            throw Exception('Reminder sync failed: missing reminder id');
          }

          final docRef = firestore
              .collection('users')
              .doc(_uid)
              .collection('reminders')
              .doc(reminderId);

          switch (operation) {
            case 'upsert':
              await docRef.set(
                {
                  ...payload,
                  'id': reminderId,
                  'patientId': _uid,
                  'updatedAt': DateTime.now().toIso8601String(),
                },
                SetOptions(merge: true),
              );

              await database.remindersDao.updateReminderSyncStatus(
                id: reminderId,
                isSynced: true,
              );
              break;

            case 'delete':
              await docRef.delete();
              break;

            default:
              throw UnsupportedError(
                'Unsupported reminder sync operation: $operation',
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