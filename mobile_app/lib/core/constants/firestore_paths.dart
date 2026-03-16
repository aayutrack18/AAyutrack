class FirestorePaths {
  static const String users = 'users';
  static const String profile = 'profile';
  static const String mainProfileDoc = 'main';
  static const String medicines = 'medicines';
  static const String reminders = 'reminders';
  static const String healthLogs = 'health_logs';
  static const String reports = 'reports';
  static const String devices = 'devices';

  static String userDoc(String uid) => '$users/$uid';

  static String userProfileDoc(String uid) =>
      '$users/$uid/$profile/$mainProfileDoc';

  static String userMedicines(String uid) => '$users/$uid/$medicines';

  static String userReminders(String uid) => '$users/$uid/$reminders';

  static String userHealthLogs(String uid) => '$users/$uid/$healthLogs';

  static String userReports(String uid) => '$users/$uid/$reports';

  static String userDevices(String uid) => '$users/$uid/$devices';
}