import 'package:aayutrack/features/medicine/domain/entities/medicine.dart';

class MedicineMockDataSource {
  final List<Medicine> _medicines = [
    Medicine(
      id: 'med_001',
      name: 'Metformin',
      dosage: '500mg',
      frequency: 'Twice Daily',
      form: 'Tablet',
      instructions: 'Take with meals to reduce stomach upset.',
      scheduledTimes: ['08:00', '20:00'],
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      isActive: true,
      color: '#1D4ED8',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Medicine(
      id: 'med_002',
      name: 'Amlodipine',
      dosage: '5mg',
      frequency: 'Once Daily',
      form: 'Tablet',
      instructions: 'Take at the same time each day.',
      scheduledTimes: ['09:00'],
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      isActive: true,
      color: '#14B8A6',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Medicine(
      id: 'med_003',
      name: 'Atorvastatin',
      dosage: '20mg',
      frequency: 'Once Daily',
      form: 'Tablet',
      instructions: 'Best taken in the evening. Avoid grapefruit.',
      scheduledTimes: ['21:00'],
      startDate: DateTime.now().subtract(const Duration(days: 90)),
      isActive: true,
      color: '#7C3AED',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Medicine(
      id: 'med_004',
      name: 'Vitamin D3',
      dosage: '1000 IU',
      frequency: 'Once Daily',
      form: 'Capsule',
      instructions: 'Take with a fat-containing meal for better absorption.',
      scheduledTimes: ['12:00'],
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      isActive: false,
      color: '#F59E0B',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  Future<List<Medicine>> getMedicines() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_medicines);
  }

  Future<Medicine?> getMedicineById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _medicines.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveMedicine(Medicine medicine) async {
    await Future.delayed(const Duration(milliseconds: 180));
    _medicines.add(medicine);
  }

  Future<void> updateMedicine(Medicine medicine) async {
    await Future.delayed(const Duration(milliseconds: 180));
    final idx = _medicines.indexWhere((m) => m.id == medicine.id);
    if (idx != -1) _medicines[idx] = medicine;
  }

  Future<void> deleteMedicine(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _medicines.removeWhere((m) => m.id == id);
  }

  Future<void> toggleMedicineActive(String id, bool isActive) async {
    await Future.delayed(const Duration(milliseconds: 120));
    final idx = _medicines.indexWhere((m) => m.id == id);
    if (idx != -1) {
      _medicines[idx] = _medicines[idx].copyWith(isActive: isActive);
    }
  }
}
