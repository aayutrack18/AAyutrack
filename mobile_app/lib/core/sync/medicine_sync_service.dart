import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../database/app_database.dart';
import '../../features/medicine/data/models/medicine_model.dart';
import 'sync_queue_service.dart';

class MedicineSyncService {
  final AppDatabase database;
  final SyncQueueService syncQueueService;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  bool _isSyncing = false;

  MedicineSyncService({
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
              }
            : {
                ...model.toSyncPayload(),
                'patientId': _uid,
              },
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
          final operation = item.operation;

          final medicineId =
              (payload['id'] as String?)?.trim().isNotEmpty == true
                  ? (payload['id'] as String).trim()
                  : item.entityId;

          if (medicineId.isEmpty && operation != 'delete') {
            throw Exception('Medicine sync failed: missing medicine id');
          }

          final docRef = firestore
              .collection('users')
              .doc(_uid)
              .collection('medicines')
              .doc(medicineId);

          switch (operation) {
            case 'upsert':
              await docRef.set(
                {
                  ...payload,
                  'id': medicineId,
                  'patientId': _uid,
                  'updatedAt': DateTime.now().toIso8601String(),
                },
                SetOptions(merge: true),
              );

              await database.medicinesDao.updateMedicineSyncStatus(
                id: medicineId,
                isSynced: true,
              );
              break;

            case 'delete':
              await docRef.delete();
              break;

            default:
              throw UnsupportedError(
                'Unsupported medicine sync operation: $operation',
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