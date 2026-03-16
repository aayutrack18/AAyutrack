import 'package:drift/drift.dart';

class Medicines extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text()();

  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get dosage => text().nullable()();
  TextColumn get frequency => text().nullable()();
  TextColumn get scheduledTimes => text().nullable()(); // JSON string
  TextColumn get color => text().nullable()();

  TextColumn get unit => text().nullable()();
  TextColumn get form => text().nullable()();
  TextColumn get instructions => text().nullable()();

  IntColumn get stockCount => integer().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}