import '../models/patient_profile_model.dart';

class ProfileLocalDataSource {
  PatientProfileModel? _cachedProfile;

  Future<PatientProfileModel?> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _cachedProfile;
  }

  Future<void> saveProfile(PatientProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cachedProfile = profile;
  }

  Future<void> updateProfile(PatientProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cachedProfile = profile;
  }

  Future<void> deleteProfile() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cachedProfile = null;
  }

  Future<void> markProfileAsSynced() async {
    await Future.delayed(const Duration(milliseconds: 150));

    if (_cachedProfile != null) {
      _cachedProfile = PatientProfileModel(
        profileId: _cachedProfile!.profileId,
        userId: _cachedProfile!.userId,
        fullName: _cachedProfile!.fullName,
        age: _cachedProfile!.age,
        gender: _cachedProfile!.gender,
        phoneNumber: _cachedProfile!.phoneNumber,
        email: _cachedProfile!.email,
        bloodGroup: _cachedProfile!.bloodGroup,
        heightCm: _cachedProfile!.heightCm,
        weightKg: _cachedProfile!.weightKg,
        address: _cachedProfile!.address,
        allergies: _cachedProfile!.allergies,
        medicalConditions: _cachedProfile!.medicalConditions,
        emergencyContactName: _cachedProfile!.emergencyContactName,
        emergencyContactPhone: _cachedProfile!.emergencyContactPhone,
        createdAt: _cachedProfile!.createdAt,
        updatedAt: DateTime.now(),
        isSynced: true,
      );
    }
  }

  Future<void> markProfileAsPendingSync() async {
    await Future.delayed(const Duration(milliseconds: 150));

    if (_cachedProfile != null) {
      _cachedProfile = PatientProfileModel(
        profileId: _cachedProfile!.profileId,
        userId: _cachedProfile!.userId,
        fullName: _cachedProfile!.fullName,
        age: _cachedProfile!.age,
        gender: _cachedProfile!.gender,
        phoneNumber: _cachedProfile!.phoneNumber,
        email: _cachedProfile!.email,
        bloodGroup: _cachedProfile!.bloodGroup,
        heightCm: _cachedProfile!.heightCm,
        weightKg: _cachedProfile!.weightKg,
        address: _cachedProfile!.address,
        allergies: _cachedProfile!.allergies,
        medicalConditions: _cachedProfile!.medicalConditions,
        emergencyContactName: _cachedProfile!.emergencyContactName,
        emergencyContactPhone: _cachedProfile!.emergencyContactPhone,
        createdAt: _cachedProfile!.createdAt,
        updatedAt: DateTime.now(),
        isSynced: false,
      );
    }
  }
}
