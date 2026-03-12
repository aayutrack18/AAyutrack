import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── REPORT SECTION MODEL ────────────────────────────────────────────────────

class ReportSection {
  final String id;
  final String title;
  final String description;
  bool isEnabled;

  ReportSection({
    required this.id,
    required this.title,
    required this.description,
    this.isEnabled = true,
  });
}

// ─── REPORT HISTORY MODEL ────────────────────────────────────────────────────

class ReportHistoryItem {
  final String id;
  final String title;
  final String dateRange;
  final DateTime generatedAt;
  final String templateName;
  final int pageCount;

  const ReportHistoryItem({
    required this.id,
    required this.title,
    required this.dateRange,
    required this.generatedAt,
    required this.templateName,
    required this.pageCount,
  });
}

// ─── REPORT TEMPLATE MODEL ───────────────────────────────────────────────────

class ReportTemplate {
  final String id;
  final String name;
  final String description;
  final String icon;

  const ReportTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });
}

// ─── STATE ───────────────────────────────────────────────────────────────────

class ReportsState {
  final bool isLoading;
  final bool isExporting;
  final String selectedTemplateId;
  final DateTime startDate;
  final DateTime endDate;
  final List<ReportSection> sections;
  final List<ReportHistoryItem> history;
  final String? errorMessage;

  const ReportsState({
    required this.isLoading,
    required this.isExporting,
    required this.selectedTemplateId,
    required this.startDate,
    required this.endDate,
    required this.sections,
    required this.history,
    this.errorMessage,
  });

  factory ReportsState.initial() {
    final now = DateTime.now();
    return ReportsState(
      isLoading: false,
      isExporting: false,
      selectedTemplateId: 'template_doctor',
      startDate: DateTime(now.year, now.month, 1),
      endDate: now,
      sections: [
        ReportSection(
          id: 'compliance',
          title: 'Compliance Summary',
          description: 'Overall compliance score and weekly trends',
          isEnabled: true,
        ),
        ReportSection(
          id: 'medicines',
          title: 'Medicine Schedule',
          description: 'List of active medicines and adherence',
          isEnabled: true,
        ),
        ReportSection(
          id: 'vitals',
          title: 'Health Vitals',
          description: 'BP, sugar, heart rate, weight readings',
          isEnabled: true,
        ),
        ReportSection(
          id: 'reminders',
          title: 'Reminders Log',
          description: 'Reminder completion status',
          isEnabled: false,
        ),
        ReportSection(
          id: 'alerts',
          title: 'Risk Alerts',
          description: 'Active and resolved risk alerts',
          isEnabled: true,
        ),
      ],
      history: [
        ReportHistoryItem(
          id: 'rh_001',
          title: "Doctor's Summary – Feb 2025",
          dateRange: '1 Feb – 28 Feb 2025',
          generatedAt: DateTime.now().subtract(const Duration(days: 14)),
          templateName: "Doctor's Report",
          pageCount: 3,
        ),
        ReportHistoryItem(
          id: 'rh_002',
          title: 'Monthly Compliance – Jan 2025',
          dateRange: '1 Jan – 31 Jan 2025',
          generatedAt: DateTime.now().subtract(const Duration(days: 45)),
          templateName: 'Compliance Report',
          pageCount: 2,
        ),
        ReportHistoryItem(
          id: 'rh_003',
          title: 'Health Vitals – Dec 2024',
          dateRange: '1 Dec – 31 Dec 2024',
          generatedAt: DateTime.now().subtract(const Duration(days: 75)),
          templateName: 'Vitals Report',
          pageCount: 4,
        ),
      ],
    );
  }

  ReportsState copyWith({
    bool? isLoading,
    bool? isExporting,
    String? selectedTemplateId,
    DateTime? startDate,
    DateTime? endDate,
    List<ReportSection>? sections,
    List<ReportHistoryItem>? history,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ReportsState(
      isLoading: isLoading ?? this.isLoading,
      isExporting: isExporting ?? this.isExporting,
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sections: sections ?? this.sections,
      history: history ?? this.history,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  List<ReportSection> get enabledSections =>
      sections.where((s) => s.isEnabled).toList();

  bool get hasError => errorMessage != null;
}

// ─── NOTIFIER ────────────────────────────────────────────────────────────────

class ReportsNotifier extends StateNotifier<ReportsState> {
  ReportsNotifier() : super(ReportsState.initial());

  void setTemplate(String templateId) {
    state = state.copyWith(selectedTemplateId: templateId);
  }

  void setDateRange(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void toggleSection(String sectionId) {
    final updated = state.sections.map((s) {
      if (s.id == sectionId) {
        return ReportSection(
          id: s.id,
          title: s.title,
          description: s.description,
          isEnabled: !s.isEnabled,
        );
      }
      return s;
    }).toList();
    state = state.copyWith(sections: updated);
  }

  Future<void> generateReport() async {
    state = state.copyWith(isExporting: true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isExporting: false);
  }

  void deleteHistory(String id) {
    final updated = state.history.where((h) => h.id != id).toList();
    state = state.copyWith(history: updated);
  }
}

// ─── PROVIDER ────────────────────────────────────────────────────────────────

final reportsProvider =
    StateNotifierProvider<ReportsNotifier, ReportsState>((ref) {
  return ReportsNotifier();
});

final reportTemplatesProvider = Provider<List<ReportTemplate>>((ref) {
  return const [
    ReportTemplate(
      id: 'template_doctor',
      name: "Doctor's Report",
      description: 'Shareable clinical summary for your physician',
      icon: '🩺',
    ),
    ReportTemplate(
      id: 'template_compliance',
      name: 'Compliance Report',
      description: 'Detailed medicine adherence and trends',
      icon: '📊',
    ),
    ReportTemplate(
      id: 'template_vitals',
      name: 'Vitals Summary',
      description: 'All health readings in one document',
      icon: '❤️',
    ),
  ];
});
