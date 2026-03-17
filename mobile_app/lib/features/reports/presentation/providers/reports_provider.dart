import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class ReportHistoryItem {
  final String id;
  final String title;
  final String dateRange;
  final DateTime generatedAt;
  final String templateName;
  final int pageCount;
  final String? filePath;

  const ReportHistoryItem({
    required this.id,
    required this.title,
    required this.dateRange,
    required this.generatedAt,
    required this.templateName,
    required this.pageCount,
    this.filePath,
  });
}

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

class PdfDesignState {
  final String colorSchemeId;
  final bool showLogo;
  final bool showPageNumbers;
  final bool showPatientPhoto;
  final bool includeDoctorSummary;
  final String doctorName;
  final String doctorNote;

  const PdfDesignState({
    this.colorSchemeId = 'blue',
    this.showLogo = true,
    this.showPageNumbers = true,
    this.showPatientPhoto = false,
    this.includeDoctorSummary = true,
    this.doctorName = '',
    this.doctorNote = '',
  });

  PdfDesignState copyWith({
    String? colorSchemeId,
    bool? showLogo,
    bool? showPageNumbers,
    bool? showPatientPhoto,
    bool? includeDoctorSummary,
    String? doctorName,
    String? doctorNote,
  }) {
    return PdfDesignState(
      colorSchemeId: colorSchemeId ?? this.colorSchemeId,
      showLogo: showLogo ?? this.showLogo,
      showPageNumbers: showPageNumbers ?? this.showPageNumbers,
      showPatientPhoto: showPatientPhoto ?? this.showPatientPhoto,
      includeDoctorSummary: includeDoctorSummary ?? this.includeDoctorSummary,
      doctorName: doctorName ?? this.doctorName,
      doctorNote: doctorNote ?? this.doctorNote,
    );
  }
}

class ReportsState {
  final bool isLoading;
  final bool isExporting;
  final bool exportSuccess;
  final String selectedTemplateId;
  final DateTime startDate;
  final DateTime endDate;
  final List<ReportSection> sections;
  final List<ReportHistoryItem> history;
  final PdfDesignState pdfDesign;
  final String? errorMessage;

  const ReportsState({
    required this.isLoading,
    required this.isExporting,
    required this.exportSuccess,
    required this.selectedTemplateId,
    required this.startDate,
    required this.endDate,
    required this.sections,
    required this.history,
    required this.pdfDesign,
    this.errorMessage,
  });

  factory ReportsState.initial() {
    final now = DateTime.now();
    return ReportsState(
      isLoading: false,
      isExporting: false,
      exportSuccess: false,
      selectedTemplateId: 'template_doctor',
      startDate: DateTime(now.year, now.month, 1),
      endDate: now,
      pdfDesign: const PdfDesignState(),
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
      history: const [],
    );
  }

  ReportsState copyWith({
    bool? isLoading,
    bool? isExporting,
    bool? exportSuccess,
    String? selectedTemplateId,
    DateTime? startDate,
    DateTime? endDate,
    List<ReportSection>? sections,
    List<ReportHistoryItem>? history,
    PdfDesignState? pdfDesign,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ReportsState(
      isLoading: isLoading ?? this.isLoading,
      isExporting: isExporting ?? this.isExporting,
      exportSuccess: exportSuccess ?? this.exportSuccess,
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sections: sections ?? this.sections,
      history: history ?? this.history,
      pdfDesign: pdfDesign ?? this.pdfDesign,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  List<ReportSection> get enabledSections =>
      sections.where((s) => s.isEnabled).toList();

  bool get hasError => errorMessage != null;
}

class ReportsNotifier extends StateNotifier<ReportsState> {
  ReportsNotifier() : super(ReportsState.initial());

  void setTemplate(String templateId) {
    state = state.copyWith(selectedTemplateId: templateId, exportSuccess: false);
  }

  void setDateRange(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end, exportSuccess: false);
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

  void updatePdfDesign(PdfDesignState design) {
    state = state.copyWith(pdfDesign: design);
  }

  void setExporting(bool value) {
    state = state.copyWith(
      isExporting: value,
      exportSuccess: value ? false : state.exportSuccess,
    );
  }

  void addGeneratedReport({
    required String title,
    required String dateRange,
    required int pageCount,
    required String filePath,
  }) {
    String templateName = 'Report';

    switch (state.selectedTemplateId) {
      case 'template_doctor':
        templateName = "Doctor's Report";
        break;
      case 'template_compliance':
        templateName = 'Compliance Report';
        break;
      case 'template_vitals':
        templateName = 'Vitals Summary';
        break;
    }

    final newItem = ReportHistoryItem(
      id: 'rh_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      dateRange: dateRange,
      generatedAt: DateTime.now(),
      templateName: templateName,
      pageCount: pageCount,
      filePath: filePath,
    );

    state = state.copyWith(
      isExporting: false,
      exportSuccess: true,
      history: [newItem, ...state.history],
    );
  }

  void clearExportSuccess() {
    state = state.copyWith(exportSuccess: false);
  }

  void deleteHistory(String id) {
    final updated = state.history.where((h) => h.id != id).toList();
    state = state.copyWith(history: updated);
  }
}

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