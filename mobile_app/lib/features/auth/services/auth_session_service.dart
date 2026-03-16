import '../domain/entities/app_user.dart';

/// Stateless helper for session-related checks.
class AuthSessionService {
  /// Returns true when the user has completed their profile onboarding.
  static bool hasCompletedProfile(AppUser? user) {
    if (user == null) return false;
    return user.profileCompleted;
  }
}
