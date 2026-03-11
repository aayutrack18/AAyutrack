import '../../domain/entities/reminder.dart';

class ReminderMockDataSource {
  final List<Reminder> _reminders = [
    Reminder(
      id: 'rem_001',
      title: 'Morning Medicines',
      description: 'Take Metformin 500mg and Amlodipine 5mg',
      time: '08:00',
      repeatDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      isEnabled: true,
      type: 'medicine',
      linkedMedicineId: 'med_001',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Reminder(
      id: 'rem_002',
      title: 'Evening Medicines',
      description: 'Take Metformin 500mg',
      time: '20:00',
      repeatDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      isEnabled: true,
      type: 'medicine',
      linkedMedicineId: 'med_001',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Reminder(
      id: 'rem_003',
      title: 'Blood Sugar Check',
      description: 'Measure fasting blood sugar',
      time: '07:30',
      repeatDays: ['Mon', 'Wed', 'Fri'],
      isEnabled: true,
      type: 'measurement',
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
    ),
    Reminder(
      id: 'rem_004',
      title: 'Doctor Appointment',
      description: 'Follow-up with Dr. Sharma',
      time: '10:00',
      repeatDays: ['Fri'],
      isEnabled: false,
      type: 'appointment',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  Future<List<Reminder>> getReminders() async {
    await Future.delayed(const Duration(milliseconds: 180));
    return List.from(_reminders);
  }

  Future<void> saveReminder(Reminder reminder) async {
    await Future.delayed(const Duration(milliseconds: 160));
    _reminders.add(reminder);
  }

  Future<void> updateReminder(Reminder reminder) async {
    await Future.delayed(const Duration(milliseconds: 160));
    final idx = _reminders.indexWhere((r) => r.id == reminder.id);
    if (idx != -1) _reminders[idx] = reminder;
  }

  Future<void> deleteReminder(String id) async {
    await Future.delayed(const Duration(milliseconds: 140));
    _reminders.removeWhere((r) => r.id == id);
  }

  Future<void> toggleReminder(String id, bool isEnabled) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final idx = _reminders.indexWhere((r) => r.id == id);
    if (idx != -1) {
      _reminders[idx] = _reminders[idx].copyWith(isEnabled: isEnabled);
    }
  }
}
