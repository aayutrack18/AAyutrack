import 'package:drift/drift.dart';
import 'package:aayutrack/core/database/app_database.dart' as db;
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart'
    as domain;

class HealthLogModel extends domain.HealthLog {
  final String patientId;
  final bool isSynced;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HealthLogModel({
    required String id,
    required this.patientId,
    required domain.MetricType type,
    required double value,
    double? secondaryValue,
    required String notes,
    required DateTime recordedAt,
    required String source,
    required this.isSynced,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
          id: id,
          type: type,
          value: value,
          secondaryValue: secondaryValue,
          notes: notes,
          recordedAt: recordedAt,
          source: source,
        );

  factory HealthLogModel.fromEntity(
    domain.HealthLog log, {
    String patientId = 'default_patient',
    bool isSynced = false,
    bool isDeleted = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    if (log is HealthLogModel) {
      return log;
    }

    final now = DateTime.now();

    return HealthLogModel(
      id: log.id,
      patientId: patientId,
      type: log.type,
      value: log.value,
      secondaryValue: log.secondaryValue,
      notes: log.notes,
      recordedAt: log.recordedAt,
      source: log.source,
      isSynced: isSynced,
      isDeleted: isDeleted,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
    );
  }

  factory HealthLogModel.fromDb(db.HealthLog row) {
    return HealthLogModel(
      id: row.id,
      patientId: row.patientId,
      type: _metricTypeFromDb(row.metricType),
      value: row.value,
      secondaryValue: row.secondaryValue,
      notes: row.notes ?? '',
      recordedAt: row.recordedAt,
      source: row.source,
      isSynced: row.isSynced,
      isDeleted: row.isDeleted,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  db.HealthLogsCompanion toCompanion() {
    return db.HealthLogsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      metricType: Value(_metricTypeToDb(type)),
      value: Value(value),
      secondaryValue: Value(secondaryValue),
      notes: Value(notes.isEmpty ? null : notes),
      source: Value(source),
      recordedAt: Value(recordedAt),
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
      'metricType': _metricTypeToDb(type),
      'value': value,
      'secondaryValue': secondaryValue,
      'notes': notes,
      'source': source,
      'recordedAt': recordedAt.toIso8601String(),
      'isSynced': isSynced,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  HealthLogModel copyWithModel({
    String? id,
    String? patientId,
    domain.MetricType? type,
    double? value,
    double? secondaryValue,
    bool clearSecondaryValue = false,
    String? notes,
    DateTime? recordedAt,
    String? source,
    bool? isSynced,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthLogModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      type: type ?? this.type,
      value: value ?? this.value,
      secondaryValue:
          clearSecondaryValue ? null : (secondaryValue ?? this.secondaryValue),
      notes: notes ?? this.notes,
      recordedAt: recordedAt ?? this.recordedAt,
      source: source ?? this.source,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static String _metricTypeToDb(domain.MetricType type) {
    switch (type) {
      case domain.MetricType.bloodPressure:
        return 'bloodPressure';
      case domain.MetricType.bloodSugar:
        return 'bloodSugar';
      case domain.MetricType.heartRate:
        return 'heartRate';
      case domain.MetricType.weight:
        return 'weight';
      case domain.MetricType.oxygen:
        return 'oxygen';
      case domain.MetricType.temperature:
        return 'temperature';
      case domain.MetricType.mood:
        return 'mood';
    }
  }

  static domain.MetricType _metricTypeFromDb(String raw) {
    switch (raw) {
      case 'bloodPressure':
        return domain.MetricType.bloodPressure;
      case 'bloodSugar':
        return domain.MetricType.bloodSugar;
      case 'heartRate':
        return domain.MetricType.heartRate;
      case 'weight':
        return domain.MetricType.weight;
      case 'oxygen':
        return domain.MetricType.oxygen;
      case 'temperature':
        return domain.MetricType.temperature;
      case 'mood':
        return domain.MetricType.mood;
      default:
        return domain.MetricType.bloodPressure;
    }
  }
}