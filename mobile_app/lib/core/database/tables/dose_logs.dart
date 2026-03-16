import 'package:drift/drift.dart';

class DoseLogs extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text()();
  TextColumn get medicineId => text()();
  TextColumn get reminderId => text().nullable()();

  DateTimeColumn get scheduledAt => dateTime()();
  DateTimeColumn get takenAt => dateTime().nullable()();

  TextColumn get status => text()();
  // expected values:
  // scheduled
  // taken
  // missed
  // skipped

  TextColumn get notes => text().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}