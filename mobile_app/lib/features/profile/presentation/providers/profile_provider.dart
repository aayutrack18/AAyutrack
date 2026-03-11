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
  final localDataSource = ref.watch(profileLocalDataSourceProvider);

  return ProfileRepositoryImpl(
    localDataSource: localDataSource,
  );
});

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repository);
});

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(ProfileState.initial());

  bool _isProfileCompleted(PatientProfile? profile) {
    if (profile == null) return false;

    return profile.fullName.trim().isNotEmpty &&
        profile.age > 0 &&
        profile.gender.trim().isNotEmpty &&
        profile.phoneNumber.trim().isNotEmpty &&
        profile.email.trim().isNotEmpty &&
        profile.bloodGroup.trim().isNotEmpty;
  }

  void _setLoading({bool clearError = true}) {
    state = state.copyWith(
      isLoading: true,
      clearError: clearError,
    );
  }

  void _setLoadedProfile(PatientProfile? profile) {
    state = state.copyWith(
      isLoading: false,
      profile: profile,
      isProfileCompleted: _isProfileCompleted(profile),
      clearError: true,
      clearProfile: profile == null,
    );
  }

  void _setError(String message) {
    state = state.copyWith(
      isLoading: false,
      errorMessage: message,
    );
  }

  Future<PatientProfile?> _fetchLatestProfile() async {
    return _repository.getProfile();
  }

  Future<void> loadProfile() async {
    _setLoading();

    try {
      final profile = await _fetchLatestProfile();
      _setLoadedProfile(profile);
    } catch (e) {
      _setError('Failed to load profile: $e');
    }
  }

  Future<void> createProfile(PatientProfile profile) async {
    _setLoading();

    try {
      await _repository.saveProfile(profile);
      final savedProfile = await _fetchLatestProfile();
      _setLoadedProfile(savedProfile);
    } catch (e) {
      _setError('Failed to create profile: $e');
    }
  }

  Future<void> updateProfile(PatientProfile updatedProfile) async {
    _setLoading();

    try {
      await _repository.updateProfile(updatedProfile);
      await _repository.markProfileAsPendingSync();

      final latestProfile = await _fetchLatestProfile();
      _setLoadedProfile(latestProfile);
    } catch (e) {
      _setError('Failed to update profile: $e');
    }
  }

  Future<void> deleteProfile() async {
    _setLoading();

    try {
      await _repository.deleteProfile();
      state = ProfileState.initial();
    } catch (e) {
      _setError('Failed to delete profile: $e');
    }
  }

  Future<void> markAsSynced() async {
    try {
      await _repository.markProfileAsSynced();
      final latestProfile = await _fetchLatestProfile();
      _setLoadedProfile(latestProfile);
    } catch (e) {
      _setError('Failed to update sync status: $e');
    }
  }

  Future<void> markAsPendingSync() async {
    try {
      await _repository.markProfileAsPendingSync();
      final latestProfile = await _fetchLatestProfile();
      _setLoadedProfile(latestProfile);
    } catch (e) {
      _setError('Failed to update sync status: $e');
    }
  }

  Future<void> refreshProfileSilently() async {
    try {
      final latestProfile = await _fetchLatestProfile();

      state = state.copyWith(
        profile: latestProfile,
        isProfileCompleted: _isProfileCompleted(latestProfile),
        clearError: true,
        clearProfile: latestProfile == null,
      );
    } catch (e) {
      _setError('Failed to refresh profile: $e');
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void clearProfileState() {
    state = ProfileState.initial();
  }
}
