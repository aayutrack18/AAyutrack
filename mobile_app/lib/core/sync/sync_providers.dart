import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import 'dose_log_sync_service.dart';
import 'medicine_sync_service.dart';
import 'profile_sync_service.dart';
import 'reminder_sync_service.dart';
import 'sync_queue_service.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final syncQueueServiceProvider = Provider<SyncQueueService>((ref) {
  return SyncQueueService(ref.watch(appDatabaseProvider));
});

final profileSyncServiceProvider = Provider<ProfileSyncService>((ref) {
  return ProfileSyncService(
    database: ref.watch(appDatabaseProvider),
    syncQueueService: ref.watch(syncQueueServiceProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    connectivity: ref.watch(connectivityProvider),
  );
});

final medicineSyncServiceProvider = Provider<MedicineSyncService>((ref) {
  return MedicineSyncService(
    database: ref.watch(appDatabaseProvider),
    syncQueueService: ref.watch(syncQueueServiceProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
  );
});

final reminderSyncServiceProvider = Provider<ReminderSyncService>((ref) {
  return ReminderSyncService(
    database: ref.watch(appDatabaseProvider),
    syncQueueService: ref.watch(syncQueueServiceProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
  );
});

final doseLogSyncServiceProvider = Provider<DoseLogSyncService>((ref) {
  return DoseLogSyncService(
    database: ref.watch(appDatabaseProvider),
    syncQueueService: ref.watch(syncQueueServiceProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
  );
});

final appStartupSyncProvider = Provider<Future<void>>((ref) async {
  final profileSyncService = ref.watch(profileSyncServiceProvider);
  final medicineSyncService = ref.watch(medicineSyncServiceProvider);
  final reminderSyncService = ref.watch(reminderSyncServiceProvider);
  final doseLogSyncService = ref.watch(doseLogSyncServiceProvider);

  profileSyncService.startAutoSync();

  await medicineSyncService.syncAll();
  await reminderSyncService.syncAll();
  await doseLogSyncService.syncAll();
  await profileSyncService.triggerSyncOnAppStart();
});