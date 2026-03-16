import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../database/app_database.dart';
import '../../features/medicine/data/models/medicine_model.dart';
import 'sync_queue_service.dart';

class MedicineSyncService {
  final AppDatabase database;
  final SyncQueueService syncQueueService;
  final FirebaseFirestore firestore;

  bool _isSyncing = false;

  MedicineSyncService({
    required this.database,
    required this.syncQueueService,
    required this.firestore,
  });

  Future<void> enqueueUnsyncedMedicines() async {
    final unsyncedMedicines = await database.medicinesDao.getUnsyncedMedicines();

    for (final medicine in unsyncedMedicines) {
      final model = MedicineModel.fromDb(medicine);

      await syncQueueService.enqueue(
        entityType: 'medicine',
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

  Future<void> syncPendingMedicineItems() async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      await syncQueueService.processQueueSequentiallyByEntityType(
        entityType: 'medicine',
        processor: (item) async {
          final payload = jsonDecode(item.payload) as Map<String, dynamic>;
          final docRef = firestore.collection('medicines').doc(item.entityId);

          switch (item.operation) {
            case 'upsert':
              await docRef.set(payload, SetOptions(merge: true));
              await database.medicinesDao.updateMedicineSyncStatus(
                id: item.entityId,
                isSynced: true,
              );
              break;

            case 'delete':
              await docRef.delete();
              break;

            default:
              throw UnsupportedError(
                'Unsupported medicine sync operation: ${item.operation}',
              );
          }
        },
      );
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> syncAll() async {
    await enqueueUnsyncedMedicines();
    await syncPendingMedicineItems();
  }
}