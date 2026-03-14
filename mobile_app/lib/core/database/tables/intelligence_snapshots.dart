import 'package:drift/drift.dart';

class IntelligenceSnapshots extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text()();
  TextColumn get snapshotType => text()(); // digital_twin, compliance, risk
  TextColumn get riskLevel => text().nullable()();
  RealColumn get complianceScore => real().nullable()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get generatedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}