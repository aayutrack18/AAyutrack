import 'package:aayutrack/features/reminders/domain/entities/reminder.dart';

abstract class ReminderRepository {
  Future<List<Reminder>> getReminders();
  Future<void> saveReminder(Reminder reminder);
  Future<void> updateReminder(Reminder reminder);
  Future<void> deleteReminder(String id);
  Future<void> toggleReminder(String id, bool isEnabled);
}