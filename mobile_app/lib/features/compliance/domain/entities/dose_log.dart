class DoseLog {
  final String id;
  final String patientId;
  final String medicineId;
  final String? reminderId;

  final DateTime scheduledAt;
  final DateTime? takenAt;

  final String status; // scheduled, taken, missed, skipped
  final String? notes;

  final bool isSynced;
  final bool isDeleted;

  final DateTime createdAt;
  final DateTime updatedAt;

  const DoseLog({
    required this.id,
    this.patientId = 'default_patient',
    required this.medicineId,
    this.reminderId,
    required this.scheduledAt,
    this.takenAt,
    required this.status,
    this.notes,
    this.isSynced = false,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  DoseLog copyWith({
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
    return DoseLog(
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

  bool get isTaken => status == 'taken';
  bool get isMissed => status == 'missed';
  bool get isSkipped => status == 'skipped';
  bool get isScheduled => status == 'scheduled';
}
