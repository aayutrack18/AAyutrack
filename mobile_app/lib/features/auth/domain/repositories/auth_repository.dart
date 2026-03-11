import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<String?> authStateChanges();

  Future<String?> getCurrentUserId();

  Future<void> signOut();

  Future<AppUser?> getUserProfile(String uid);

  Future<void> saveUserProfile(AppUser user);

  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AppUser> createAccountWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<AppUser> signInAnonymously();

  Future<AppUser> signInWithGoogle();
}