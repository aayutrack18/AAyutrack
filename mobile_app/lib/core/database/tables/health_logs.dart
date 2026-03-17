import 'package:drift/drift.dart';

class HealthLogs extends Table {
  TextColumn get id => text()();

  TextColumn get patientId => text()();

  TextColumn get metricType => text()();
  // expected values:
  // bloodPressure
  // bloodSugar
  // heartRate
  // weight
  // oxygen
  // temperature
  // mood

  RealColumn get value => real()();
  RealColumn get secondaryValue => real().nullable()();

  TextColumn get notes => text().nullable()();
  TextColumn get source => text()();
  // expected values:
  // manual
  // wearable

  DateTimeColumn get recordedAt => dateTime()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}