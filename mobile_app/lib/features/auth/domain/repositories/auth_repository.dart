import 'package:firebase_auth/firebase_auth.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  /// Stream of uid changes – null means signed out.
  Stream<String?> authStateChanges();

  /// Returns current uid or null.
  Future<String?> getCurrentUserId();

  /// Signs the user out of Firebase + Google.
  Future<void> signOut();

  /// Fetches user profile from Firestore. Returns null if not found.
  Future<AppUser?> getUserProfile(String uid);

  /// Creates or merges a user profile document in Firestore.
  Future<void> saveUserProfile(AppUser user);

  /// Email + password sign-in. Returns the AppUser on success.
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Email + password account creation. Saves profile to Firestore.
  Future<AppUser> createAccountWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  /// Sends phone verification code.
  Future<PhoneAuthSession> sendOtpToPhone({
    required String phoneNumber,
    int? forceResendingToken,
  });

  /// Verifies phone OTP and signs the user in.
  /// Mobile uses verificationId; web can use confirmationResult.
  Future<AppUser> verifyPhoneOtp({
    required String smsCode,
    String? verificationId,
    ConfirmationResult? confirmationResult,
  });

  /// Sends a password-reset email.
  Future<void> sendPasswordResetEmail({required String email});

  /// Anonymous sign-in (guest mode).
  Future<AppUser> signInAnonymously();

  /// Google OAuth sign-in.
  Future<AppUser> signInWithGoogle();
}