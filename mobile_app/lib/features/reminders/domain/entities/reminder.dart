class Reminder {
  final String id;
  final String patientId;
  final String title;
  final String description;
  final String time; // HH:MM
  final List<String> repeatDays; // ['Mon', 'Tue', ...]
  final bool isEnabled;
  final String type; // medicine, appointment, measurement, custom
  final String? linkedMedicineId;
  final bool isSynced;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Reminder({
    required this.id,
    this.patientId = 'default_patient',
    required this.title,
    required this.description,
    required this.time,
    required this.repeatDays,
    required this.isEnabled,
    required this.type,
    this.linkedMedicineId,
    this.isSynced = false,
    this.isDeleted = false,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  Reminder copyWith({
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
    return Reminder(
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

  bool get isDaily => repeatDays.length == 7;
}