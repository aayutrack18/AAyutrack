import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../database/app_database.dart';
import '../../features/compliance/data/models/dose_log_model.dart';
import 'sync_queue_service.dart';

class DoseLogSyncService {
  final AppDatabase database;
  final SyncQueueService syncQueueService;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  bool _isSyncing = false;

  DoseLogSyncService({
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

  Future<void> enqueueUnsyncedDoseLogs() async {
    final unsyncedDoseLogs = await database.doseLogsDao.getUnsyncedDoseLogs();

    for (final doseLog in unsyncedDoseLogs) {
      final model = DoseLogModel.fromDb(doseLog);

      await syncQueueService.enqueue(
        entityType: 'dose_log',
        entityId: model.id,
        operation: model.isDeleted ? 'delete' : 'upsert',
        payload: model.isDeleted
            ? {
                'id': model.id,
              }
            : model.toSyncPayload(),
      );
    }
  }

  Future<void> syncPendingDoseLogItems() async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      await syncQueueService.processQueueSequentiallyByEntityType(
        entityType: 'dose_log',
        processor: (item) async {
          final payload = jsonDecode(item.payload) as Map<String, dynamic>;
          final operation = item.operation;

          final doseLogId =
              (payload['id'] as String?)?.trim().isNotEmpty == true
                  ? (payload['id'] as String).trim()
                  : item.entityId;

          if (doseLogId.isEmpty && operation != 'delete') {
            throw Exception('Dose log sync failed: missing id');
          }

          final docRef = firestore
              .collection('users')
              .doc(_uid)
              .collection('doseLogs')
              .doc(doseLogId);

          switch (operation) {
            case 'upsert':
              await docRef.set(
                {
                  ...payload,
                  'id': doseLogId,
                  'patientId': _uid,
                  'updatedAt': DateTime.now().toIso8601String(),
                },
                SetOptions(merge: true),
              );

              await database.doseLogsDao.updateDoseLogSyncStatus(
                id: doseLogId,
                isSynced: true,
              );
              break;

            case 'delete':
              await docRef.delete();
              break;

            default:
              throw UnsupportedError(
                'Unsupported operation: $operation',
              );
          }
        },
      );
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> syncAll() async {
    await enqueueUnsyncedDoseLogs();
    await syncPendingDoseLogItems();
  }
}