import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../database/app_database.dart';
import 'sync_queue_service.dart';

class ProfileSyncService {
  final AppDatabase database;
  final SyncQueueService syncQueueService;
  final FirebaseFirestore firestore;
  final Connectivity connectivity;
  final FirebaseAuth auth;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isSyncing = false;

  ProfileSyncService({
    required this.database,
    required this.syncQueueService,
    required this.firestore,
    required this.connectivity,
    required this.auth,
  });

  String get _uid {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw Exception('User not authenticated');
    }
    return uid;
  }

  Future<bool> hasConnection() async {
    final results = await connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
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
      await syncQueueService.processQueueSequentiallyByEntityType(
        entityType: 'patient_profile',
        processor: (item) async {
          final payload = jsonDecode(item.payload) as Map<String, dynamic>;
          final operation = item.operation;

          final profileId =
              (payload['profileId'] as String?)?.trim().isNotEmpty == true
                  ? (payload['profileId'] as String).trim()
                  : item.entityId;

          if (profileId.isEmpty && operation != 'delete') {
            throw Exception('Profile sync failed: missing profileId');
          }

          final docRef = firestore
              .collection('users')
              .doc(_uid)
              .collection('profile')
              .doc('main');

          switch (operation) {
            case 'upsert':
              await docRef.set(
                {
                  ...payload,
                  'profileId': profileId,
                  'userId': _uid,
                  'updatedAt': DateTime.now().toIso8601String(),
                },
                SetOptions(merge: true),
              );

              await database.updatePatientProfileSyncStatus(
                id: profileId,
                isSynced: true,
              );
              break;

            case 'delete':
              await docRef.delete();
              break;

            default:
              throw UnsupportedError(
                'Unsupported sync operation: $operation for patient_profile',
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
}