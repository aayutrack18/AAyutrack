import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:aayutrack/core/database/app_database.dart' as db;
import 'package:aayutrack/features/reminders/domain/entities/reminder.dart'
    as domain;

class ReminderModel extends domain.Reminder {
  const ReminderModel({
    required String id,
    String patientId = 'default_patient',
    required String title,
    required String description,
    required String time,
    required List<String> repeatDays,
    required bool isEnabled,
    required String type,
    String? linkedMedicineId,
    bool isSynced = false,
    bool isDeleted = false,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          patientId: patientId,
          title: title,
          description: description,
          time: time,
          repeatDays: repeatDays,
          isEnabled: isEnabled,
          type: type,
          linkedMedicineId: linkedMedicineId,
          isSynced: isSynced,
          isDeleted: isDeleted,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory ReminderModel.fromEntity(domain.Reminder reminder) {
    if (reminder is ReminderModel) {
      return reminder;
    }

    return ReminderModel(
      id: reminder.id,
      patientId: reminder.patientId,
      title: reminder.title,
      description: reminder.description,
      time: reminder.time,
      repeatDays: reminder.repeatDays,
      isEnabled: reminder.isEnabled,
      type: reminder.type,
      linkedMedicineId: reminder.linkedMedicineId,
      isSynced: reminder.isSynced,
      isDeleted: reminder.isDeleted,
      createdAt: reminder.createdAt,
      updatedAt: reminder.updatedAt,
    );
  }

  factory ReminderModel.fromDb(db.Reminder row) {
    return ReminderModel(
      id: row.id,
      patientId: row.patientId,
      title: row.title,
      description: row.notes ?? '',
      time: _formatTime(row.hour, row.minute),
      repeatDays: _decodeRepeatDays(row.daysOfWeek),
      isEnabled: row.isActive,
      type: row.reminderType,
      linkedMedicineId: row.medicineId,
      isSynced: row.isSynced,
      isDeleted: row.isDeleted,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  db.RemindersCompanion toCompanion() {
    final parsedTime = _parseTime(time);

    return db.RemindersCompanion(
      id: Value(id),
      patientId: Value(patientId),
      medicineId: Value(linkedMedicineId),
      title: Value(title),
      notes: Value(description),
      reminderType: Value(type),
      hour: Value(parsedTime.$1),
      minute: Value(parsedTime.$2),
      frequency: Value(_frequencyFromRepeatDays(repeatDays)),
      daysOfWeek: Value(jsonEncode(repeatDays)),
      isActive: Value(isEnabled),
      isDeleted: Value(isDeleted),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  Map<String, dynamic> toSyncPayload() {
    return {
      'id': id,
      'patientId': patientId,
      'title': title,
      'description': description,
      'time': time,
      'repeatDays': repeatDays,
      'isEnabled': isEnabled,
      'type': type,
      'linkedMedicineId': linkedMedicineId,
      'isSynced': isSynced,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ReminderModel copyWithModel({
    String? id,
    String? patientId,
    String? title,
    String? description,
    String? time,
    List<String>? repeatDays,
    bool? isEnabled,
    String? type,
    String? linkedMedicineId,
    bool? isSynced,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      repeatDays: repeatDays ?? this.repeatDays,
      isEnabled: isEnabled ?? this.isEnabled,
      type: type ?? this.type,
      linkedMedicineId: linkedMedicineId ?? this.linkedMedicineId,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static (int, int) _parseTime(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return (0, 0);

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return (hour, minute);
  }

  static String _formatTime(int hour, int minute) {
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  static List<String> _decodeRepeatDays(String? raw) {
    if (raw == null || raw.isEmpty) return <String>[];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}

    return <String>[];
  }

  static String _frequencyFromRepeatDays(List<String> repeatDays) {
    if (repeatDays.length == 7) return 'daily';
    if (repeatDays.isEmpty) return 'custom';
    return 'weekly';
  }
}