class Medicine {
  final String id;
  final String patientId;
  final String name;
  final String dosage;
  final String frequency;
  final String form;
  final String instructions;
  final List<String> scheduledTimes;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String color;
  final bool isSynced;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Medicine({
    required this.id,
    this.patientId = 'default_patient',
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
    this.isSynced = false,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Medicine copyWith({
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
    return Medicine(
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
}