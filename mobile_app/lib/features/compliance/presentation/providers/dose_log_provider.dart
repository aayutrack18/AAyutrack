import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aayutrack/core/sync/sync_providers.dart';
import 'package:aayutrack/features/compliance/data/datasources/dose_log_local_datasource.dart';
import 'package:aayutrack/features/compliance/data/repositories/dose_log_repository_impl.dart';
import 'package:aayutrack/features/compliance/domain/entities/dose_log.dart';
import 'package:aayutrack/features/compliance/domain/repositories/dose_log_repository.dart';

final doseLogLocalDataSourceProvider = Provider<DoseLogLocalDataSource>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return DoseLogLocalDataSource(
    doseLogsDao: database.doseLogsDao,
  );
});

final doseLogRepositoryProvider = Provider<DoseLogRepository>((ref) {
  return DoseLogRepositoryImpl(
    localDataSource: ref.watch(doseLogLocalDataSourceProvider),
    syncQueueService: ref.watch(syncQueueServiceProvider),
  );
});

final doseLogProvider =
    StateNotifierProvider<DoseLogNotifier, DoseLogState>((ref) {
  return DoseLogNotifier(ref.watch(doseLogRepositoryProvider));
});

class DoseLogState {
  final bool isLoading;
  final List<DoseLog> doseLogs;
  final String? errorMessage;

  const DoseLogState({
    required this.isLoading,
    required this.doseLogs,
    this.errorMessage,
  });

  factory DoseLogState.initial() =>
      const DoseLogState(isLoading: false, doseLogs: []);

  DoseLogState copyWith({
    bool? isLoading,
    List<DoseLog>? doseLogs,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DoseLogState(
      isLoading: isLoading ?? this.isLoading,
      doseLogs: doseLogs ?? this.doseLogs,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  List<DoseLog> get takenLogs => doseLogs.where((d) => d.isTaken).toList();
  List<DoseLog> get missedLogs => doseLogs.where((d) => d.isMissed).toList();
  List<DoseLog> get skippedLogs => doseLogs.where((d) => d.isSkipped).toList();
  List<DoseLog> get scheduledLogs => doseLogs.where((d) => d.isScheduled).toList();

  bool get hasError => errorMessage != null;
}

class DoseLogNotifier extends StateNotifier<DoseLogState> {
  final DoseLogRepository _repository;

  DoseLogNotifier(this._repository) : super(DoseLogState.initial()) {
    loadDoseLogs();
  }

  Future<void> loadDoseLogs() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final doseLogs = await _repository.getDoseLogs();
      state = state.copyWith(isLoading: false, doseLogs: doseLogs);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> loadDoseLogsByMedicineId(String medicineId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final doseLogs = await _repository.getDoseLogsByMedicineId(medicineId);
      state = state.copyWith(isLoading: false, doseLogs: doseLogs);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addDoseLog(DoseLog doseLog) async {
    try {
      await _repository.saveDoseLog(doseLog);
      await loadDoseLogs();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> updateDoseLog(DoseLog doseLog) async {
    try {
      await _repository.updateDoseLog(doseLog);
      await loadDoseLogs();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> deleteDoseLog(String id) async {
    try {
      await _repository.deleteDoseLog(id);
      await loadDoseLogs();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> markAsTaken({
    required String id,
    required DateTime takenAt,
    String? notes,
  }) async {
    try {
      await _repository.markAsTaken(
        id: id,
        takenAt: takenAt,
        notes: notes,
      );
      await loadDoseLogs();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> markAsMissed({
    required String id,
    String? notes,
  }) async {
    try {
      await _repository.markAsMissed(
        id: id,
        notes: notes,
      );
      await loadDoseLogs();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> markAsSkipped({
    required String id,
    String? notes,
  }) async {
    try {
      await _repository.markAsSkipped(
        id: id,
        notes: notes,
      );
      await loadDoseLogs();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}