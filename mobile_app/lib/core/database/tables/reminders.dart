import 'package:drift/drift.dart';

class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text()();
  TextColumn get medicineId => text().nullable()();

  TextColumn get title => text().withLength(min: 1, max: 150)();
  TextColumn get notes => text().nullable()();
  TextColumn get reminderType => text().withDefault(const Constant('custom'))();

  IntColumn get hour => integer()();
  IntColumn get minute => integer()();

  TextColumn get frequency => text().withDefault(const Constant('custom'))();
  TextColumn get daysOfWeek => text().nullable()();
  IntColumn get intervalDays => integer().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  DateTimeColumn get lastTriggeredAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}