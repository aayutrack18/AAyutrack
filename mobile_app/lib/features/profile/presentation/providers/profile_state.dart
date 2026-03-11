import '../../domain/entities/patient_profile.dart';

class ProfileState {
  final bool isLoading;
  final PatientProfile? profile;
  final String? errorMessage;
  final bool isProfileCompleted;

  const ProfileState({
    this.isLoading = false,
    this.profile,
    this.errorMessage,
    this.isProfileCompleted = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    PatientProfile? profile,
    String? errorMessage,
    bool? isProfileCompleted,
    bool clearError = false,
    bool clearProfile = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: clearProfile ? null : (profile ?? this.profile),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
    );
  }

  factory ProfileState.initial() {
    return const ProfileState(
      isLoading: false,
      profile: null,
      errorMessage: null,
      isProfileCompleted: false,
    );
  }
}
