import 'package:aayutrack/core/sync/sync_queue_service.dart';
import 'package:aayutrack/features/health_logs/data/datasources/health_log_local_datasource.dart';
import 'package:aayutrack/features/health_logs/data/models/health_log_model.dart';
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';
import 'package:aayutrack/features/health_logs/domain/repositories/health_log_repository.dart';

class HealthLogRepositoryImpl implements HealthLogRepository {
  final HealthLogLocalDataSource localDataSource;
  final SyncQueueService syncQueueService;

  const HealthLogRepositoryImpl({
    required this.localDataSource,
    required this.syncQueueService,
  });

  @override
  Future<List<HealthLog>> getLogs() async {
    return localDataSource.getLogs();
  }

  @override
  Future<List<HealthLog>> getLogsByType(MetricType type) async {
    return localDataSource.getLogsByType(type);
  }

  @override
  Future<HealthLog?> getLatestByType(MetricType type) async {
    return localDataSource.getLatestByType(type);
  }

  @override
  Future<void> saveLog(HealthLog log) async {
    final now = DateTime.now();

    final model = HealthLogModel.fromEntity(
      log,
      isSynced: false,
      isDeleted: false,
      createdAt: now,
      updatedAt: now,
    );

    await localDataSource.saveLog(model);
    await localDataSource.markHealthLogAsPendingSync(model.id);

    await syncQueueService.enqueue(
      entityType: 'health_log',
      entityId: model.id,
      operation: 'upsert',
      payload: model.toSyncPayload(),
    );
  }

  @override
  Future<void> updateLog(HealthLog log) async {
    final existing = await localDataSource.getHealthLogById(log.id);

    final model = HealthLogModel.fromEntity(
      log,
      patientId: existing?.patientId ?? 'default_patient',
      isSynced: false,
      isDeleted: false,
      createdAt: existing?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await localDataSource.updateLog(model);
    await localDataSource.markHealthLogAsPendingSync(model.id);

    await syncQueueService.enqueue(
      entityType: 'health_log',
      entityId: model.id,
      operation: 'upsert',
      payload: model.toSyncPayload(),
    );
  }

  @override
  Future<void> deleteLog(String id) async {
    final existing = await localDataSource.getHealthLogById(id);
    if (existing == null) return;

    await localDataSource.deleteLog(id);
    await localDataSource.markHealthLogAsPendingSync(id);

    await syncQueueService.enqueue(
      entityType: 'health_log',
      entityId: id,
      operation: 'delete',
      payload: {
        'id': existing.id,
        'patientId': existing.patientId,
        'metricType': existing.type.name,
      },
    );
  }
}