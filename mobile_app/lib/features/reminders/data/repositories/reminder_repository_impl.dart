import 'package:firebase_auth/firebase_auth.dart';
import 'package:aayutrack/core/services/notification_service.dart';
import 'package:aayutrack/core/sync/sync_queue_service.dart';
import 'package:aayutrack/features/reminders/data/datasources/reminder_local_datasource.dart';
import 'package:aayutrack/features/reminders/data/models/reminder_model.dart';
import 'package:aayutrack/features/reminders/domain/entities/reminder.dart';
import 'package:aayutrack/features/reminders/domain/repositories/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderLocalDataSource localDataSource;
  final SyncQueueService syncQueueService;
  final NotificationService notificationService;
  final FirebaseAuth auth;

  const ReminderRepositoryImpl({
    required this.localDataSource,
    required this.syncQueueService,
    required this.notificationService,
    required this.auth,
  });

  String get _uid {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw Exception('User not authenticated');
    }
    return uid;
  }

  @override
  Future<List<Reminder>> getReminders() async {
    final reminders = await localDataSource.getReminders(
      patientId: _uid,
    );

    // 🔥 FIX: remove deleted reminders
    return reminders.where((r) => !r.isDeleted).toList();
  }

  @override
  Future<void> saveReminder(Reminder reminder) async {
    final model = ReminderModel.fromEntity(
      reminder.copyWith(
        patientId: _uid,
        isSynced: false,
        isDeleted: false,
        updatedAt: DateTime.now(),
      ),
    );

    await localDataSource.saveReminder(model);
    await localDataSource.markReminderAsPendingSync(model.id);

    await syncQueueService.enqueue(
      entityType: 'reminder',
      entityId: model.id,
      operation: 'upsert',
      payload: model.toSyncPayload(),
    );

    // 🔥 ensure no duplicate scheduling
    await notificationService.cancelReminderNotifications(model.id);
    await notificationService.scheduleReminderNotifications(model);
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    final model = ReminderModel.fromEntity(
      reminder.copyWith(
        patientId: _uid,
        isSynced: false,
        isDeleted: false,
        updatedAt: DateTime.now(),
      ),
    );

    await localDataSource.updateReminder(model);
    await localDataSource.markReminderAsPendingSync(model.id);

    await syncQueueService.enqueue(
      entityType: 'reminder',
      entityId: model.id,
      operation: 'upsert',
      payload: model.toSyncPayload(),
    );

    // 🔥 CRITICAL FIX (prevents duplicate / wrong timing)
    await notificationService.cancelReminderNotifications(model.id);
    await notificationService.scheduleReminderNotifications(model);
  }

  @override
  Future<void> deleteReminder(String id) async {
    final existing = await localDataSource.getReminderById(id);
    if (existing == null) return;

    await localDataSource.deleteReminder(id);

    await syncQueueService.enqueue(
      entityType: 'reminder',
      entityId: id,
      operation: 'delete',
      payload: {
        'id': existing.id,
        'patientId': existing.patientId,
      },
    );

    await notificationService.cancelReminderNotifications(id);
  }

  @override
  Future<void> toggleReminder(String id, bool isEnabled) async {
    final existing = await localDataSource.getReminderById(id);
    if (existing == null) return;

    final updated = existing.copyWithModel(
      patientId: _uid,
      isEnabled: isEnabled,
      isSynced: false,
      updatedAt: DateTime.now(),
    );

    await localDataSource.updateReminder(updated);
    await localDataSource.markReminderAsPendingSync(id);

    await syncQueueService.enqueue(
      entityType: 'reminder',
      entityId: id,
      operation: 'upsert',
      payload: updated.toSyncPayload(),
    );

    // 🔥 FIX: handle toggle properly
    await notificationService.cancelReminderNotifications(id);

    if (isEnabled) {
      await notificationService.scheduleReminderNotifications(updated);
    }
  }
}