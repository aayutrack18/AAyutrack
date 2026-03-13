import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:aayutrack/core/database/app_database.dart' as db;
import 'package:aayutrack/features/medicine/domain/entities/medicine.dart'
    as domain;

class MedicineModel extends domain.Medicine {
  const MedicineModel({
    required String id,
    String patientId = 'default_patient',
    required String name,
    required String dosage,
    required String frequency,
    required String form,
    required String instructions,
    required List<String> scheduledTimes,
    required DateTime startDate,
    DateTime? endDate,
    required bool isActive,
    required String color,
    bool isSynced = false,
    bool isDeleted = false,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          patientId: patientId,
          name: name,
          dosage: dosage,
          frequency: frequency,
          form: form,
          instructions: instructions,
          scheduledTimes: scheduledTimes,
          startDate: startDate,
          endDate: endDate,
          isActive: isActive,
          color: color,
          isSynced: isSynced,
          isDeleted: isDeleted,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory MedicineModel.fromEntity(domain.Medicine medicine) {
    if (medicine is MedicineModel) {
      return medicine;
    }

    return MedicineModel(
      id: medicine.id,
      patientId: medicine.patientId,
      name: medicine.name,
      dosage: medicine.dosage,
      frequency: medicine.frequency,
      form: medicine.form,
      instructions: medicine.instructions,
      scheduledTimes: medicine.scheduledTimes,
      startDate: medicine.startDate,
      endDate: medicine.endDate,
      isActive: medicine.isActive,
      color: medicine.color,
      isSynced: medicine.isSynced,
      isDeleted: medicine.isDeleted,
      createdAt: medicine.createdAt,
      updatedAt: medicine.updatedAt,
    );
  }

  factory MedicineModel.fromDb(db.Medicine row) {
    return MedicineModel(
      id: row.id,
      patientId: row.patientId,
      name: row.name,
      dosage: row.dosage ?? '',
      frequency: row.frequency ?? '',
      form: row.form ?? '',
      instructions: row.instructions ?? '',
      scheduledTimes: _decodeScheduledTimes(row.scheduledTimes),
      startDate: row.startDate ?? row.createdAt,
      endDate: row.endDate,
      isActive: row.isActive,
      color: row.color ?? '#1D4ED8',
      isSynced: row.isSynced,
      isDeleted: row.isDeleted,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  db.MedicinesCompanion toCompanion() {
    return db.MedicinesCompanion(
      id: Value(id),
      patientId: Value(patientId),
      name: Value(name),
      dosage: Value(dosage),
      frequency: Value(frequency),
      scheduledTimes: Value(jsonEncode(scheduledTimes)),
      color: Value(color),
      form: Value(form),
      instructions: Value(instructions),
      isActive: Value(isActive),
      isDeleted: Value(isDeleted),
      isSynced: Value(isSynced),
      startDate: Value(startDate),
      endDate: Value(endDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  Map<String, dynamic> toSyncPayload() {
    return {
      'id': id,
      'patientId': patientId,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'form': form,
      'instructions': instructions,
      'scheduledTimes': scheduledTimes,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'color': color,
      'isSynced': isSynced,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  MedicineModel copyWithModel({
    String? id,
    String? patientId,
    String? name,
    String? dosage,
    String? frequency,
    String? form,
    String? instructions,
    List<String>? scheduledTimes,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? color,
    bool? isSynced,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      form: form ?? this.form,
      instructions: instructions ?? this.instructions,
      scheduledTimes: scheduledTimes ?? this.scheduledTimes,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      color: color ?? this.color,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static List<String> _decodeScheduledTimes(String? raw) {
    if (raw == null || raw.isEmpty) return <String>[];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}

    return <String>[];
  }
}
