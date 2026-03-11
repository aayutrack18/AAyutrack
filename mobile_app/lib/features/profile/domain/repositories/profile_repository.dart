import '../entities/patient_profile.dart';

abstract class ProfileRepository {
  Future<PatientProfile?> getProfile();

  Future<void> saveProfile(PatientProfile profile);

  Future<void> updateProfile(PatientProfile profile);

  Future<void> deleteProfile();

  Future<void> markProfileAsSynced();

  Future<void> markProfileAsPendingSync();
}
