import 'package:firebase_auth/firebase_auth.dart';

import 'package:aayutrack/core/sync/sync_queue_service.dart';
import 'package:aayutrack/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:aayutrack/features/profile/data/models/patient_profile_model.dart';
import 'package:aayutrack/features/profile/domain/entities/patient_profile.dart';
import 'package:aayutrack/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  final SyncQueueService syncQueueService;
  final FirebaseAuth auth;

  const ProfileRepositoryImpl({
    required this.localDataSource,
    required this.syncQueueService,
    required this.auth,
  });

  String get _uid {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw Exception('User not authenticated');
    }
    return uid;
  }

  @override
  Future<PatientProfile?> getProfile() async {
    return await localDataSource.getProfile();
  }

  @override
  Future<void> saveProfile(PatientProfile profile) async {
    final now = DateTime.now();

    final baseModel = _toModel(profile);
    final model = PatientProfileModel(
      profileId: baseModel.profileId,
      userId: _uid,
      fullName: baseModel.fullName,
      age: baseModel.age,
      gender: baseModel.gender,
      phoneNumber: baseModel.phoneNumber,
      email: baseModel.email,
      bloodGroup: baseModel.bloodGroup,
      heightCm: baseModel.heightCm,
      weightKg: baseModel.weightKg,
      address: baseModel.address,
      allergies: baseModel.allergies,
      medicalConditions: baseModel.medicalConditions,
      emergencyContactName: baseModel.emergencyContactName,
      emergencyContactPhone: baseModel.emergencyContactPhone,
      createdAt: baseModel.createdAt,
      updatedAt: now,
      isSynced: false,
    );

    await localDataSource.saveProfile(model);
    await localDataSource.markProfileAsPendingSync();

    await syncQueueService.enqueue(
      entityType: 'profile',
      entityId: model.profileId,
      operation: 'upsert',
      payload: _profilePayload(model),
    );
  }

  @override
  Future<void> updateProfile(PatientProfile profile) async {
    final now = DateTime.now();

    final baseModel = _toModel(profile);
    final model = PatientProfileModel(
      profileId: baseModel.profileId,
      userId: _uid,
      fullName: baseModel.fullName,
      age: baseModel.age,
      gender: baseModel.gender,
      phoneNumber: baseModel.phoneNumber,
      email: baseModel.email,
      bloodGroup: baseModel.bloodGroup,
      heightCm: baseModel.heightCm,
      weightKg: baseModel.weightKg,
      address: baseModel.address,
      allergies: baseModel.allergies,
      medicalConditions: baseModel.medicalConditions,
      emergencyContactName: baseModel.emergencyContactName,
      emergencyContactPhone: baseModel.emergencyContactPhone,
      createdAt: baseModel.createdAt,
      updatedAt: now,
      isSynced: false,
    );

    await localDataSource.updateProfile(model);
    await localDataSource.markProfileAsPendingSync();

    await syncQueueService.enqueue(
      entityType: 'profile',
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
      entityType: 'profile',
      entityId: existingProfile.profileId,
      operation: 'delete',
      payload: {
        'profileId': existingProfile.profileId,
        'userId': _uid,
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