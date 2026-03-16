import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';

class HealthLogMockDataSource {
  final List<HealthLog> _logs = [
    // Blood Pressure entries
    HealthLog(id: 'hl_001', type: MetricType.bloodPressure, value: 128, secondaryValue: 82, notes: '', recordedAt: DateTime.now().subtract(const Duration(hours: 2)), source: 'manual'),
    HealthLog(id: 'hl_002', type: MetricType.bloodPressure, value: 132, secondaryValue: 85, notes: 'Slightly elevated after walk', recordedAt: DateTime.now().subtract(const Duration(days: 1)), source: 'manual'),
    HealthLog(id: 'hl_003', type: MetricType.bloodPressure, value: 125, secondaryValue: 80, notes: '', recordedAt: DateTime.now().subtract(const Duration(days: 2)), source: 'manual'),
    HealthLog(id: 'hl_004', type: MetricType.bloodPressure, value: 122, secondaryValue: 78, notes: 'Morning reading', recordedAt: DateTime.now().subtract(const Duration(days: 3)), source: 'manual'),

    // Blood Sugar entries
    HealthLog(id: 'hl_005', type: MetricType.bloodSugar, value: 96, notes: 'Fasting', recordedAt: DateTime.now().subtract(const Duration(hours: 3)), source: 'manual'),
    HealthLog(id: 'hl_006', type: MetricType.bloodSugar, value: 142, notes: 'Post lunch', recordedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)), source: 'manual'),
    HealthLog(id: 'hl_007', type: MetricType.bloodSugar, value: 102, notes: 'Fasting', recordedAt: DateTime.now().subtract(const Duration(days: 2)), source: 'manual'),

    // Heart Rate
    HealthLog(id: 'hl_008', type: MetricType.heartRate, value: 72, notes: '', recordedAt: DateTime.now().subtract(const Duration(hours: 1)), source: 'wearable'),
    HealthLog(id: 'hl_009', type: MetricType.heartRate, value: 88, notes: 'After exercise', recordedAt: DateTime.now().subtract(const Duration(days: 1)), source: 'wearable'),

    // Weight
    HealthLog(id: 'hl_010', type: MetricType.weight, value: 72.5, notes: '', recordedAt: DateTime.now().subtract(const Duration(days: 1)), source: 'manual'),
    HealthLog(id: 'hl_011', type: MetricType.weight, value: 72.8, notes: '', recordedAt: DateTime.now().subtract(const Duration(days: 4)), source: 'manual'),

    // Oxygen
    HealthLog(id: 'hl_012', type: MetricType.oxygen, value: 98, notes: '', recordedAt: DateTime.now().subtract(const Duration(hours: 4)), source: 'wearable'),
    
    // Temperature
    HealthLog(id: 'hl_013', type: MetricType.temperature, value: 36.6, notes: '', recordedAt: DateTime.now().subtract(const Duration(days: 1)), source: 'manual'),

    // Mood
    HealthLog(id: 'hl_014', type: MetricType.mood, value: 4, notes: 'Feeling good today, energy levels normal', recordedAt: DateTime.now().subtract(const Duration(hours: 5)), source: 'manual'),
  ];

  Future<List<HealthLog>> getLogs() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final sorted = List<HealthLog>.from(_logs)
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    return sorted;
  }

  Future<List<HealthLog>> getLogsByType(MetricType type) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _logs
        .where((l) => l.type == type)
        .toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  Future<HealthLog?> getLatestByType(MetricType type) async {
    final logs = await getLogsByType(type);
    return logs.isNotEmpty ? logs.first : null;
  }

  Future<void> saveLog(HealthLog log) async {
    await Future.delayed(const Duration(milliseconds: 160));
    _logs.add(log);
  }

  Future<void> deleteLog(String id) async {
    await Future.delayed(const Duration(milliseconds: 130));
    _logs.removeWhere((l) => l.id == id);
  }

  Future<void> updateLog(HealthLog log) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final idx = _logs.indexWhere((l) => l.id == log.id);
    if (idx != -1) _logs[idx] = log;
  }
}
