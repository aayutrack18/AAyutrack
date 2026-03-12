import '../../domain/entities/patient_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../models/patient_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  const ProfileRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<PatientProfile?> getProfile() async {
    final model = await localDataSource.getProfile();
    return _toEntity(model);
  }

  @override
  Future<void> saveProfile(PatientProfile profile) async {
    final model = _toModel(profile);
    await localDataSource.saveProfile(model);
  }

  @override
  Future<void> updateProfile(PatientProfile profile) async {
    final model = _toModel(profile);
    await localDataSource.updateProfile(model);
  }

  @override
  Future<void> deleteProfile() async {
    await localDataSource.deleteProfile();
  }

  @override
  Future<void> markProfileAsSynced() async {
    await localDataSource.markProfileAsSynced();
  }

  @override
  Future<void> markProfileAsPendingSync() async {
    await localDataSource.markProfileAsPendingSync();
  }

  PatientProfile? _toEntity(PatientProfileModel? model) {
    if (model == null) return null;
    return model;
  }

  PatientProfileModel _toModel(PatientProfile profile) {
    if (profile is PatientProfileModel) {
      return profile;
    }

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