import 'package:aayutrack/core/database/daos/reminders_dao.dart';
import 'package:aayutrack/features/reminders/data/models/reminder_model.dart';

class ReminderLocalDataSource {
  final RemindersDao remindersDao;

  const ReminderLocalDataSource({
    required this.remindersDao,
  });

  Future<List<ReminderModel>> getReminders({
    required String patientId,
  }) async {
    final rows = await remindersDao.getRemindersByPatientId(patientId);
    return rows.map(ReminderModel.fromDb).toList();
  }

  Future<ReminderModel?> getReminderById(String id) async {
    final row = await remindersDao.getReminderById(id);
    if (row == null) return null;
    return ReminderModel.fromDb(row);
  }

  Future<void> saveReminder(ReminderModel reminder) async {
    await remindersDao.upsertReminder(reminder.toCompanion());
  }

  Future<void> updateReminder(ReminderModel reminder) async {
    await remindersDao.upsertReminder(reminder.toCompanion());
  }

  Future<void> deleteReminder(String id) async {
    await remindersDao.softDeleteReminder(id);
  }

  Future<void> toggleReminder(String id, bool isEnabled) async {
    final existing = await getReminderById(id);
    if (existing == null) return;

    final updated = existing.copyWithModel(
      isEnabled: isEnabled,
      isSynced: false,
      updatedAt: DateTime.now(),
    );

    await remindersDao.upsertReminder(updated.toCompanion());
  }

  Future<void> markReminderAsSynced(String id) async {
    await remindersDao.updateReminderSyncStatus(
      id: id,
      isSynced: true,
    );
  }

  Future<void> markReminderAsPendingSync(String id) async {
    await remindersDao.updateReminderSyncStatus(
      id: id,
      isSynced: false,
    );
  }
}