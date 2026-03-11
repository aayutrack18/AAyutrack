import '../../domain/entities/patient_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../models/patient_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<PatientProfile?> getProfile() async {
    final profileModel = await localDataSource.getProfile();
    return profileModel;
  }

  @override
  Future<void> saveProfile(PatientProfile profile) async {
    final model = PatientProfileModel.fromEntity(profile);
    await localDataSource.saveProfile(model);
  }

  @override
  Future<void> updateProfile(PatientProfile profile) async {
    final model = PatientProfileModel.fromEntity(profile);
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
}
