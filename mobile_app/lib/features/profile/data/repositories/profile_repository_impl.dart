import 'package:aayutrack/core/sync/sync_queue_service.dart';
import 'package:aayutrack/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:aayutrack/features/profile/data/models/patient_profile_model.dart';
import 'package:aayutrack/features/profile/domain/entities/patient_profile.dart';
import 'package:aayutrack/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  final SyncQueueService syncQueueService;

  const ProfileRepositoryImpl({
    required this.localDataSource,
    required this.syncQueueService,
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
    await localDataSource.markProfileAsPendingSync();

    await syncQueueService.enqueue(
      entityType: 'patient_profile',
      entityId: model.profileId,
      operation: 'upsert',
      payload: _profilePayload(model),
    );
  }

  @override
  Future<void> updateProfile(PatientProfile profile) async {
    final model = _toModel(profile);

    await localDataSource.updateProfile(model);
    await localDataSource.markProfileAsPendingSync();

    await syncQueueService.enqueue(
      entityType: 'patient_profile',
      entityId: model.profileId,
      operation: 'upsert',
      payload: _profilePayload(model),
    );
  }

  @override
  Future<void> deleteProfile() async {
    final existingProfile = await localDataSource.getProfile();

    if (existingProfile == null) return;

    await localDataSource.deleteProfile();

    await syncQueueService.enqueue(
      entityType: 'patient_profile',
      entityId: existingProfile.profileId,
      operation: 'delete',
      payload: {
        'profileId': existingProfile.profileId,
        'userId': existingProfile.userId,
      },
    );
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

  Map<String, dynamic> _profilePayload(PatientProfileModel model) {
    return {
      'profileId': model.profileId,
      'userId': model.userId,
      'fullName': model.fullName,
      'age': model.age,
      'gender': model.gender,
      'phoneNumber': model.phoneNumber,
      'email': model.email,
      'bloodGroup': model.bloodGroup,
      'heightCm': model.heightCm,
      'weightKg': model.weightKg,
      'address': model.address,
      'allergies': model.allergies,
      'medicalConditions': model.medicalConditions,
      'emergencyContactName': model.emergencyContactName,
      'emergencyContactPhone': model.emergencyContactPhone,
      'createdAt': model.createdAt.toIso8601String(),
      'updatedAt': model.updatedAt.toIso8601String(),
      'isSynced': model.isSynced,
    };
  }
}