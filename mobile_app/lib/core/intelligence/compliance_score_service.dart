import 'package:aayutrack/features/compliance/domain/entities/dose_log.dart';

class ComplianceSummary {
  final DateTime periodStart;
  final DateTime periodEnd;
  final int totalScheduled;
  final int takenCount;
  final int missedCount;
  final int skippedCount;
  final int pendingCount;
  final double adherencePercentage;
  final double complianceScore;

  const ComplianceSummary({
    required this.periodStart,
    required this.periodEnd,
    required this.totalScheduled,
    required this.takenCount,
    required this.missedCount,
    required this.skippedCount,
    required this.pendingCount,
    required this.adherencePercentage,
    required this.complianceScore,
  });

  bool get isPerfect => complianceScore >= 100;
  bool get isGood => complianceScore >= 80;
  bool get isModerate => complianceScore >= 60;
  bool get isPoor => complianceScore < 60;

  Map<String, dynamic> toJson() {
    return {
      'periodStart': periodStart.toIso8601String(),
      'periodEnd': periodEnd.toIso8601String(),
      'totalScheduled': totalScheduled,
      'takenCount': takenCount,
      'missedCount': missedCount,
      'skippedCount': skippedCount,
      'pendingCount': pendingCount,
      'adherencePercentage': adherencePercentage,
      'complianceScore': complianceScore,
    };
  }

  factory ComplianceSummary.fromJson(Map<String, dynamic> json) {
    return ComplianceSummary(
      periodStart: DateTime.tryParse(json['periodStart'] as String? ?? '') ??
          DateTime.now(),
      periodEnd: DateTime.tryParse(json['periodEnd'] as String? ?? '') ??
          DateTime.now(),
      totalScheduled: json['totalScheduled'] as int? ?? 0,
      takenCount: json['takenCount'] as int? ?? 0,
      missedCount: json['missedCount'] as int? ?? 0,
      skippedCount: json['skippedCount'] as int? ?? 0,
      pendingCount: json['pendingCount'] as int? ?? 0,
      adherencePercentage:
          (json['adherencePercentage'] as num?)?.toDouble() ?? 0.0,
      complianceScore: (json['complianceScore'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class MedicineComplianceSummary {
  final String medicineId;
  final int totalScheduled;
  final int takenCount;
  final int missedCount;
  final int skippedCount;
  final int pendingCount;
  final double adherencePercentage;
  final double complianceScore;

  const MedicineComplianceSummary({
    required this.medicineId,
    required this.totalScheduled,
    required this.takenCount,
    required this.missedCount,
    required this.skippedCount,
    required this.pendingCount,
    required this.adherencePercentage,
    required this.complianceScore,
  });

  Map<String, dynamic> toJson() {
    return {
      'medicineId': medicineId,
      'totalScheduled': totalScheduled,
      'takenCount': takenCount,
      'missedCount': missedCount,
      'skippedCount': skippedCount,
      'pendingCount': pendingCount,
      'adherencePercentage': adherencePercentage,
      'complianceScore': complianceScore,
    };
  }

  factory MedicineComplianceSummary.fromJson(Map<String, dynamic> json) {
    return MedicineComplianceSummary(
      medicineId: json['medicineId'] as String? ?? '',
      totalScheduled: json['totalScheduled'] as int? ?? 0,
      takenCount: json['takenCount'] as int? ?? 0,
      missedCount: json['missedCount'] as int? ?? 0,
      skippedCount: json['skippedCount'] as int? ?? 0,
      pendingCount: json['pendingCount'] as int? ?? 0,
      adherencePercentage:
          (json['adherencePercentage'] as num?)?.toDouble() ?? 0.0,
      complianceScore: (json['complianceScore'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ComplianceScoreService {
  const ComplianceScoreService();

  ComplianceSummary calculate({
    required List<DoseLog> doseLogs,
    required DateTime periodStart,
    required DateTime periodEnd,
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();

    final filteredLogs = doseLogs
        .where(
          (log) =>
              !log.isDeleted &&
              !log.scheduledAt.isBefore(periodStart) &&
              !log.scheduledAt.isAfter(periodEnd),
        )
        .toList();

    final totalScheduled = filteredLogs.length;
    final takenCount = filteredLogs.where((log) => log.isTaken).length;
    final missedCount = filteredLogs.where((log) => log.isMissed).length;
    final skippedCount = filteredLogs.where((log) => log.isSkipped).length;
    final pendingCount =
        filteredLogs.where((log) => _isPending(log, currentTime)).length;

    final adherencePercentage =
        totalScheduled == 0 ? 0.0 : (takenCount / totalScheduled) * 100.0;

    final complianceScore = adherencePercentage.clamp(0.0, 100.0);

    return ComplianceSummary(
      periodStart: periodStart,
      periodEnd: periodEnd,
      totalScheduled: totalScheduled,
      takenCount: takenCount,
      missedCount: missedCount,
      skippedCount: skippedCount,
      pendingCount: pendingCount,
      adherencePercentage: adherencePercentage,
      complianceScore: complianceScore,
    );
  }

  List<MedicineComplianceSummary> calculateByMedicine({
    required List<DoseLog> doseLogs,
    required DateTime periodStart,
    required DateTime periodEnd,
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();

    final filteredLogs = doseLogs
        .where(
          (log) =>
              !log.isDeleted &&
              !log.scheduledAt.isBefore(periodStart) &&
              !log.scheduledAt.isAfter(periodEnd),
        )
        .toList();

    final grouped = <String, List<DoseLog>>{};
    for (final log in filteredLogs) {
      grouped.putIfAbsent(log.medicineId, () => <DoseLog>[]).add(log);
    }

    return grouped.entries.map((entry) {
      final logs = entry.value;
      final totalScheduled = logs.length;
      final takenCount = logs.where((log) => log.isTaken).length;
      final missedCount = logs.where((log) => log.isMissed).length;
      final skippedCount = logs.where((log) => log.isSkipped).length;
      final pendingCount =
          logs.where((log) => _isPending(log, currentTime)).length;

      final adherencePercentage =
          totalScheduled == 0 ? 0.0 : (takenCount / totalScheduled) * 100.0;

      final complianceScore = adherencePercentage.clamp(0.0, 100.0);

      return MedicineComplianceSummary(
        medicineId: entry.key,
        totalScheduled: totalScheduled,
        takenCount: takenCount,
        missedCount: missedCount,
        skippedCount: skippedCount,
        pendingCount: pendingCount,
        adherencePercentage: adherencePercentage,
        complianceScore: complianceScore,
      );
    }).toList()
      ..sort((a, b) => a.medicineId.compareTo(b.medicineId));
  }

  double calculateDailyScore({
    required List<DoseLog> doseLogs,
    required DateTime day,
    DateTime? now,
  }) {
    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day, 23, 59, 59, 999);

    final summary = calculate(
      doseLogs: doseLogs,
      periodStart: start,
      periodEnd: end,
      now: now,
    );

    return summary.complianceScore;
  }

  double calculateWeeklyScore({
    required List<DoseLog> doseLogs,
    required DateTime weekStart,
    DateTime? now,
  }) {
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final end = start.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );

    final summary = calculate(
      doseLogs: doseLogs,
      periodStart: start,
      periodEnd: end,
      now: now,
    );

    return summary.complianceScore;
  }

  bool _isPending(DoseLog log, DateTime now) {
    return log.isScheduled && log.scheduledAt.isAfter(now);
  }
}