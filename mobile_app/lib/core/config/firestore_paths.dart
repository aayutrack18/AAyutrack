class FirestorePaths {
  static String user(String uid) => 'users/$uid';
  static String profileMain(String uid) => 'users/$uid/profile/main';
  static String medicines(String uid) => 'users/$uid/medicines';
  static String medicine(String uid, String medicineId) =>
      'users/$uid/medicines/$medicineId';
  static String reminders(String uid) => 'users/$uid/reminders';
  static String reminder(String uid, String reminderId) =>
      'users/$uid/reminders/$reminderId';
  static String healthLogs(String uid) => 'users/$uid/health_logs';
  static String reports(String uid) => 'users/$uid/reports';
  static String notifications(String uid) => 'users/$uid/notifications';
  static String complianceRecords(String uid) =>
      'users/$uid/compliance_records';
  static String devices(String uid) => 'users/$uid/devices';
}