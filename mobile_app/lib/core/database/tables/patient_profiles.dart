import 'package:drift/drift.dart';

class PatientProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();

  TextColumn get fullName => text().withLength(min: 1, max: 100)();
  IntColumn get age => integer().nullable()();
  TextColumn get gender => text().nullable()();

  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();

  TextColumn get bloodGroup => text().nullable()();

  TextColumn get emergencyContactName => text().nullable()();
  TextColumn get emergencyContactPhone => text().nullable()();

  RealColumn get height => real().nullable()();
  RealColumn get weight => real().nullable()();

  TextColumn get chronicConditions => text().nullable()();
  TextColumn get allergies => text().nullable()();
  TextColumn get profileImagePath => text().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}