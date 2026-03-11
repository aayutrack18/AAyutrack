import '../../domain/entities/medicine.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../datasources/medicine_mock_datasource.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineMockDataSource _dataSource;

  MedicineRepositoryImpl(this._dataSource);

  @override
  Future<List<Medicine>> getMedicines() => _dataSource.getMedicines();

  @override
  Future<Medicine?> getMedicineById(String id) =>
      _dataSource.getMedicineById(id);

  @override
  Future<void> saveMedicine(Medicine medicine) =>
      _dataSource.saveMedicine(medicine);

  @override
  Future<void> updateMedicine(Medicine medicine) =>
      _dataSource.updateMedicine(medicine);

  @override
  Future<void> deleteMedicine(String id) => _dataSource.deleteMedicine(id);

  @override
  Future<void> toggleMedicineActive(String id, bool isActive) =>
      _dataSource.toggleMedicineActive(id, isActive);
}
