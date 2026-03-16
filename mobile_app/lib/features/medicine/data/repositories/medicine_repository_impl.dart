import 'package:aayutrack/core/services/notification_service.dart';
import 'package:aayutrack/core/sync/sync_queue_service.dart';
import 'package:aayutrack/features/medicine/data/datasources/medicine_local_datasource.dart';
import 'package:aayutrack/features/medicine/data/models/medicine_model.dart';
import 'package:aayutrack/features/medicine/domain/entities/medicine.dart';
import 'package:aayutrack/features/medicine/domain/repositories/medicine_repository.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineLocalDataSource localDataSource;
  final SyncQueueService syncQueueService;
  final NotificationService notificationService;

  const MedicineRepositoryImpl({
    required this.localDataSource,
    required this.syncQueueService,
    required this.notificationService,
  });

  @override
  Future<List<Medicine>> getMedicines() async {
    final medicines = await localDataSource.getMedicines();
    return medicines;
  }

  @override
  Future<void> saveMedicine(Medicine medicine) async {
    final model = MedicineModel.fromEntity(
      medicine.copyWith(
        isSynced: false,
        isDeleted: false,
        updatedAt: DateTime.now(),
      ),
    );

    await localDataSource.saveMedicine(model);
    await localDataSource.markMedicineAsPendingSync(model.id);

    await syncQueueService.enqueue(
      entityType: 'medicine',
      entityId: model.id,
      operation: 'upsert',
      payload: model.toSyncPayload(),
    );

    await notificationService.scheduleMedicineReminders(model);
  }

  @override
  Future<void> updateMedicine(Medicine medicine) async {
    final model = MedicineModel.fromEntity(
      medicine.copyWith(
        isSynced: false,
        isDeleted: false,
        updatedAt: DateTime.now(),
      ),
    );

    await localDataSource.updateMedicine(model);
    await localDataSource.markMedicineAsPendingSync(model.id);

    await syncQueueService.enqueue(
      entityType: 'medicine',
      entityId: model.id,
      operation: 'upsert',
      payload: model.toSyncPayload(),
    );

    await notificationService.scheduleMedicineReminders(model);
  }

  @override
  Future<void> deleteMedicine(String id) async {
    final existing = await localDataSource.getMedicineById(id);
    if (existing == null) return;

    await localDataSource.deleteMedicine(id);

    await syncQueueService.enqueue(
      entityType: 'medicine',
      entityId: id,
      operation: 'delete',
      payload: {
        'id': existing.id,
        'patientId': existing.patientId,
      },
    );

    await notificationService.cancelMedicineReminders(id);
  }

  @override
  Future<void> toggleMedicineActive(String id, bool isActive) async {
    final existing = await localDataSource.getMedicineById(id);
    if (existing == null) return;

    final updated = existing.copyWithModel(
      isActive: isActive,
      isDeleted: false,
      isSynced: false,
      updatedAt: DateTime.now(),
    );

    await localDataSource.updateMedicine(updated);
    await localDataSource.markMedicineAsPendingSync(id);

    await syncQueueService.enqueue(
      entityType: 'medicine',
      entityId: id,
      operation: 'upsert',
      payload: updated.toSyncPayload(),
    );

    if (isActive) {
      await notificationService.scheduleMedicineReminders(updated);
    } else {
      await notificationService.cancelMedicineReminders(id);
    }
  }
}