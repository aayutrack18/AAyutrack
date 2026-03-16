enum MetricType {
  bloodPressure,
  bloodSugar,
  heartRate,
  weight,
  oxygen,
  temperature,
  mood,
}

extension MetricTypeExt on MetricType {
  String get label {
    switch (this) {
      case MetricType.bloodPressure: return 'Blood Pressure';
      case MetricType.bloodSugar: return 'Blood Sugar';
      case MetricType.heartRate: return 'Heart Rate';
      case MetricType.weight: return 'Weight';
      case MetricType.oxygen: return 'Oxygen Saturation';
      case MetricType.temperature: return 'Temperature';
      case MetricType.mood: return 'Mood / Notes';
    }
  }

  String get unit {
    switch (this) {
      case MetricType.bloodPressure: return 'mmHg';
      case MetricType.bloodSugar: return 'mg/dL';
      case MetricType.heartRate: return 'bpm';
      case MetricType.weight: return 'kg';
      case MetricType.oxygen: return '%';
      case MetricType.temperature: return '°C';
      case MetricType.mood: return '';
    }
  }

  String get icon {
    switch (this) {
      case MetricType.bloodPressure: return '🩸';
      case MetricType.bloodSugar: return '🍬';
      case MetricType.heartRate: return '❤️';
      case MetricType.weight: return '⚖️';
      case MetricType.oxygen: return '🫁';
      case MetricType.temperature: return '🌡️';
      case MetricType.mood: return '😊';
    }
  }
}

class HealthLog {
  final String id;
  final MetricType type;
  final double value;
  final double? secondaryValue; // for BP: diastolic
  final String notes;
  final DateTime recordedAt;
  final String source; // manual, wearable

  const HealthLog({
    required this.id,
    required this.type,
    required this.value,
    this.secondaryValue,
    required this.notes,
    required this.recordedAt,
    required this.source,
  });

  String get displayValue {
    if (type == MetricType.bloodPressure && secondaryValue != null) {
      return '${value.toInt()}/${secondaryValue!.toInt()}';
    }
    if (type == MetricType.weight || type == MetricType.temperature) {
      return value.toStringAsFixed(1);
    }
    return value.toInt().toString();
  }

  HealthLog copyWith({
    String? id,
    MetricType? type,
    double? value,
    double? secondaryValue,
    String? notes,
    DateTime? recordedAt,
    String? source,
  }) {
    return HealthLog(
      id: id ?? this.id,
      type: type ?? this.type,
      value: value ?? this.value,
      secondaryValue: secondaryValue ?? this.secondaryValue,
      notes: notes ?? this.notes,
      recordedAt: recordedAt ?? this.recordedAt,
      source: source ?? this.source,
    );
  }
}
