import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/features/health_logs/data/datasources/health_log_mock_datasource.dart';
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';

final healthLogDataSourceProvider = Provider<HealthLogMockDataSource>((ref) {
  return HealthLogMockDataSource();
});

final healthLogProvider =
    StateNotifierProvider<HealthLogNotifier, HealthLogState>((ref) {
  return HealthLogNotifier(ref.watch(healthLogDataSourceProvider));
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
  final HealthLogMockDataSource _ds;

  HealthLogNotifier(this._ds) : super(HealthLogState.initial()) {
    loadLogs();
  }

  Future<void> loadLogs() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final logs = await _ds.getLogs();
      state = state.copyWith(isLoading: false, logs: logs);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addLog(HealthLog log) async {
    try {
      await _ds.saveLog(log);
      await loadLogs();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> deleteLog(String id) async {
    try {
      await _ds.deleteLog(id);
      await loadLogs();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> updateLog(HealthLog log) async {
    try {
      await _ds.updateLog(log);
      await loadLogs();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}
