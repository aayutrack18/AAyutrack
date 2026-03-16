import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aayutrack/core/services/notification_service.dart';
import 'package:aayutrack/core/sync/sync_providers.dart';
import 'package:aayutrack/features/reminders/data/datasources/reminder_local_datasource.dart';
import 'package:aayutrack/features/reminders/data/repositories/reminder_repository_impl.dart';
import 'package:aayutrack/features/reminders/domain/entities/reminder.dart';
import 'package:aayutrack/features/reminders/domain/repositories/reminder_repository.dart';

final reminderNotificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

final reminderLocalDataSourceProvider =
    Provider<ReminderLocalDataSource>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return ReminderLocalDataSource(
    remindersDao: database.remindersDao,
  );
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepositoryImpl(
    localDataSource: ref.watch(reminderLocalDataSourceProvider),
    syncQueueService: ref.watch(syncQueueServiceProvider),
    notificationService: ref.watch(reminderNotificationServiceProvider),
  );
});

final reminderProvider =
    StateNotifierProvider<ReminderNotifier, ReminderState>((ref) {
  return ReminderNotifier(ref.watch(reminderRepositoryProvider));
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
  final ReminderRepository _repository;

  ReminderNotifier(this._repository) : super(ReminderState.initial()) {
    loadReminders();
  }

  Future<void> loadReminders() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final reminders = await _repository.getReminders();
      state = state.copyWith(isLoading: false, reminders: reminders);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addReminder(Reminder reminder) async {
    try {
      await _repository.saveReminder(reminder);
      await loadReminders();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> updateReminder(Reminder reminder) async {
    try {
      await _repository.updateReminder(reminder);
      await loadReminders();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> deleteReminder(String id) async {
    try {
      await _repository.deleteReminder(id);
      await loadReminders();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> toggleReminder(String id, bool isEnabled) async {
    try {
      await _repository.toggleReminder(id, isEnabled);
      await loadReminders();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}