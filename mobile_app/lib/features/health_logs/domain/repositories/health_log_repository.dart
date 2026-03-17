import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';

abstract class HealthLogRepository {
  Future<List<HealthLog>> getLogs();
  Future<List<HealthLog>> getLogsByType(MetricType type);
  Future<HealthLog?> getLatestByType(MetricType type);
  Future<void> saveLog(HealthLog log);
  Future<void> updateLog(HealthLog log);
  Future<void> deleteLog(String id);
}