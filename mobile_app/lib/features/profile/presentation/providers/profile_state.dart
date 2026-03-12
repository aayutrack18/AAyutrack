import 'package:aayutrack/features/profile/domain/entities/patient_profile.dart';

class ProfileState {
  final bool isLoading;
  final PatientProfile? profile;
  final bool isProfileCompleted;
  final String? errorMessage;

  const ProfileState({
    required this.isLoading,
    required this.profile,
    required this.isProfileCompleted,
    required this.errorMessage,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      isLoading: false,
      profile: null,
      isProfileCompleted: false,
      errorMessage: null,
    );
  }

  ProfileState copyWith({
    bool? isLoading,
    PatientProfile? profile,
    bool? isProfileCompleted,
    String? errorMessage,
    bool clearError = false,
    bool clearProfile = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: clearProfile ? null : (profile ?? this.profile),
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get hasProfile => profile != null;

  bool get hasError => errorMessage != null && errorMessage!.trim().isNotEmpty;

  bool get isEmptyState => !isLoading && profile == null && !hasError;

  @override
  String toString() {
    return 'ProfileState('
        'isLoading: $isLoading, '
        'hasProfile: $hasProfile, '
        'isProfileCompleted: $isProfileCompleted, '
        'errorMessage: $errorMessage'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileState &&
        other.isLoading == isLoading &&
        other.profile == profile &&
        other.isProfileCompleted == isProfileCompleted &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return Object.hash(
      isLoading,
      profile,
      isProfileCompleted,
      errorMessage,
    );
  }
}
