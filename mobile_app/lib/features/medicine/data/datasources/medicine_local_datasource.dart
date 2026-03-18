import 'package:aayutrack/core/database/daos/medicines_dao.dart';
import 'package:aayutrack/features/medicine/data/models/medicine_model.dart';

class MedicineLocalDataSource {
  final MedicinesDao medicinesDao;

  const MedicineLocalDataSource({
    required this.medicinesDao,
  });

  Future<List<MedicineModel>> getMedicines({
    required String patientId,
  }) async {
    final rows = await medicinesDao.getMedicinesByPatientId(patientId);
    return rows.map(MedicineModel.fromDb).toList();
  }

  Future<MedicineModel?> getMedicineById(String id) async {
    final row = await medicinesDao.getMedicineById(id);
    if (row == null) return null;
    return MedicineModel.fromDb(row);
  }

  Future<void> saveMedicine(MedicineModel medicine) async {
    await medicinesDao.upsertMedicine(medicine.toCompanion());
  }

  Future<void> updateMedicine(MedicineModel medicine) async {
    await medicinesDao.upsertMedicine(medicine.toCompanion());
  }

  Future<void> deleteMedicine(String id) async {
    await medicinesDao.softDeleteMedicine(id);
  }

  Future<void> markMedicineAsSynced(String id) async {
    await medicinesDao.updateMedicineSyncStatus(
      id: id,
      isSynced: true,
    );
  }

  Future<void> markMedicineAsPendingSync(String id) async {
    await medicinesDao.updateMedicineSyncStatus(
      id: id,
      isSynced: false,
    );
  }
}