import 'package:aayutrack/core/sync/sync_queue_service.dart';
import 'package:aayutrack/features/compliance/data/datasources/dose_log_local_datasource.dart';
import 'package:aayutrack/features/compliance/data/models/dose_log_model.dart';
import 'package:aayutrack/features/compliance/domain/entities/dose_log.dart';
import 'package:aayutrack/features/compliance/domain/repositories/dose_log_repository.dart';

class DoseLogRepositoryImpl implements DoseLogRepository {
  final DoseLogLocalDataSource localDataSource;
  final SyncQueueService syncQueueService;

  const DoseLogRepositoryImpl({
    required this.localDataSource,
    required this.syncQueueService,
  });

  @override
  Future<List<DoseLog>> getDoseLogs() async {
    final doseLogs = await localDataSource.getDoseLogs();
    return doseLogs;
  }

  @override
  Future<List<DoseLog>> getDoseLogsByMedicineId(String medicineId) async {
    final doseLogs = await localDataSource.getDoseLogsByMedicineId(medicineId);
    return doseLogs;
  }

  @override
  Future<void> saveDoseLog(DoseLog doseLog) async {
    final model = DoseLogModel.fromEntity(
      doseLog.copyWith(
        isSynced: false,
        isDeleted: false,
        updatedAt: DateTime.now(),
      ),
    );

    await localDataSource.saveDoseLog(model);
    await localDataSource.markDoseLogAsPendingSync(model.id);

    await syncQueueService.enqueue(
      entityType: 'dose_log',
      entityId: model.id,
      operation: 'upsert',
      payload: model.toSyncPayload(),
    );
  }

  @override
  Future<void> updateDoseLog(DoseLog doseLog) async {
    final model = DoseLogModel.fromEntity(
      doseLog.copyWith(
        isSynced: false,
        updatedAt: DateTime.now(),
      ),
    );

    await localDataSource.updateDoseLog(model);
    await localDataSource.markDoseLogAsPendingSync(model.id);

    await syncQueueService.enqueue(
      entityType: 'dose_log',
      entityId: model.id,
      operation: 'upsert',
      payload: model.toSyncPayload(),
    );
  }

  @override
  Future<void> deleteDoseLog(String id) async {
    final existing = await localDataSource.getDoseLogById(id);
    if (existing == null) return;

    await localDataSource.deleteDoseLog(id);

    await syncQueueService.enqueue(
      entityType: 'dose_log',
      entityId: id,
      operation: 'delete',
      payload: {
        'id': existing.id,
        'patientId': existing.patientId,
      },
    );
  }

  @override
  Future<void> markAsTaken({
    required String id,
    required DateTime takenAt,
    String? notes,
  }) async {
    final existing = await localDataSource.getDoseLogById(id);
    if (existing == null) return;

    final updated = existing.copyWithModel(
      takenAt: takenAt,
      status: 'taken',
      notes: notes ?? existing.notes,
      isSynced: false,
      updatedAt: DateTime.now(),
    );

    await localDataSource.updateDoseLog(updated);
    await localDataSource.markDoseLogAsPendingSync(id);

    await syncQueueService.enqueue(
      entityType: 'dose_log',
      entityId: id,
      operation: 'upsert',
      payload: updated.toSyncPayload(),
    );
  }

  @override
  Future<void> markAsMissed({
    required String id,
    String? notes,
  }) async {
    final existing = await localDataSource.getDoseLogById(id);
    if (existing == null) return;

    final updated = existing.copyWithModel(
      status: 'missed',
      notes: notes ?? existing.notes,
      isSynced: false,
      updatedAt: DateTime.now(),
    );

    await localDataSource.updateDoseLog(updated);
    await localDataSource.markDoseLogAsPendingSync(id);

    await syncQueueService.enqueue(
      entityType: 'dose_log',
      entityId: id,
      operation: 'upsert',
      payload: updated.toSyncPayload(),
    );
  }

  @override
  Future<void> markAsSkipped({
    required String id,
    String? notes,
  }) async {
    final existing = await localDataSource.getDoseLogById(id);
    if (existing == null) return;

    final updated = existing.copyWithModel(
      status: 'skipped',
      notes: notes ?? existing.notes,
      isSynced: false,
      updatedAt: DateTime.now(),
    );

    await localDataSource.updateDoseLog(updated);
    await localDataSource.markDoseLogAsPendingSync(id);

    await syncQueueService.enqueue(
      entityType: 'dose_log',
      entityId: id,
      operation: 'upsert',
      payload: updated.toSyncPayload(),
    );
  }
}