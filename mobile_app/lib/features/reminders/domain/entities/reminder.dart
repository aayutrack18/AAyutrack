class Reminder {
  final String id;
  final String title;
  final String description;
  final String time; // HH:MM
  final List<String> repeatDays; // ['Mon', 'Tue', ...]
  final bool isEnabled;
  final String type; // medicine, appointment, measurement, custom
  final String? linkedMedicineId;
  final DateTime createdAt;

  const Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.repeatDays,
    required this.isEnabled,
    required this.type,
    this.linkedMedicineId,
    required this.createdAt,
  });

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    List<String>? repeatDays,
    bool? isEnabled,
    String? type,
    String? linkedMedicineId,
    DateTime? createdAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      repeatDays: repeatDays ?? this.repeatDays,
      isEnabled: isEnabled ?? this.isEnabled,
      type: type ?? this.type,
      linkedMedicineId: linkedMedicineId ?? this.linkedMedicineId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isDaily => repeatDays.length == 7;
}
