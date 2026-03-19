import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aayutrack/core/database/app_database.dart';
import 'package:aayutrack/core/sync/sync_providers.dart';
import 'package:aayutrack/features/compliance/data/models/dose_log_model.dart';
import 'package:aayutrack/features/health_logs/data/models/health_log_model.dart';
import 'package:aayutrack/features/health_logs/domain/entities/health_log.dart';
import 'package:aayutrack/features/medicine/data/models/medicine_model.dart';
import 'package:aayutrack/features/reminders/data/models/reminder_model.dart';

final demoDataSeedServiceProvider = Provider<DemoDataSeedService>((ref) {
  return DemoDataSeedService(ref.watch(appDatabaseProvider));
});

class DemoDataSeedService {
  DemoDataSeedService(this._database);

  final AppDatabase _database;

  static const String _patientId = 'default_patient';

  Future<void> seedIfNeeded() async {
    final existingMedicines = await _database.medicinesDao.getMedicinesByPatientId(
      _patientId,
    );
    final existingReminders = await _database.remindersDao.getRemindersByPatientId(
      _patientId,
    );
    final existingHealthLogs = await _database.healthLogsDao.getHealthLogsByPatientId(
      _patientId,
    );
    final existingDoseLogs = await _database.doseLogsDao.getDoseLogsByPatientId(
      _patientId,
    );

    final shouldSeedMedicines = existingMedicines.isEmpty;
    final shouldSeedReminders = existingReminders.isEmpty;
    final shouldSeedHealthLogs = existingHealthLogs.isEmpty;
    final shouldSeedDoseLogs = existingDoseLogs.isEmpty;

    if (!shouldSeedMedicines &&
        !shouldSeedReminders &&
        !shouldSeedHealthLogs &&
        !shouldSeedDoseLogs) {
      return;
    }

    final medicines = _buildMedicines();
    final reminders = _buildReminders();
    final healthLogs = _buildHealthLogs();
    final doseLogs = _buildDoseLogs();

    await _database.transaction(() async {
      if (shouldSeedMedicines) {
        for (final medicine in medicines) {
          await _database.medicinesDao.upsertMedicine(medicine.toCompanion());
        }
      }

      if (shouldSeedReminders) {
        for (final reminder in reminders) {
          await _database.remindersDao.upsertReminder(reminder.toCompanion());
        }
      }

      if (shouldSeedHealthLogs) {
        for (final log in healthLogs) {
          await _database.healthLogsDao.upsertHealthLog(log.toCompanion());
        }
      }

      if (shouldSeedDoseLogs) {
        for (final doseLog in doseLogs) {
          await _database.doseLogsDao.upsertDoseLog(doseLog.toCompanion());
        }
      }
    });
  }

  List<MedicineModel> _buildMedicines() {
    final now = DateTime.now();

    return [
      MedicineModel(
        id: 'demo_med_metformin',
        patientId: _patientId,
        name: 'Metformin',
        dosage: '500 mg',
        frequency: 'Twice Daily',
        form: 'Tablet',
        instructions: 'Take after breakfast and dinner.',
        scheduledTimes: const ['08:00', '20:00'],
        startDate: now.subtract(const Duration(days: 30)),
        isActive: true,
        color: '#2563EB',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(hours: 8)),
      ),
      MedicineModel(
        id: 'demo_med_amlodipine',
        patientId: _patientId,
        name: 'Amlodipine',
        dosage: '5 mg',
        frequency: 'Once Daily',
        form: 'Tablet',
        instructions: 'Take in the morning after checking blood pressure.',
        scheduledTimes: const ['09:00'],
        startDate: now.subtract(const Duration(days: 45)),
        isActive: true,
        color: '#14B8A6',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now.subtract(const Duration(hours: 12)),
      ),
      MedicineModel(
        id: 'demo_med_atorvastatin',
        patientId: _patientId,
        name: 'Atorvastatin',
        dosage: '20 mg',
        frequency: 'Once Daily',
        form: 'Tablet',
        instructions: 'Take at night. Avoid grapefruit juice.',
        scheduledTimes: const ['21:00'],
        startDate: now.subtract(const Duration(days: 60)),
        isActive: true,
        color: '#8B5CF6',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      MedicineModel(
        id: 'demo_med_vitamin_d3',
        patientId: _patientId,
        name: 'Vitamin D3',
        dosage: '1000 IU',
        frequency: 'Once Daily',
        form: 'Capsule',
        instructions: 'Take with lunch for better absorption.',
        scheduledTimes: const ['13:00'],
        startDate: now.subtract(const Duration(days: 20)),
        isActive: false,
        color: '#F59E0B',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }

  List<ReminderModel> _buildReminders() {
    final now = DateTime.now();

    return [
      ReminderModel(
        id: 'demo_rem_morning_meds',
        patientId: _patientId,
        title: 'Morning medicines',
        description: 'Take Metformin 500 mg and check your BP before Amlodipine.',
        time: '08:00',
        repeatDays: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        isEnabled: true,
        type: 'medicine',
        linkedMedicineId: 'demo_med_metformin',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 14)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      ReminderModel(
        id: 'demo_rem_bp',
        patientId: _patientId,
        title: 'Check blood pressure',
        description: 'Record BP after sitting calmly for 5 minutes.',
        time: '08:45',
        repeatDays: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        isEnabled: true,
        type: 'measurement',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      ReminderModel(
        id: 'demo_rem_evening_meds',
        patientId: _patientId,
        title: 'Evening medicines',
        description: 'Take Metformin after dinner and Atorvastatin before sleep.',
        time: '20:00',
        repeatDays: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        isEnabled: true,
        type: 'medicine',
        linkedMedicineId: 'demo_med_metformin',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 14)),
        updatedAt: now.subtract(const Duration(hours: 18)),
      ),
      ReminderModel(
        id: 'demo_rem_walk',
        patientId: _patientId,
        title: '15-minute evening walk',
        description: 'Light walk after dinner to support sugar control.',
        time: '18:30',
        repeatDays: const ['Mon', 'Wed', 'Fri', 'Sat'],
        isEnabled: true,
        type: 'custom',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  List<HealthLogModel> _buildHealthLogs() {
    final now = DateTime.now();

    return [
      HealthLogModel(
        id: 'demo_hl_bp_today',
        patientId: _patientId,
        type: MetricType.bloodPressure,
        value: 128,
        secondaryValue: 82,
        notes: 'Morning reading before medication.',
        recordedAt: now.subtract(const Duration(hours: 2)),
        source: 'manual',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      HealthLogModel(
        id: 'demo_hl_sugar_today',
        patientId: _patientId,
        type: MetricType.bloodSugar,
        value: 104,
        notes: 'Fasting value.',
        recordedAt: now.subtract(const Duration(hours: 3)),
        source: 'manual',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now.subtract(const Duration(hours: 3)),
      ),
      HealthLogModel(
        id: 'demo_hl_hr_today',
        patientId: _patientId,
        type: MetricType.heartRate,
        value: 74,
        notes: 'Captured from phone sensor demo.',
        recordedAt: now.subtract(const Duration(hours: 1)),
        source: 'wearable',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      HealthLogModel(
        id: 'demo_hl_oxygen_today',
        patientId: _patientId,
        type: MetricType.oxygen,
        value: 98,
        notes: '',
        recordedAt: now.subtract(const Duration(hours: 4)),
        source: 'wearable',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(hours: 4)),
      ),
      HealthLogModel(
        id: 'demo_hl_temp_yesterday',
        patientId: _patientId,
        type: MetricType.temperature,
        value: 36.7,
        notes: 'Normal temperature.',
        recordedAt: now.subtract(const Duration(days: 1, hours: 1)),
        source: 'manual',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 1, hours: 1)),
        updatedAt: now.subtract(const Duration(days: 1, hours: 1)),
      ),
      HealthLogModel(
        id: 'demo_hl_weight_week',
        patientId: _patientId,
        type: MetricType.weight,
        value: 72.4,
        notes: 'Weekly check-in.',
        recordedAt: now.subtract(const Duration(days: 2, hours: 3)),
        source: 'manual',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 2, hours: 3)),
        updatedAt: now.subtract(const Duration(days: 2, hours: 3)),
      ),
      HealthLogModel(
        id: 'demo_hl_mood_today',
        patientId: _patientId,
        type: MetricType.mood,
        value: 4,
        notes: 'Feeling good and following routine well today.',
        recordedAt: now.subtract(const Duration(hours: 5)),
        source: 'manual',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(hours: 5)),
        updatedAt: now.subtract(const Duration(hours: 5)),
      ),
      HealthLogModel(
        id: 'demo_hl_bp_yesterday',
        patientId: _patientId,
        type: MetricType.bloodPressure,
        value: 132,
        secondaryValue: 84,
        notes: 'Slightly high after poor sleep.',
        recordedAt: now.subtract(const Duration(days: 1, hours: 2)),
        source: 'manual',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        updatedAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      HealthLogModel(
        id: 'demo_hl_sugar_two_days',
        patientId: _patientId,
        type: MetricType.bloodSugar,
        value: 118,
        notes: 'Post-breakfast follow-up.',
        recordedAt: now.subtract(const Duration(days: 2, hours: 4)),
        source: 'manual',
        isSynced: true,
        isDeleted: false,
        createdAt: now.subtract(const Duration(days: 2, hours: 4)),
        updatedAt: now.subtract(const Duration(days: 2, hours: 4)),
      ),
    ];
  }

  List<DoseLogModel> _buildDoseLogs() {
    final now = DateTime.now();
    final entries = <DoseLogModel>[];

    void addDose({
      required String id,
      required String medicineId,
      String? reminderId,
      required DateTime scheduledAt,
      DateTime? takenAt,
      required String status,
      String? notes,
    }) {
      entries.add(
        DoseLogModel(
          id: id,
          patientId: _patientId,
          medicineId: medicineId,
          reminderId: reminderId,
          scheduledAt: scheduledAt,
          takenAt: takenAt,
          status: status,
          notes: notes,
          isSynced: true,
          isDeleted: false,
          createdAt: scheduledAt.subtract(const Duration(minutes: 10)),
          updatedAt: takenAt ?? scheduledAt,
        ),
      );
    }

    for (int daysAgo = 6; daysAgo >= 0; daysAgo--) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: daysAgo));

      final morningMetformin = DateTime(day.year, day.month, day.day, 8, 0);
      final morningAmlodipine = DateTime(day.year, day.month, day.day, 9, 0);
      final eveningMetformin = DateTime(day.year, day.month, day.day, 20, 0);
      final nightAtorvastatin = DateTime(day.year, day.month, day.day, 21, 0);

      addDose(
        id: 'demo_dose_metformin_am_$daysAgo',
        medicineId: 'demo_med_metformin',
        reminderId: 'demo_rem_morning_meds',
        scheduledAt: morningMetformin,
        takenAt: daysAgo == 1
            ? null
            : morningMetformin.add(const Duration(minutes: 12)),
        status: daysAgo == 1 ? 'missed' : 'taken',
        notes: daysAgo == 1 ? 'Missed during travel.' : 'Taken with breakfast.',
      );

      addDose(
        id: 'demo_dose_amlodipine_$daysAgo',
        medicineId: 'demo_med_amlodipine',
        scheduledAt: morningAmlodipine,
        takenAt: daysAgo == 4
            ? null
            : morningAmlodipine.add(const Duration(minutes: 18)),
        status: daysAgo == 4 ? 'skipped' : 'taken',
        notes: daysAgo == 4 ? 'BP was low, skipped after doctor advice.' : null,
      );

      if (day.isBefore(DateTime(now.year, now.month, now.day)) ||
          eveningMetformin.isBefore(now)) {
        addDose(
          id: 'demo_dose_metformin_pm_$daysAgo',
          medicineId: 'demo_med_metformin',
          reminderId: 'demo_rem_evening_meds',
          scheduledAt: eveningMetformin,
          takenAt: daysAgo == 2
              ? null
              : eveningMetformin.add(const Duration(minutes: 20)),
          status: daysAgo == 2 ? 'missed' : 'taken',
          notes: daysAgo == 2 ? 'Dinner was delayed.' : 'Taken after dinner.',
        );
      }

      if (day.isBefore(DateTime(now.year, now.month, now.day)) ||
          nightAtorvastatin.isBefore(now)) {
        final isTodayPending = daysAgo == 0 && nightAtorvastatin.isAfter(now);

        addDose(
          id: 'demo_dose_atorvastatin_$daysAgo',
          medicineId: 'demo_med_atorvastatin',
          scheduledAt: nightAtorvastatin,
          takenAt: isTodayPending
              ? null
              : nightAtorvastatin.add(const Duration(minutes: 8)),
          status: isTodayPending ? 'scheduled' : 'taken',
          notes: isTodayPending ? 'Upcoming bedtime dose.' : null,
        );
      }
    }

    entries.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
    return entries;
  }
}