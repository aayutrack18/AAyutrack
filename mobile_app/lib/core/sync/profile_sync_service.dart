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

  Future<void> syncPendingProfileItems() async {
    final connected = await hasConnection();
    if (!connected) return;

    final pendingItems = await syncQueueService.getPendingItems();

    for (final item in pendingItems) {
      if (item.entityType != 'patient_profile') continue;

      try {
        await syncQueueService.markSyncing(item.id);

        final payload = jsonDecode(item.payload) as Map<String, dynamic>;
        final operation = item.operation;
        final profileId = item.entityId;

        if (operation == 'upsert') {
          await firestore.collection('patients').doc(profileId).set(payload);
          await database.updatePatientProfileSyncStatus(
            id: profileId,
            isSynced: true,
          );
        } else if (operation == 'delete') {
          await firestore.collection('patients').doc(profileId).delete();
        }

        await syncQueueService.markSynced(item.id);
      } catch (e) {
        await syncQueueService.markFailed(item.id, e.toString());
      }
    }
  }
}