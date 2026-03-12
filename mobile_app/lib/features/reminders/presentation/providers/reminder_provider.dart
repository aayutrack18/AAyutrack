import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aayutrack/features/reminders/data/datasources/reminder_mock_datasource.dart';
import 'package:aayutrack/features/reminders/domain/entities/reminder.dart';

final reminderDataSourceProvider = Provider<ReminderMockDataSource>((ref) {
  return ReminderMockDataSource();
});

final reminderProvider =
    StateNotifierProvider<ReminderNotifier, ReminderState>((ref) {
  return ReminderNotifier(ref.watch(reminderDataSourceProvider));
});

class ReminderState {
  final bool isLoading;
  final List<Reminder> reminders;
  final String? errorMessage;

  const ReminderState({
    required this.isLoading,
    required this.reminders,
    this.errorMessage,
  });

  factory ReminderState.initial() =>
      const ReminderState(isLoading: false, reminders: []);

  ReminderState copyWith({
    bool? isLoading,
    List<Reminder>? reminders,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ReminderState(
      isLoading: isLoading ?? this.isLoading,
      reminders: reminders ?? this.reminders,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  List<Reminder> get enabledReminders =>
      reminders.where((r) => r.isEnabled).toList();

  bool get hasError => errorMessage != null;
}

class ReminderNotifier extends StateNotifier<ReminderState> {
  final ReminderMockDataSource _ds;

  ReminderNotifier(this._ds) : super(ReminderState.initial()) {
    loadReminders();
  }

  Future<void> loadReminders() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final reminders = await _ds.getReminders();
      state = state.copyWith(isLoading: false, reminders: reminders);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addReminder(Reminder reminder) async {
    try {
      await _ds.saveReminder(reminder);
      await loadReminders();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> updateReminder(Reminder reminder) async {
    try {
      await _ds.updateReminder(reminder);
      await loadReminders();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> deleteReminder(String id) async {
    try {
      await _ds.deleteReminder(id);
      await loadReminders();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> toggleReminder(String id, bool isEnabled) async {
    try {
      await _ds.toggleReminder(id, isEnabled);
      await loadReminders();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}
