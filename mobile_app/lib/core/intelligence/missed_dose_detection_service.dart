import 'package:aayutrack/features/compliance/domain/entities/dose_log.dart';

class MissedDoseAlert {
  final String id;
  final String patientId;
  final String medicineId;
  final String? reminderId;
  final String severity;
  final String title;
  final String message;
  final DateTime scheduledAt;
  final DateTime detectedAt;
  final String type;

  const MissedDoseAlert({
    required this.id,
    required this.patientId,
    required this.medicineId,
    required this.reminderId,
    required this.severity,
    required this.title,
    required this.message,
    required this.scheduledAt,
    required this.detectedAt,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'medicineId': medicineId,
      'reminderId': reminderId,
      'severity': severity,
      'title': title,
      'message': message,
      'scheduledAt': scheduledAt.toIso8601String(),
      'detectedAt': detectedAt.toIso8601String(),
      'type': type,
    };
  }
}

class MissedDoseDetectionService {
  const MissedDoseDetectionService();

  List<MissedDoseAlert> detectMissedDoses({
    required List<DoseLog> doseLogs,
    DateTime? now,
    Duration gracePeriod = const Duration(minutes: 30),
  }) {
    final currentTime = now ?? DateTime.now();

    final alerts = doseLogs
        .where((log) => !log.isDeleted)
        .where((log) => _isMissedOrLate(log, currentTime, gracePeriod))
        .map((log) => _buildAlert(log, currentTime, gracePeriod))
        .toList();

    alerts.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
    return alerts;
  }

  List<DoseLog> detectLateScheduledLogs({
    required List<DoseLog> doseLogs,
    DateTime? now,
    Duration gracePeriod = const Duration(minutes: 30),
  }) {
    final currentTime = now ?? DateTime.now();

    return doseLogs
        .where((log) => !log.isDeleted)
        .where(
          (log) =>
              log.isScheduled &&
              currentTime.isAfter(log.scheduledAt.add(gracePeriod)),
        )
        .toList()
      ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
  }

  int countMissedDosesInPeriod({
    required List<DoseLog> doseLogs,
    required DateTime start,
    required DateTime end,
  }) {
    return doseLogs
        .where((log) => !log.isDeleted)
        .where(
          (log) =>
              !log.scheduledAt.isBefore(start) &&
              !log.scheduledAt.isAfter(end) &&
              log.isMissed,
        )
        .length;
  }

  List<DoseLog> findConsecutiveMissedDoses({
    required List<DoseLog> doseLogs,
    int minimumStreak = 2,
  }) {
    final sortedLogs = doseLogs
        .where((log) => !log.isDeleted)
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    final result = <DoseLog>[];
    var streak = <DoseLog>[];

    for (final log in sortedLogs) {
      if (log.isMissed) {
        streak.add(log);
      } else {
        if (streak.length >= minimumStreak) {
          result.addAll(streak);
        }
        streak = <DoseLog>[];
      }
    }

    if (streak.length >= minimumStreak) {
      result.addAll(streak);
    }

    return result;
  }

  bool _isMissedOrLate(
    DoseLog log,
    DateTime now,
    Duration gracePeriod,
  ) {
    if (log.isMissed) return true;

    return log.isScheduled && now.isAfter(log.scheduledAt.add(gracePeriod));
  }

  MissedDoseAlert _buildAlert(
    DoseLog log,
    DateTime detectedAt,
    Duration gracePeriod,
  ) {
    final overdueDuration = detectedAt.difference(log.scheduledAt);

    final severity = overdueDuration.inHours >= 12
        ? 'high'
        : overdueDuration.inHours >= 2
            ? 'medium'
            : 'low';

    final type = log.isMissed ? 'missed_dose' : 'late_dose';

    return MissedDoseAlert(
      id: 'missed-${log.id}',
      patientId: log.patientId,
      medicineId: log.medicineId,
      reminderId: log.reminderId,
      severity: severity,
      title: log.isMissed ? 'Missed medication detected' : 'Dose overdue',
      message: log.isMissed
          ? 'A scheduled medication dose was marked as missed.'
          : 'A scheduled medication dose is overdue beyond the allowed grace period.',
      scheduledAt: log.scheduledAt,
      detectedAt: detectedAt,
      type: type,
    );
  }
}