import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:aayutrack/features/medicine/domain/entities/medicine.dart';
import 'package:aayutrack/features/reminders/domain/entities/reminder.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static const String _medicineChannelId = 'medicine_alarm_channel';
  static const String _medicineChannelName = 'Medicine Alarm Reminders';
  static const String _medicineChannelDescription =
      'Exact alarm-style reminders for scheduled medicines';

  static const String _reminderChannelId = 'general_alarm_channel';
  static const String _reminderChannelName = 'General Alarm Reminders';
  static const String _reminderChannelDescription =
      'Exact high-priority reminders for appointments and custom alerts';

  Future<void> ensureInitialized() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    await _configureLocalTimezone();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    const medicineChannel = AndroidNotificationChannel(
      _medicineChannelId,
      _medicineChannelName,
      description: _medicineChannelDescription,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    const reminderChannel = AndroidNotificationChannel(
      _reminderChannelId,
      _reminderChannelName,
      description: _reminderChannelDescription,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(medicineChannel);
    await androidPlugin?.createNotificationChannel(reminderChannel);

    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    await ensureInitialized();

    bool androidGranted = true;
    bool iosGranted = true;

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      androidGranted =
          await androidPlugin.requestNotificationsPermission() ?? false;

      try {
        await androidPlugin.requestExactAlarmsPermission();
      } catch (_) {}
    }

    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (iosPlugin != null) {
      iosGranted = await iosPlugin.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }

    final macPlugin = _plugin.resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>();

    if (macPlugin != null) {
      await macPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    return androidGranted && iosGranted;
  }

  Future<void> showInstantMedicineAlarm({
    required String medicineId,
    required String medicineName,
    required String dosage,
    required String time,
  }) async {
    await ensureInitialized();

    final notificationId = _medicineNotificationId(medicineId, time);

    await _plugin.show(
      notificationId,
      'Time to take $medicineName',
      dosage.trim().isNotEmpty ? '$dosage • Scheduled at $time' : 'Scheduled at $time',
      _medicineAlarmDetails(),
      payload: jsonEncode({
        'type': 'medicine_reminder',
        'medicineId': medicineId,
        'medicineName': medicineName,
        'dosage': dosage,
        'time': time,
      }),
    );
  }

  Future<void> showInstantReminderAlarm({
    required String reminderId,
    required String title,
    required String description,
    required String time,
    required String reminderType,
  }) async {
    await ensureInitialized();

    final notificationId = _reminderNotificationId(reminderId);

    await _plugin.show(
      notificationId,
      title,
      description.trim().isNotEmpty ? description : 'Scheduled at $time',
      _generalAlarmDetails(),
      payload: jsonEncode({
        'type': 'general_reminder',
        'reminderId': reminderId,
        'title': title,
        'description': description,
        'time': time,
        'reminderType': reminderType,
      }),
    );
  }

  Future<void> scheduleMedicineReminders(Medicine medicine) async {
    await ensureInitialized();

    if (!medicine.isActive ||
        medicine.isDeleted ||
        medicine.scheduledTimes.isEmpty) {
      await cancelMedicineReminders(medicine.id);
      return;
    }

    final granted = await requestPermissions();
    if (!granted) {
      throw Exception(
        'Notification permission not granted. Please allow notifications first.',
      );
    }

    await cancelMedicineReminders(medicine.id);

    final scheduleMode = await _resolveAndroidScheduleMode();

    for (final time in medicine.scheduledTimes) {
      final parsed = _parseTime(time);
      if (parsed == null) continue;

      final notificationId = _medicineNotificationId(medicine.id, time);

      final payload = jsonEncode({
        'type': 'medicine_reminder',
        'medicineId': medicine.id,
        'medicineName': medicine.name,
        'dosage': medicine.dosage,
        'time': time,
      });

      await _plugin.zonedSchedule(
        notificationId,
        'Time to take ${medicine.name}',
        medicine.dosage.isNotEmpty
            ? '${medicine.dosage} • Scheduled at $time'
            : 'Scheduled at $time',
        _nextInstanceOfTime(parsed.$1, parsed.$2),
        _medicineAlarmDetails(),
        androidScheduleMode: scheduleMode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    }
  }

  Future<void> cancelMedicineReminders(String medicineId) async {
    await ensureInitialized();

    final pending = await _plugin.pendingNotificationRequests();

    for (final request in pending) {
      final payload = request.payload;
      if (payload == null || payload.isEmpty) continue;

      try {
        final decoded = jsonDecode(payload);
        if (decoded is Map<String, dynamic> &&
            decoded['type'] == 'medicine_reminder' &&
            decoded['medicineId'] == medicineId) {
          await _plugin.cancel(request.id);
        }
      } catch (_) {}
    }
  }

  Future<void> scheduleReminderNotifications(Reminder reminder) async {
    await ensureInitialized();

    if (!reminder.isEnabled || reminder.isDeleted) {
      await cancelReminderNotifications(reminder.id);
      return;
    }

    final granted = await requestPermissions();
    if (!granted) {
      throw Exception(
        'Notification permission not granted. Please allow notifications first.',
      );
    }

    await cancelReminderNotifications(reminder.id);

    final parsed = _parseTime(reminder.time);
    if (parsed == null) return;

    final scheduleMode = await _resolveAndroidScheduleMode();

    final body = reminder.description.trim().isNotEmpty
        ? reminder.description.trim()
        : 'Scheduled at ${reminder.time}';

    final payload = jsonEncode({
      'type': 'general_reminder',
      'reminderId': reminder.id,
      'title': reminder.title,
      'description': reminder.description,
      'time': reminder.time,
      'repeatDays': reminder.repeatDays,
      'reminderType': reminder.type,
      'linkedMedicineId': reminder.linkedMedicineId,
    });

    if (reminder.repeatDays.length == 7) {
      await _plugin.zonedSchedule(
        _reminderNotificationId(reminder.id),
        reminder.title,
        body,
        _nextInstanceOfTime(parsed.$1, parsed.$2),
        _generalAlarmDetails(),
        androidScheduleMode: scheduleMode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
      return;
    }

    if (reminder.repeatDays.isEmpty) {
      await _plugin.zonedSchedule(
        _reminderNotificationId(reminder.id),
        reminder.title,
        body,
        _nextInstanceOfTime(parsed.$1, parsed.$2),
        _generalAlarmDetails(),
        androidScheduleMode: scheduleMode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
      return;
    }

    for (final day in reminder.repeatDays) {
      final weekday = _weekdayFromDayName(day);
      if (weekday == null) continue;

      final requestId = _reminderNotificationId('${reminder.id}_$day');

      await _plugin.zonedSchedule(
        requestId,
        reminder.title,
        body,
        _nextInstanceOfWeekdayTime(weekday, parsed.$1, parsed.$2),
        _generalAlarmDetails(),
        androidScheduleMode: scheduleMode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: payload,
      );
    }
  }

  Future<void> cancelReminderNotifications(String reminderId) async {
    await ensureInitialized();

    final pending = await _plugin.pendingNotificationRequests();

    for (final request in pending) {
      final payload = request.payload;
      if (payload == null || payload.isEmpty) continue;

      try {
        final decoded = jsonDecode(payload);
        if (decoded is Map<String, dynamic> &&
            decoded['type'] == 'general_reminder' &&
            decoded['reminderId'] == reminderId) {
          await _plugin.cancel(request.id);
        }
      } catch (_) {}
    }
  }

  Future<void> cancelAllScheduledReminders() async {
    await ensureInitialized();
    await _plugin.cancelAll();
  }

  NotificationDetails _medicineAlarmDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _medicineChannelId,
        _medicineChannelName,
        channelDescription: _medicineChannelDescription,
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        fullScreenIntent: true,
        autoCancel: false,
        ongoing: true,
        playSound: true,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 1000, 500, 1000, 500, 1000]),
        ticker: 'Medicine Alarm',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      macOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  NotificationDetails _generalAlarmDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _reminderChannelId,
        _reminderChannelName,
        channelDescription: _reminderChannelDescription,
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        fullScreenIntent: true,
        autoCancel: false,
        ongoing: true,
        playSound: true,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 1000, 500, 1000, 500, 1000]),
        ticker: 'Reminder Alarm',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      macOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<AndroidScheduleMode> _resolveAndroidScheduleMode() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) {
      return AndroidScheduleMode.inexactAllowWhileIdle;
    }

    try {
      final canScheduleExact =
          await androidPlugin.canScheduleExactNotifications() ?? false;

      if (canScheduleExact) {
        return AndroidScheduleMode.exactAllowWhileIdle;
      }

      await androidPlugin.requestExactAlarmsPermission();

      final canScheduleAfterRequest =
          await androidPlugin.canScheduleExactNotifications() ?? false;

      if (canScheduleAfterRequest) {
        return AndroidScheduleMode.exactAllowWhileIdle;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Exact alarm permission flow failed: $e');
      }
    }

    return AndroidScheduleMode.inexactAllowWhileIdle;
  }

 Future<void> _configureLocalTimezone() async {
  try {
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    final location = tz.getLocation(timezoneInfo.identifier);
    tz.setLocalLocation(location);
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Failed to configure timezone: $e');
    }
    tz.setLocalLocation(tz.getLocation('UTC'));
  }
}

  (int, int)? _parseTime(String raw) {
    final normalized = raw.trim();

    if (!normalized.contains(':')) return null;

    final parts = normalized.split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

    return (hour, minute);
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  tz.TZDateTime _nextInstanceOfWeekdayTime(
    int weekday,
    int hour,
    int minute,
  ) {
    var scheduled = _nextInstanceOfTime(hour, minute);

    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
      scheduled = tz.TZDateTime(
        tz.local,
        scheduled.year,
        scheduled.month,
        scheduled.day,
        hour,
        minute,
      );
    }

    return scheduled;
  }

  int? _weekdayFromDayName(String day) {
    switch (day.trim().toLowerCase()) {
      case 'mon':
      case 'monday':
        return DateTime.monday;
      case 'tue':
      case 'tues':
      case 'tuesday':
        return DateTime.tuesday;
      case 'wed':
      case 'wednesday':
        return DateTime.wednesday;
      case 'thu':
      case 'thurs':
      case 'thursday':
        return DateTime.thursday;
      case 'fri':
      case 'friday':
        return DateTime.friday;
      case 'sat':
      case 'saturday':
        return DateTime.saturday;
      case 'sun':
      case 'sunday':
        return DateTime.sunday;
      default:
        return null;
    }
  }

  int _medicineNotificationId(String medicineId, String time) {
    return ('medicine|$medicineId|$time').hashCode & 0x7fffffff;
  }

  int _reminderNotificationId(String reminderId) {
    return ('reminder|$reminderId').hashCode & 0x7fffffff;
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      debugPrint('Notification tapped: ${response.payload}');
    }
  }
}