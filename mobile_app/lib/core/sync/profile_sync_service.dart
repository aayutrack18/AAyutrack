import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../database/app_database.dart';
import 'sync_queue_service.dart';

class ProfileSyncService {
  final AppDatabase database;
  final SyncQueueService syncQueueService;
  final FirebaseFirestore firestore;
  final Connectivity connectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isSyncing = false;

  ProfileSyncService({
    required this.database,
    required this.syncQueueService,
    required this.firestore,
    required this.connectivity,
  });

  Future<bool> hasConnection() async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  void startAutoSync() {
    _connectivitySubscription ??=
        connectivity.onConnectivityChanged.listen((results) async {
      final isConnected = !results.contains(ConnectivityResult.none);

      if (isConnected) {
        await syncPendingItems();
      }
    });
  }

  Future<void> stopAutoSync() async {
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  Future<void> syncPendingProfileItems() async {
    await syncPendingItems();
  }

  Future<void> syncPendingItems() async {
    if (_isSyncing) return;

    final connected = await hasConnection();
    if (!connected) return;

    _isSyncing = true;

    try {
      await syncQueueService.processQueueSequentially(
        processor: (item) async {
          final payload = jsonDecode(item.payload) as Map<String, dynamic>;
          final operation = item.operation;
          final entityType = item.entityType;
          final entityId = item.entityId;

          final collectionName = _collectionForEntityType(entityType);
          final docRef = firestore.collection(collectionName).doc(entityId);

          switch (operation) {
            case 'upsert':
              await docRef.set(payload, SetOptions(merge: true));
              await _markEntityAsSynced(
                entityType: entityType,
                entityId: entityId,
              );
              break;

            case 'delete':
              await docRef.delete();
              break;

            default:
              throw UnsupportedError(
                'Unsupported sync operation: $operation for $entityType',
              );
          }
        },
      );
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> triggerSyncOnAppStart() async {
    await syncPendingItems();
  }

  String _collectionForEntityType(String entityType) {
    switch (entityType) {
      case 'patient_profile':
        return 'patients';
      case 'medicine':
        return 'medicines';
      case 'reminder':
        return 'reminders';
      case 'dose_log':
        return 'dose_logs';
      default:
        throw UnsupportedError('Unknown entityType: $entityType');
    }
  }

  Future<void> _markEntityAsSynced({
    required String entityType,
    required String entityId,
  }) async {
    switch (entityType) {
      case 'patient_profile':
        await database.updatePatientProfileSyncStatus(
          id: entityId,
          isSynced: true,
        );
        break;

      case 'medicine':
        await database.medicinesDao.updateMedicineSyncStatus(
          id: entityId,
          isSynced: true,
        );
        break;

      case 'reminder':
        await database.remindersDao.updateReminderSyncStatus(
          id: entityId,
          isSynced: true,
        );
        break;

      case 'dose_log':
        await database.doseLogsDao.updateDoseLogSyncStatus(
          id: entityId,
          isSynced: true,
        );
        break;

      default:
        throw UnsupportedError('Unknown entityType: $entityType');
    }
  }
}