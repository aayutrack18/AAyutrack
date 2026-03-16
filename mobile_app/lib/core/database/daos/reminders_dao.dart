import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/reminders.dart';

part 'reminders_dao.g.dart';

@DriftAccessor(tables: [Reminders])
class RemindersDao extends DatabaseAccessor<AppDatabase>
    with _$RemindersDaoMixin {
  RemindersDao(AppDatabase db) : super(db);

  Future<void> upsertReminder(RemindersCompanion reminder) async {
    await into(reminders).insertOnConflictUpdate(reminder);
  }

  Future<List<Reminder>> getRemindersByPatientId(String patientId) {
    return (select(reminders)
          ..where((tbl) =>
              tbl.patientId.equals(patientId) & tbl.isDeleted.equals(false))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.hour),
            (tbl) => OrderingTerm.asc(tbl.minute),
          ]))
        .get();
  }

  Future<List<Reminder>> getRemindersByMedicineId(String medicineId) {
    return (select(reminders)
          ..where((tbl) =>
              tbl.medicineId.equals(medicineId) & tbl.isDeleted.equals(false)))
        .get();
  }

  Future<Reminder?> getReminderById(String id) {
    return (select(reminders)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Reminder>> getUnsyncedReminders() {
    return (select(reminders)
          ..where((tbl) =>
              tbl.isSynced.equals(false) & tbl.isDeleted.equals(false)))
        .get();
  }

  Future<bool> updateReminderSyncStatus({
    required String id,
    required bool isSynced,
  }) async {
    final rows = await (update(reminders)..where((tbl) => tbl.id.equals(id)))
        .write(
      RemindersCompanion(
        isSynced: Value(isSynced),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return rows > 0;
  }

  Future<bool> softDeleteReminder(String id) async {
    final rows = await (update(reminders)..where((tbl) => tbl.id.equals(id)))
        .write(
      RemindersCompanion(
        isDeleted: const Value(true),
        isSynced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return rows > 0;
  }

  Stream<List<Reminder>> watchRemindersByPatientId(String patientId) {
    return (select(reminders)
          ..where((tbl) =>
              tbl.patientId.equals(patientId) & tbl.isDeleted.equals(false))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.hour),
            (tbl) => OrderingTerm.asc(tbl.minute),
          ]))
        .watch();
  }
}