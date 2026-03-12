import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../models/patient_profile_model.dart';

class ProfileLocalDataSource {
  final AppDatabase database;

  const ProfileLocalDataSource(this.database);

  Future<PatientProfileModel?> getProfile() async {
    final row = await database.getAllPatientProfiles().then(
      (profiles) => profiles.isNotEmpty ? profiles.first : null,
    );

    if (row == null) return null;

    return PatientProfileModel(
      profileId: row.id,
      userId: row.userId,
      fullName: row.fullName,
      age: row.age ?? 0,
      gender: row.gender ?? '',
      phoneNumber: row.phone ?? '',
      email: row.email ?? '',
      bloodGroup: row.bloodGroup ?? '',
      heightCm: row.height ?? 0,
      weightKg: row.weight ?? 0,
      address: row.address ?? '',
      allergies: row.allergies ?? '',
      medicalConditions: row.chronicConditions ?? '',
      emergencyContactName: row.emergencyContactName ?? '',
      emergencyContactPhone: row.emergencyContactPhone ?? '',
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isSynced: row.isSynced,
    );
  }

  Future<void> saveProfile(PatientProfileModel model) async {
    await database.insertOrUpdatePatientProfile(
      PatientProfilesCompanion.insert(
        id: model.profileId,
        userId: model.userId,
        fullName: model.fullName,
        age: Value(model.age),
        gender: Value(model.gender),
        phone: Value(model.phoneNumber),
        email: Value(model.email),
        address: Value(model.address),
        bloodGroup: Value(model.bloodGroup),
        emergencyContactName: Value(model.emergencyContactName),
        emergencyContactPhone: Value(model.emergencyContactPhone),
        height: Value(model.heightCm),
        weight: Value(model.weightKg),
        chronicConditions: Value(model.medicalConditions),
        allergies: Value(model.allergies),
        profileImagePath: const Value(null),
        isSynced: Value(model.isSynced),
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
      ),
    );
  }

  Future<void> updateProfile(PatientProfileModel model) async {
    await database.insertOrUpdatePatientProfile(
      PatientProfilesCompanion(
        id: Value(model.profileId),
        userId: Value(model.userId),
        fullName: Value(model.fullName),
        age: Value(model.age),
        gender: Value(model.gender),
        phone: Value(model.phoneNumber),
        email: Value(model.email),
        address: Value(model.address),
        bloodGroup: Value(model.bloodGroup),
        emergencyContactName: Value(model.emergencyContactName),
        emergencyContactPhone: Value(model.emergencyContactPhone),
        height: Value(model.heightCm),
        weight: Value(model.weightKg),
        chronicConditions: Value(model.medicalConditions),
        allergies: Value(model.allergies),
        isSynced: Value(model.isSynced),
        createdAt: Value(model.createdAt),
        updatedAt: Value(model.updatedAt),
      ),
    );
  }

  Future<void> deleteProfile() async {
    final profile = await getProfile();
    if (profile == null) return;

    await database.deletePatientProfile(profile.profileId);
  }

  Future<void> markProfileAsSynced() async {
    final profile = await getProfile();
    if (profile == null) return;

    await database.updatePatientProfileSyncStatus(
      id: profile.profileId,
      isSynced: true,
    );
  }

  Future<void> markProfileAsPendingSync() async {
    final profile = await getProfile();
    if (profile == null) return;

    await database.updatePatientProfileSyncStatus(
      id: profile.profileId,
      isSynced: false,
    );
  }
}