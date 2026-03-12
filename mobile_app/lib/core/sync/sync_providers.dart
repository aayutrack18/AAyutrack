import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import 'profile_sync_service.dart';
import 'sync_queue_service.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final syncQueueServiceProvider = Provider<SyncQueueService>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return SyncQueueService(database);
});

final profileSyncServiceProvider = Provider<ProfileSyncService>((ref) {
  final database = ref.watch(appDatabaseProvider);
  final syncQueueService = ref.watch(syncQueueServiceProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);
  final connectivity = ref.watch(connectivityProvider);

  return ProfileSyncService(
    database: database,
    syncQueueService: syncQueueService,
    firestore: firestore,
    connectivity: connectivity,
  );
});