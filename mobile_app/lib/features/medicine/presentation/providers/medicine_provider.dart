import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aayutrack/core/database/app_database.dart' as db;
import 'package:aayutrack/core/sync/sync_queue_service.dart';
import 'package:aayutrack/features/medicine/data/datasources/medicine_local_datasource.dart';
import 'package:aayutrack/features/medicine/data/repositories/medicine_repository_impl.dart';
import 'package:aayutrack/features/medicine/domain/entities/medicine.dart';
import 'package:aayutrack/features/medicine/domain/repositories/medicine_repository.dart';

// ─── INFRASTRUCTURE PROVIDERS ────────────────────────────────────────────────

final appDatabaseProvider = Provider<db.AppDatabase>((ref) {
  final database = db.AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final syncQueueServiceProvider = Provider<SyncQueueService>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return SyncQueueService(database);
});

final medicineLocalDataSourceProvider = Provider<MedicineLocalDataSource>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return MedicineLocalDataSource(
    medicinesDao: database.medicinesDao,
  );
});

final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  return MedicineRepositoryImpl(
    localDataSource: ref.watch(medicineLocalDataSourceProvider),
    syncQueueService: ref.watch(syncQueueServiceProvider),
  );
});

final medicineProvider =
    StateNotifierProvider<MedicineNotifier, MedicineState>((ref) {
  return MedicineNotifier(ref.watch(medicineRepositoryProvider));
});

// ─── STATE ───────────────────────────────────────────────────────────────────

class MedicineState {
  final bool isLoading;
  final List<Medicine> medicines;
  final String? errorMessage;

  const MedicineState({
    required this.isLoading,
    required this.medicines,
    this.errorMessage,
  });

  factory MedicineState.initial() => const MedicineState(
        isLoading: false,
        medicines: [],
      );

  MedicineState copyWith({
    bool? isLoading,
    List<Medicine>? medicines,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MedicineState(
      isLoading: isLoading ?? this.isLoading,
      medicines: medicines ?? this.medicines,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  List<Medicine> get activeMedicines =>
      medicines.where((m) => m.isActive).toList();

  List<Medicine> get inactiveMedicines =>
      medicines.where((m) => !m.isActive).toList();

  bool get hasError => errorMessage != null;
}

// ─── NOTIFIER ────────────────────────────────────────────────────────────────

class MedicineNotifier extends StateNotifier<MedicineState> {
  final MedicineRepository _repository;

  MedicineNotifier(this._repository) : super(MedicineState.initial()) {
    loadMedicines();
  }

  Future<void> loadMedicines() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final medicines = await _repository.getMedicines();
      state = state.copyWith(isLoading: false, medicines: medicines);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addMedicine(Medicine medicine) async {
    try {
      await _repository.saveMedicine(medicine);
      await loadMedicines();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> updateMedicine(Medicine medicine) async {
    try {
      await _repository.updateMedicine(medicine);
      await loadMedicines();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> deleteMedicine(String id) async {
    try {
      await _repository.deleteMedicine(id);
      await loadMedicines();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> toggleActive(String id, bool isActive) async {
    try {
      await _repository.toggleMedicineActive(id, isActive);
      await loadMedicines();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}