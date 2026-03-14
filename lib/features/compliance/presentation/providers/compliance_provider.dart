import 'package:flutter_riverpod/flutter_riverpod.dart';

final complianceProvider =
    StateNotifierProvider<ComplianceNotifier, ComplianceState>((ref) {
  return ComplianceNotifier();
});

class RiskAlert {
  final String id;
  final String title;
  final String description;
  final String severity; // low, medium, high
  final DateTime createdAt;
  bool isRead;

  RiskAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.createdAt,
    this.isRead = false,
  });
}

class WeeklyAdherence {
  final String day;
  final double percentage;

  const WeeklyAdherence({required this.day, required this.percentage});
}

class ComplianceState {
  final bool isLoading;
  final double overallScore;
  final double weeklyScore;
  final double medicineAdherence;
  final double logAdherence;
  final List<RiskAlert> alerts;
  final List<WeeklyAdherence> weeklyTrend;

  const ComplianceState({
    required this.isLoading,
    required this.overallScore,
    required this.weeklyScore,
    required this.medicineAdherence,
    required this.logAdherence,
    required this.alerts,
    required this.weeklyTrend,
  });

  factory ComplianceState.initial() => ComplianceState(
        isLoading: false,
        overallScore: 78.0,
        weeklyScore: 83.0,
        medicineAdherence: 85.0,
        logAdherence: 71.0,
        alerts: [
          RiskAlert(
            id: 'alert_001',
            title: 'Missed Evening Dose',
            description:
                'You missed your Metformin evening dose yesterday. Consistent dosing is important for blood sugar control.',
            severity: 'medium',
            createdAt: DateTime.now().subtract(const Duration(hours: 12)),
          ),
          RiskAlert(
            id: 'alert_002',
            title: 'Blood Pressure Elevated',
            description:
                'Your last 2 blood pressure readings were above 130/85. Consider consulting your doctor.',
            severity: 'high',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          RiskAlert(
            id: 'alert_003',
            title: 'No Blood Sugar Log Today',
            description:
                'You haven\'t logged your blood sugar today. Keep up your monitoring routine.',
            severity: 'low',
            createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          ),
        ],
        weeklyTrend: const [
          WeeklyAdherence(day: 'Mon', percentage: 100),
          WeeklyAdherence(day: 'Tue', percentage: 75),
          WeeklyAdherence(day: 'Wed', percentage: 100),
          WeeklyAdherence(day: 'Thu', percentage: 50),
          WeeklyAdherence(day: 'Fri', percentage: 100),
          WeeklyAdherence(day: 'Sat', percentage: 75),
          WeeklyAdherence(day: 'Sun', percentage: 83),
        ],
      );

  int get unreadAlertCount => alerts.where((a) => !a.isRead).length;

  String get scoreLabel {
    if (overallScore >= 90) return 'Excellent';
    if (overallScore >= 75) return 'Good';
    if (overallScore >= 50) return 'Needs Improvement';
    return 'Poor';
  }

  ComplianceState copyWith({
    bool? isLoading,
    double? overallScore,
    List<RiskAlert>? alerts,
  }) {
    return ComplianceState(
      isLoading: isLoading ?? this.isLoading,
      overallScore: overallScore ?? this.overallScore,
      weeklyScore: weeklyScore,
      medicineAdherence: medicineAdherence,
      logAdherence: logAdherence,
      alerts: alerts ?? this.alerts,
      weeklyTrend: weeklyTrend,
    );
  }
}

class ComplianceNotifier extends StateNotifier<ComplianceState> {
  ComplianceNotifier() : super(ComplianceState.initial());

  void markAlertRead(String id) {
    final updated = state.alerts.map((a) {
      if (a.id == id) a.isRead = true;
      return a;
    }).toList();
    state = state.copyWith(alerts: updated);
  }

  void markAllRead() {
    final updated = state.alerts.map((a) {
      a.isRead = true;
      return a;
    }).toList();
    state = state.copyWith(alerts: updated);
  }
}
