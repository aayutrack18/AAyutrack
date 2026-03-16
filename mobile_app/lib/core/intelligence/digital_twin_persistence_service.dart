import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import 'digital_twin_model.dart';

class DigitalTwinPersistenceService {
  final AppDatabase database;
  static const _uuid = Uuid();

  const DigitalTwinPersistenceService({
    required this.database,
  });

  Future<void> saveDigitalTwinSnapshot(DigitalTwinModel model) async {
    final snapshot = IntelligenceSnapshotsCompanion.insert(
      id: _uuid.v4(),
      patientId: model.patientId,
      snapshotType: 'digital_twin',
      riskLevel: Value(model.riskLevel),
      complianceScore: Value(model.overallCompliance.complianceScore),
      payloadJson: model.toJsonString(),
      generatedAt: model.generatedAt,
      createdAt: DateTime.now(),
    );

    await database.insertIntelligenceSnapshot(snapshot);
  }

  Future<DigitalTwinModel?> getLatestDigitalTwinSnapshot(
    String patientId,
  ) async {
    final snapshot = await database.getLatestIntelligenceSnapshot(
      patientId,
      snapshotType: 'digital_twin',
    );

    if (snapshot == null) return null;

    return DigitalTwinModel.fromJsonString(snapshot.payloadJson);
  }

  Future<List<DigitalTwinModel>> getDigitalTwinHistory(
    String patientId, {
    int limit = 30,
  }) async {
    final snapshots = await database.getIntelligenceSnapshotsByPatientId(
      patientId,
      snapshotType: 'digital_twin',
      limit: limit,
    );

    return snapshots
        .map(
          (snapshot) => DigitalTwinModel.fromJsonString(snapshot.payloadJson),
        )
        .toList();
  }

  Future<int> pruneOldSnapshots(
    String patientId, {
    Duration maxAge = const Duration(days: 30),
  }) async {
    return database.deleteOldIntelligenceSnapshots(
      patientId,
      olderThan: DateTime.now().subtract(maxAge),
    );
  }
}