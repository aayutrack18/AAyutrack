import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/medicines.dart';

part 'medicines_dao.g.dart';

@DriftAccessor(tables: [Medicines])
class MedicinesDao extends DatabaseAccessor<AppDatabase>
    with _$MedicinesDaoMixin {
  MedicinesDao(AppDatabase db) : super(db);

  Future<void> upsertMedicine(MedicinesCompanion medicine) async {
    await into(medicines).insertOnConflictUpdate(medicine);
  }

  Future<List<Medicine>> getMedicinesByPatientId(String patientId) {
    return (select(medicines)
          ..where((tbl) =>
              tbl.patientId.equals(patientId) & tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .get();
  }

  Future<Medicine?> getMedicineById(String id) {
    return (select(medicines)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Medicine>> getUnsyncedMedicines() {
    return (select(medicines)
          ..where((tbl) =>
              tbl.isSynced.equals(false) & tbl.isDeleted.equals(false)))
        .get();
  }

  Future<bool> updateMedicineSyncStatus({
    required String id,
    required bool isSynced,
  }) async {
    final rows = await (update(medicines)..where((tbl) => tbl.id.equals(id)))
        .write(
      MedicinesCompanion(
        isSynced: Value(isSynced),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return rows > 0;
  }

  Future<bool> softDeleteMedicine(String id) async {
    final rows = await (update(medicines)..where((tbl) => tbl.id.equals(id)))
        .write(
      MedicinesCompanion(
        isDeleted: const Value(true),
        isSynced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return rows > 0;
  }

  Stream<List<Medicine>> watchMedicinesByPatientId(String patientId) {
    return (select(medicines)
          ..where((tbl) =>
              tbl.patientId.equals(patientId) & tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .watch();
  }
}