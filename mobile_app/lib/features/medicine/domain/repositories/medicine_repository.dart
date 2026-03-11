import '../entities/medicine.dart';

abstract class MedicineRepository {
  Future<List<Medicine>> getMedicines();
  Future<Medicine?> getMedicineById(String id);
  Future<void> saveMedicine(Medicine medicine);
  Future<void> updateMedicine(Medicine medicine);
  Future<void> deleteMedicine(String id);
  Future<void> toggleMedicineActive(String id, bool isActive);
}
