import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aayutrack/core/intelligence/compliance_score_service.dart';
import 'package:aayutrack/core/intelligence/intelligence_providers.dart';
import 'package:aayutrack/core/intelligence/risk_detection_service.dart'
    as intelligence;
import 'package:aayutrack/features/compliance/presentation/providers/dose_log_provider.dart';
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';
import 'package:aayutrack/features/health_logs/presentation/providers/health_log_provider.dart';

final complianceProvider =
    StateNotifierProvider<ComplianceNotifier, ComplianceState>((ref) {
      final notifier = ComplianceNotifier(ref);

      ref.listen<ComplianceSummary>(complianceSummaryProvider, (_, __) {
        notifier.refresh();
      });

      ref.listen<List<intelligence.RiskAlert>>(riskAlertsProvider, (_, __) {
        notifier.refresh();
      });

      ref.listen<bool>(intelligenceLoadingProvider, (_, __) {
        notifier.refresh();
      });

      ref.listen<List<String>>(intelligenceErrorsProvider, (_, __) {
        notifier.refresh();
      });

      ref.listen<HealthLogState>(healthLogProvider, (_, __) {
        notifier.refresh();
      });

      ref.listen<DoseLogState>(doseLogProvider, (_, __) {
        notifier.refresh();
      });

      return notifier;
    });

class RiskAlert {
  final String id;
  final String title;
  final String description;
  final String severity;
  final DateTime createdAt;
  final bool isRead;
  final String? riskType;
  final Map<String, dynamic> metadata;

  const RiskAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.createdAt,
    required this.isRead,
    this.riskType,
    this.metadata = const {},
  });

  RiskAlert copyWith({
    String? id,
    String? title,
    String? description,
    String? severity,
    DateTime? createdAt,
    bool? isRead,
    String? riskType,
    Map<String, dynamic>? metadata,
  }) {
    return RiskAlert(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      riskType: riskType ?? this.riskType,
      metadata: metadata ?? this.metadata,
    );
  }
}

class WeeklyAdherence {
  final String day;
  final double percentage;

  const WeeklyAdherence({
    required this.day,
    required this.percentage,
  });
}

class ComplianceState {
  final bool isLoading;
  final double overallScore;
  final double weeklyScore;
  final double medicineAdherence;
  final double logAdherence;
  final List<RiskAlert> alerts;
  final List<WeeklyAdherence> weeklyTrend;
  final String? errorMessage;
  final bool hasDoseLogs;
  final bool hasHealthLogs;

  const ComplianceState({
    required this.isLoading,
    required this.overallScore,
    required this.weeklyScore,
    required this.medicineAdherence,
    required this.logAdherence,
    required this.alerts,
    required this.weeklyTrend,
    required this.errorMessage,
    required this.hasDoseLogs,
    required this.hasHealthLogs,
  });

  factory ComplianceState.initial() {
    return const ComplianceState(
      isLoading: true,
      overallScore: 0,
      weeklyScore: 0,
      medicineAdherence: 0,
      logAdherence: 0,
      alerts: [],
      weeklyTrend: [],
      errorMessage: null,
      hasDoseLogs: false,
      hasHealthLogs: false,
    );
  }

  ComplianceState copyWith({
    bool? isLoading,
    double? overallScore,
    double? weeklyScore,
    double? medicineAdherence,
    double? logAdherence,
    List<RiskAlert>? alerts,
    List<WeeklyAdherence>? weeklyTrend,
    String? errorMessage,
    bool clearError = false,
    bool? hasDoseLogs,
    bool? hasHealthLogs,
  }) {
    return ComplianceState(
      isLoading: isLoading ?? this.isLoading,
      overallScore: overallScore ?? this.overallScore,
      weeklyScore: weeklyScore ?? this.weeklyScore,
      medicineAdherence: medicineAdherence ?? this.medicineAdherence,
      logAdherence: logAdherence ?? this.logAdherence,
      alerts: alerts ?? this.alerts,
      weeklyTrend: weeklyTrend ?? this.weeklyTrend,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hasDoseLogs: hasDoseLogs ?? this.hasDoseLogs,
      hasHealthLogs: hasHealthLogs ?? this.hasHealthLogs,
    );
  }

  int get unreadAlertCount => alerts.where((a) => !a.isRead).length;

  bool get hasError => errorMessage != null && errorMessage!.trim().isNotEmpty;

  bool get hasAnyData => hasDoseLogs || hasHealthLogs;

  String get scoreLabel {
    if (overallScore >= 90) return 'Excellent';
    if (overallScore >= 75) return 'Good';
    if (overallScore >= 50) return 'Needs Improvement';
    return 'Poor';
  }
}

class ComplianceNotifier extends StateNotifier<ComplianceState> {
  final Ref _ref;
  final Set<String> _readAlertIds = <String>{};

  ComplianceNotifier(this._ref) : super(ComplianceState.initial()) {
    refresh();
  }

  void refresh() {
    final summary = _ref.read(complianceSummaryProvider);
    final rawAlerts = _ref.read(riskAlertsProvider);
    final loading = _ref.read(intelligenceLoadingProvider);
    final errors = _ref.read(intelligenceErrorsProvider);
    final doseLogState = _ref.read(doseLogProvider);
    final healthLogState = _ref.read(healthLogProvider);
    final complianceScoreService = _ref.read(complianceScoreServiceProvider);

    final weeklyTrend = _buildWeeklyTrend(
      doseLogs: doseLogState.doseLogs,
      service: complianceScoreService,
    );

    final mappedAlerts = rawAlerts
        .map(
          (alert) => RiskAlert(
            id: alert.id,
            title: alert.title,
            description: alert.description,
            severity: alert.severity,
            createdAt: alert.detectedAt,
            isRead: _readAlertIds.contains(alert.id),
            riskType: alert.riskType,
            metadata: alert.metadata,
          ),
        )
        .toList()
      ..sort(
        (a, b) => _severityRank(b.severity).compareTo(_severityRank(a.severity)),
      );

    final weeklyScore = weeklyTrend.isEmpty
        ? 0.0
        : weeklyTrend
                .map((entry) => entry.percentage)
                .reduce((a, b) => a + b) /
            weeklyTrend.length;

    final logAdherence = _calculateHealthLogAdherence(healthLogState.logs);

    state = state.copyWith(
      isLoading: loading,
      overallScore: summary.complianceScore.clamp(0.0, 100.0),
      weeklyScore: weeklyScore.clamp(0.0, 100.0),
      medicineAdherence: summary.adherencePercentage.clamp(0.0, 100.0),
      logAdherence: logAdherence.clamp(0.0, 100.0),
      alerts: mappedAlerts,
      weeklyTrend: weeklyTrend,
      errorMessage: errors.isEmpty ? null : errors.join('\n'),
      hasDoseLogs: doseLogState.doseLogs.isNotEmpty,
      hasHealthLogs: healthLogState.logs.isNotEmpty,
    );
  }

  void markAlertRead(String id) {
    _readAlertIds.add(id);
    refresh();
  }

  void markAllRead() {
    for (final alert in state.alerts) {
      _readAlertIds.add(alert.id);
    }
    refresh();
  }

  List<WeeklyAdherence> _buildWeeklyTrend({
    required List<dynamic> doseLogs,
    required ComplianceScoreService service,
  }) {
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final trend = <WeeklyAdherence>[];

    for (int offset = 6; offset >= 0; offset--) {
      final day = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: offset));

      final score = service.calculateDailyScore(
        doseLogs: doseLogs.cast(),
        day: day,
        now: now,
      );

      trend.add(
        WeeklyAdherence(
          day: dayNames[day.weekday - 1],
          percentage: score.clamp(0.0, 100.0),
        ),
      );
    }

    return trend;
  }

  double _calculateHealthLogAdherence(List<HealthLog> logs) {
    if (logs.isEmpty) return 0.0;

    final now = DateTime.now();
    final coveredDays = <String>{};

    for (final log in logs) {
      final diff = now.difference(log.recordedAt).inDays;
      if (diff >= 0 && diff < 7) {
        final key =
            '${log.recordedAt.year}-${log.recordedAt.month}-${log.recordedAt.day}';
        coveredDays.add(key);
      }
    }

    return (coveredDays.length / 7) * 100.0;
  }

  int _severityRank(String severity) {
    switch (severity) {
      case 'high':
        return 3;
      case 'medium':
        return 2;
      default:
        return 1;
    }
  }
}