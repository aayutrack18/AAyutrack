import 'package:drift/drift.dart';
import 'package:aayutrack/core/database/app_database.dart' as db;
import 'package:aayutrack/features/compliance/domain/entities/dose_log.dart'
    as domain;

class DoseLogModel extends domain.DoseLog {
  const DoseLogModel({
    required String id,
    String patientId = 'default_patient',
    required String medicineId,
    String? reminderId,
    required DateTime scheduledAt,
    DateTime? takenAt,
    required String status,
    String? notes,
    bool isSynced = false,
    bool isDeleted = false,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          patientId: patientId,
          medicineId: medicineId,
          reminderId: reminderId,
          scheduledAt: scheduledAt,
          takenAt: takenAt,
          status: status,
          notes: notes,
          isSynced: isSynced,
          isDeleted: isDeleted,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory DoseLogModel.fromEntity(domain.DoseLog doseLog) {
    if (doseLog is DoseLogModel) {
      return doseLog;
    }

    return DoseLogModel(
      id: doseLog.id,
      patientId: doseLog.patientId,
      medicineId: doseLog.medicineId,
      reminderId: doseLog.reminderId,
      scheduledAt: doseLog.scheduledAt,
      takenAt: doseLog.takenAt,
      status: doseLog.status,
      notes: doseLog.notes,
      isSynced: doseLog.isSynced,
      isDeleted: doseLog.isDeleted,
      createdAt: doseLog.createdAt,
      updatedAt: doseLog.updatedAt,
    );
  }

  factory DoseLogModel.fromDb(db.DoseLog row) {
    return DoseLogModel(
      id: row.id,
      patientId: row.patientId,
      medicineId: row.medicineId,
      reminderId: row.reminderId,
      scheduledAt: row.scheduledAt,
      takenAt: row.takenAt,
      status: row.status,
      notes: row.notes,
      isSynced: row.isSynced,
      isDeleted: row.isDeleted,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  db.DoseLogsCompanion toCompanion() {
    return db.DoseLogsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      medicineId: Value(medicineId),
      reminderId: Value(reminderId),
      scheduledAt: Value(scheduledAt),
      takenAt: Value(takenAt),
      status: Value(status),
      notes: Value(notes),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  Map<String, dynamic> toSyncPayload() {
    return {
      'id': id,
      'patientId': patientId,
      'medicineId': medicineId,
      'reminderId': reminderId,
      'scheduledAt': scheduledAt.toIso8601String(),
      'takenAt': takenAt?.toIso8601String(),
      'status': status,
      'notes': notes,
      'isSynced': isSynced,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  DoseLogModel copyWithModel({
    String? id,
    String? patientId,
    String? medicineId,
    String? reminderId,
    DateTime? scheduledAt,
    DateTime? takenAt,
    String? status,
    String? notes,
    bool? isSynced,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DoseLogModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      medicineId: medicineId ?? this.medicineId,
      reminderId: reminderId ?? this.reminderId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      takenAt: takenAt ?? this.takenAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}