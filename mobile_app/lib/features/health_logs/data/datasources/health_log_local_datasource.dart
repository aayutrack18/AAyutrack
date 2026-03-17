import 'package:aayutrack/core/database/daos/health_logs_dao.dart';
import 'package:aayutrack/features/health_logs/data/models/health_log_model.dart';
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';

class HealthLogLocalDataSource {
  final HealthLogsDao healthLogsDao;

  const HealthLogLocalDataSource({
    required this.healthLogsDao,
  });

  Future<List<HealthLogModel>> getLogs({
    String patientId = 'default_patient',
  }) async {
    final rows = await healthLogsDao.getHealthLogsByPatientId(patientId);
    return rows.map(HealthLogModel.fromDb).toList();
  }

  Future<List<HealthLogModel>> getLogsByType(
    MetricType type, {
    String patientId = 'default_patient',
  }) async {
    final rows = await healthLogsDao.getHealthLogsByType(
      patientId: patientId,
      metricType: _metricTypeToDb(type),
    );
    return rows.map(HealthLogModel.fromDb).toList();
  }

  Future<HealthLogModel?> getHealthLogById(String id) async {
    final row = await healthLogsDao.getHealthLogById(id);
    if (row == null) return null;
    return HealthLogModel.fromDb(row);
  }

  Future<HealthLogModel?> getLatestByType(
    MetricType type, {
    String patientId = 'default_patient',
  }) async {
    final row = await healthLogsDao.getLatestHealthLogByType(
      patientId: patientId,
      metricType: _metricTypeToDb(type),
    );
    if (row == null) return null;
    return HealthLogModel.fromDb(row);
  }

  Future<void> saveLog(HealthLogModel log) async {
    await healthLogsDao.upsertHealthLog(log.toCompanion());
  }

  Future<void> updateLog(HealthLogModel log) async {
    await healthLogsDao.upsertHealthLog(log.toCompanion());
  }

  Future<void> deleteLog(String id) async {
    await healthLogsDao.softDeleteHealthLog(id);
  }

  Future<void> markHealthLogAsSynced(String id) async {
    await healthLogsDao.updateHealthLogSyncStatus(
      id: id,
      isSynced: true,
    );
  }

  Future<void> markHealthLogAsPendingSync(String id) async {
    await healthLogsDao.updateHealthLogSyncStatus(
      id: id,
      isSynced: false,
    );
  }

  String _metricTypeToDb(MetricType type) {
    switch (type) {
      case MetricType.bloodPressure:
        return 'bloodPressure';
      case MetricType.bloodSugar:
        return 'bloodSugar';
      case MetricType.heartRate:
        return 'heartRate';
      case MetricType.weight:
        return 'weight';
      case MetricType.oxygen:
        return 'oxygen';
      case MetricType.temperature:
        return 'temperature';
      case MetricType.mood:
        return 'mood';
    }
  }
}