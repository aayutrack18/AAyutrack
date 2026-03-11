import '../models/patient_profile_model.dart';

class ProfileLocalDataSource {
  static const Duration _defaultDelay = Duration(milliseconds: 180);
  static const Duration _syncDelay = Duration(milliseconds: 120);

  PatientProfileModel? _cachedProfile;

  Future<PatientProfileModel?> getProfile() async {
    await Future.delayed(_defaultDelay);
    return _cloneProfile(_cachedProfile);
  }

  Future<void> saveProfile(PatientProfileModel profile) async {
    await Future.delayed(_defaultDelay);

    final updatedProfile = PatientProfileModel.fromEntity(
      profile.copyWith(
        updatedAt: DateTime.now(),
      ),
    );

    _cachedProfile = _cloneProfile(updatedProfile);
  }

  Future<void> updateProfile(PatientProfileModel profile) async {
    await Future.delayed(_defaultDelay);

    final updatedProfile = PatientProfileModel.fromEntity(
      profile.copyWith(
        updatedAt: DateTime.now(),
      ),
    );

    _cachedProfile = _cloneProfile(updatedProfile);
  }

  Future<void> deleteProfile() async {
    await Future.delayed(_defaultDelay);
    _cachedProfile = null;
  }

  Future<void> markProfileAsSynced() async {
    await Future.delayed(_syncDelay);

    if (_cachedProfile == null) return;

    final updatedProfile = PatientProfileModel.fromEntity(
      _cachedProfile!.copyWith(
        updatedAt: DateTime.now(),
        isSynced: true,
      ),
    );

    _cachedProfile = _cloneProfile(updatedProfile);
  }

  Future<void> markProfileAsPendingSync() async {
    await Future.delayed(_syncDelay);

    if (_cachedProfile == null) return;

    final updatedProfile = PatientProfileModel.fromEntity(
      _cachedProfile!.copyWith(
        updatedAt: DateTime.now(),
        isSynced: false,
      ),
    );

    _cachedProfile = _cloneProfile(updatedProfile);
  }

  PatientProfileModel? _cloneProfile(PatientProfileModel? profile) {
    if (profile == null) return null;

    return PatientProfileModel(
      profileId: profile.profileId,
      userId: profile.userId,
      fullName: profile.fullName,
      age: profile.age,
      gender: profile.gender,
      phoneNumber: profile.phoneNumber,
      email: profile.email,
      bloodGroup: profile.bloodGroup,
      heightCm: profile.heightCm,
      weightKg: profile.weightKg,
      address: profile.address,
      allergies: profile.allergies,
      medicalConditions: profile.medicalConditions,
      emergencyContactName: profile.emergencyContactName,
      emergencyContactPhone: profile.emergencyContactPhone,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
      isSynced: profile.isSynced,
    );
  }
}
