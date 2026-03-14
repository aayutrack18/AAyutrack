import 'package:aayutrack/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:aayutrack/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:aayutrack/features/profile/data/models/patient_profile_model.dart';
import 'package:aayutrack/features/profile/domain/entities/patient_profile.dart';
import 'package:aayutrack/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  final ProfileRemoteDataSource remoteDataSource;

  const ProfileRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<PatientProfile?> getProfile() async {
    final localModel = await localDataSource.getProfile();
    return _toEntity(localModel);
  }

  @override
  Future<void> saveProfile(PatientProfile profile) async {
    final model = _toModel(profile);

    await localDataSource.saveProfile(model);

    try {
      await remoteDataSource.uploadProfile(model);
      await localDataSource.markProfileAsSynced();
    } catch (_) {
      await localDataSource.markProfileAsPendingSync();
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(PatientProfile profile) async {
    final model = _toModel(profile);

    await localDataSource.updateProfile(model);

    try {
      await remoteDataSource.uploadProfile(model);
      await localDataSource.markProfileAsSynced();
    } catch (_) {
      await localDataSource.markProfileAsPendingSync();
      rethrow;
    }
  }

  @override
  Future<void> deleteProfile() async {
    final existingProfile = await localDataSource.getProfile();

    await localDataSource.deleteProfile();

    if (existingProfile != null && existingProfile.userId.trim().isNotEmpty) {
      try {
        await remoteDataSource.deleteProfile(existingProfile.userId);
      } catch (_) {
        // Local delete already completed.
      }
    }
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