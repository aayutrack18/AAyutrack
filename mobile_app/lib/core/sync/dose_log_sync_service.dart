import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../database/app_database.dart';
import '../../features/compliance/data/models/dose_log_model.dart';
import 'sync_queue_service.dart';

class DoseLogSyncService {
  final AppDatabase database;
  final SyncQueueService syncQueueService;
  final FirebaseFirestore firestore;

  bool _isSyncing = false;

  DoseLogSyncService({
    required this.database,
    required this.syncQueueService,
    required this.firestore,
  });

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
                'patientId': model.patientId,
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
          final docRef = firestore.collection('dose_logs').doc(item.entityId);

          switch (item.operation) {
            case 'upsert':
              await docRef.set(payload, SetOptions(merge: true));
              await database.doseLogsDao.updateDoseLogSyncStatus(
                id: item.entityId,
                isSynced: true,
              );
              break;

            case 'delete':
              await docRef.delete();
              break;

            default:
              throw UnsupportedError(
                'Unsupported dose log sync operation: ${item.operation}',
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