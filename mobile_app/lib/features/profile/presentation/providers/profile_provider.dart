import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/sync/profile_sync_service.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../data/datasources/profile_local_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/patient_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return ProfileLocalDataSource(database);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final localDataSource = ref.watch(profileLocalDataSourceProvider);
  final syncQueueService = ref.watch(syncQueueServiceProvider);

  return ProfileRepositoryImpl(
    localDataSource: localDataSource,
    syncQueueService: syncQueueService,
  );
});

final profileSyncProvider = Provider<ProfileSyncService>((ref) {
  return ref.watch(profileSyncServiceProvider);
});

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  final syncService = ref.watch(profileSyncProvider);
  return ProfileNotifier(repository, syncService);
});

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;
  final ProfileSyncService _syncService;

  ProfileNotifier(this._repository, this._syncService)
      : super(ProfileState.initial());

  bool _isProfileCompleted(PatientProfile? profile) {
    if (profile == null) return false;

    return profile.fullName.trim().isNotEmpty &&
        profile.age > 0 &&
        profile.gender.trim().isNotEmpty &&
        profile.phoneNumber.trim().isNotEmpty &&
        profile.email.trim().isNotEmpty &&
        profile.bloodGroup.trim().isNotEmpty;
  }

  Future<void> loadProfile() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final profile = await _repository.getProfile();

      debugPrint('========== LOCAL SQLITE PROFILE ==========');
      debugPrint('$profile');
      debugPrint('=========================================');

      state = state.copyWith(
        isLoading: false,
        profile: profile,
        isProfileCompleted: _isProfileCompleted(profile),
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
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
      await _syncService.syncPendingProfileItems();

      final latestProfile = await _repository.getProfile();

      debugPrint('========== PROFILE CREATED / SAVED ==========');
      debugPrint('$latestProfile');
      debugPrint('============================================');

      state = state.copyWith(
        isLoading: false,
        profile: latestProfile,
        isProfileCompleted: _isProfileCompleted(latestProfile),
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateProfile(PatientProfile profile) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      await _repository.updateProfile(profile);
      await _syncService.syncPendingProfileItems();

      final latestProfile = await _repository.getProfile();

      debugPrint('========== PROFILE UPDATED ==========');
      debugPrint('$latestProfile');
      debugPrint('====================================');

      state = state.copyWith(
        isLoading: false,
        profile: latestProfile,
        isProfileCompleted: _isProfileCompleted(latestProfile),
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
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
      await _syncService.syncPendingProfileItems();
      state = ProfileState.initial();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> markAsSynced() async {
    try {
      await _repository.markProfileAsSynced();
      final latestProfile = await _repository.getProfile();

      state = state.copyWith(
        profile: latestProfile,
        isProfileCompleted: _isProfileCompleted(latestProfile),
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> markAsPendingSync() async {
    try {
      await _repository.markProfileAsPendingSync();
      final latestProfile = await _repository.getProfile();

      state = state.copyWith(
        profile: latestProfile,
        isProfileCompleted: _isProfileCompleted(latestProfile),
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshProfileSilently() async {
    try {
      final latestProfile = await _repository.getProfile();

      debugPrint('========== PROFILE REFRESH ==========');
      debugPrint('$latestProfile');
      debugPrint('====================================');

      state = state.copyWith(
        profile: latestProfile,
        isProfileCompleted: _isProfileCompleted(latestProfile),
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> syncNow() async {
    try {
      await _syncService.syncPendingProfileItems();
      final latestProfile = await _repository.getProfile();

      debugPrint('========== PROFILE SYNC NOW ==========');
      debugPrint('$latestProfile');
      debugPrint('=====================================');

      state = state.copyWith(
        profile: latestProfile,
        isProfileCompleted: _isProfileCompleted(latestProfile),
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
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