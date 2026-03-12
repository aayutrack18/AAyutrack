import '../domain/entities/app_user.dart';

class AuthSessionService {
  static bool hasCompletedProfile(AppUser? user) {
    if (user == null) return false;
    return user.profileCompleted;
  }
}