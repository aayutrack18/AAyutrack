import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aayutrack/core/sync/sync_providers.dart';
import 'package:aayutrack/features/health_logs/data/datasources/health_log_local_datasource.dart';
import 'package:aayutrack/features/health_logs/data/repositories/health_log_repository_impl.dart';
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';
import 'package:aayutrack/features/health_logs/domain/repositories/health_log_repository.dart';

final healthLogLocalDataSourceProvider = Provider<HealthLogLocalDataSource>((
  ref,
) {
  final database = ref.watch(appDatabaseProvider);
  return HealthLogLocalDataSource(
    healthLogsDao: database.healthLogsDao,
  );
});

final healthLogRepositoryProvider = Provider<HealthLogRepository>((ref) {
  return HealthLogRepositoryImpl(
    localDataSource: ref.watch(healthLogLocalDataSourceProvider),
    syncQueueService: ref.watch(syncQueueServiceProvider),
  );
});

final healthLogProvider =
    StateNotifierProvider<HealthLogNotifier, HealthLogState>((ref) {
  return HealthLogNotifier(ref.watch(healthLogRepositoryProvider));
});

class HealthLogState {
  final bool isLoading;
  final List<HealthLog> logs;
  final String? errorMessage;

  const HealthLogState({
    required this.isLoading,
    required this.logs,
    this.errorMessage,
  });

  factory HealthLogState.initial() =>
      const HealthLogState(isLoading: false, logs: []);

  HealthLogState copyWith({
    bool? isLoading,
    List<HealthLog>? logs,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HealthLogState(
      isLoading: isLoading ?? this.isLoading,
      logs: logs ?? this.logs,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  List<HealthLog> logsOfType(MetricType type) =>
      logs.where((l) => l.type == type).toList();

  HealthLog? latestOfType(MetricType type) {
    final byType = logsOfType(type);
    return byType.isNotEmpty ? byType.first : null;
  }

  Map<MetricType, HealthLog?> get latestByMetric {
    return {
      for (final t in MetricType.values) t: latestOfType(t),
    };
  }

  bool get hasError => errorMessage != null;
}

class HealthLogNotifier extends StateNotifier<HealthLogState> {
  final HealthLogRepository _repository;

  HealthLogNotifier(this._repository) : super(HealthLogState.initial()) {
    loadLogs();
  }

  Future<void> loadLogs() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final logs = await _repository.getLogs();
      state = state.copyWith(isLoading: false, logs: logs);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addLog(HealthLog log) async {
    try {
      await _repository.saveLog(log);
      await loadLogs();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> deleteLog(String id) async {
    try {
      await _repository.deleteLog(id);
      await loadLogs();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> updateLog(HealthLog log) async {
    try {
      await _repository.updateLog(log);
      await loadLogs();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> reload() => loadLogs();
}