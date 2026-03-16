import 'package:aayutrack/core/sync/dose_log_sync_service.dart';
import 'package:aayutrack/core/sync/medicine_sync_service.dart';
import 'package:aayutrack/core/sync/profile_sync_service.dart';
import 'package:aayutrack/core/sync/reminder_sync_service.dart';
import 'package:aayutrack/core/sync/sync_queue_service.dart';

class SyncStatusService {
  final SyncQueueService syncQueueService;
  final ProfileSyncService profileSyncService;
  final MedicineSyncService medicineSyncService;
  final ReminderSyncService reminderSyncService;
  final DoseLogSyncService doseLogSyncService;

  const SyncStatusService({
    required this.syncQueueService,
    required this.profileSyncService,
    required this.medicineSyncService,
    required this.reminderSyncService,
    required this.doseLogSyncService,
  });

  Future<SyncStatusSnapshot> getQueueStats() async {
    return syncQueueService.getStatusSnapshot();
  }

  Future<void> syncNow() async {
    await medicineSyncService.syncAll();
    await reminderSyncService.syncAll();
    await doseLogSyncService.syncAll();
    await profileSyncService.syncPendingItems();
  }

  Future<void> retryFailed() async {
    await syncQueueService.retryFailedItems();
    await syncNow();
  }

  Future<int> clearSyncedQueueItems() async {
    return syncQueueService.clearSyncedItems();
  }
}