import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/profile_local_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/patient_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  return ProfileLocalDataSource();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final localDataSource = ref.read(profileLocalDataSourceProvider);

  return ProfileRepositoryImpl(
    localDataSource: localDataSource,
  );
});

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return ProfileNotifier(repository);
});

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(ProfileState.initial());

  Future<void> loadProfile() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final profile = await _repository.getProfile();

      if (profile == null) {
        state = state.copyWith(
          isLoading: false,
          clearProfile: true,
          isProfileCompleted: false,
          clearError: true,
        );
        return;
      }

      state = state.copyWith(
        isLoading: false,
        profile: profile,
        isProfileCompleted: true,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load profile: $e',
      );
    }
  }

  Future<void> createProfile(PatientProfile profile) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      await _repository.saveProfile(profile);

      final savedProfile = await _repository.getProfile();

      state = state.copyWith(
        isLoading: false,
        profile: savedProfile,
        isProfileCompleted: savedProfile != null,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create profile: $e',
      );
    }
  }

  Future<void> updateProfile(PatientProfile updatedProfile) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      await _repository.updateProfile(updatedProfile);
      await _repository.markProfileAsPendingSync();

      final latestProfile = await _repository.getProfile();

      state = state.copyWith(
        isLoading: false,
        profile: latestProfile,
        isProfileCompleted: latestProfile != null,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update profile: $e',
      );
    }
  }

  Future<void> deleteProfile() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      await _repository.deleteProfile();

      state = ProfileState.initial();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete profile: $e',
      );
    }
  }

  Future<void> markAsSynced() async {
    try {
      await _repository.markProfileAsSynced();
      final latestProfile = await _repository.getProfile();

      state = state.copyWith(
        profile: latestProfile,
        isProfileCompleted: latestProfile != null,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to update sync status: $e',
      );
    }
  }

  Future<void> markAsPendingSync() async {
    try {
      await _repository.markProfileAsPendingSync();
      final latestProfile = await _repository.getProfile();

      state = state.copyWith(
        profile: latestProfile,
        isProfileCompleted: latestProfile != null,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to update sync status: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void clearProfileState() {
    state = ProfileState.initial();
  }
}
