class Medicine {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final String form; // tablet, capsule, syrup, injection, drops
  final String instructions;
  final List<String> scheduledTimes; // e.g. ['08:00', '20:00']
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String color; // for UI color coding
  final DateTime createdAt;
  final DateTime updatedAt;

  const Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.form,
    required this.instructions,
    required this.scheduledTimes,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  Medicine copyWith({
    String? id,
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medicine(
      id: id ?? this.id,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
