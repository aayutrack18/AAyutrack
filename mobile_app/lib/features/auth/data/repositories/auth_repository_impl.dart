import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/firestore_user_datasource.dart';
import '../models/app_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final FirestoreUserDataSource firestoreUserDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.firestoreUserDataSource,
  });

  @override
  Stream<String?> authStateChanges() {
    return authRemoteDataSource.authStateChanges();
  }

  @override
  Future<String?> getCurrentUserId() async {
    return authRemoteDataSource.getCurrentUserId();
  }

  @override
  Future<void> signOut() async {
    await authRemoteDataSource.signOut();
  }

  @override
  Future<AppUser?> getUserProfile(String uid) async {
    return firestoreUserDataSource.getUserProfile(uid);
  }

  @override
  Future<void> saveUserProfile(AppUser user) async {
    final model = AppUserModel.fromEntity(user);
    await firestoreUserDataSource.saveUserProfile(model);
  }

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await authRemoteDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'Unable to sign in. Please try again.',
      );
    }

    final existing =
        await firestoreUserDataSource.getUserProfile(firebaseUser.uid);
    if (existing != null) return existing;

    final fallback = _mapFirebaseUserToAppUser(firebaseUser);
    await saveUserProfile(fallback);
    return fallback;
  }

  @override
  Future<AppUser> createAccountWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential =
        await authRemoteDataSource.createAccountWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'Unable to create account. Please try again.',
      );
    }

    await firebaseUser.updateDisplayName(name);
    await firebaseUser.reload();

    final refreshedUser = FirebaseAuth.instance.currentUser ?? firebaseUser;

    final appUser = AppUser(
      uid: refreshedUser.uid,
      name: name,
      email: email,
      phoneNumber: refreshedUser.phoneNumber,
      photoUrl: refreshedUser.photoURL,
      profileCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await saveUserProfile(appUser);
    return appUser;
  }

  @override
  Future<PhoneAuthSession> sendOtpToPhone({
    required String phoneNumber,
    int? forceResendingToken,
  }) {
    return authRemoteDataSource.sendOtpToPhone(
      phoneNumber: phoneNumber,
      forceResendingToken: forceResendingToken,
    );
  }

  @override
  Future<AppUser> verifyPhoneOtp({
    required String smsCode,
    String? verificationId,
    ConfirmationResult? confirmationResult,
  }) async {
    final credential = await authRemoteDataSource.verifyPhoneOtp(
      smsCode: smsCode,
      verificationId: verificationId,
      confirmationResult: confirmationResult,
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'Phone verification failed. Please try again.',
      );
    }

    final existing =
        await firestoreUserDataSource.getUserProfile(firebaseUser.uid);
    if (existing != null) return existing;

    final appUser = _mapFirebaseUserToAppUser(firebaseUser);
    await saveUserProfile(appUser);
    return appUser;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await authRemoteDataSource.sendPasswordResetEmail(email: email);
  }

  @override
  Future<AppUser> signInAnonymously() async {
    final credential = await authRemoteDataSource.signInAnonymously();
    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'Anonymous sign-in failed.',
      );
    }

    final existing =
        await firestoreUserDataSource.getUserProfile(firebaseUser.uid);
    if (existing != null) return existing;

    final appUser = AppUser(
      uid: firebaseUser.uid,
      name: 'Guest User',
      email: firebaseUser.email,
      phoneNumber: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoURL,
      profileCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await saveUserProfile(appUser);
    return appUser;
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    final credential = await authRemoteDataSource.signInWithGoogle();
    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'Google sign-in failed. Please try again.',
      );
    }

    final existing =
        await firestoreUserDataSource.getUserProfile(firebaseUser.uid);

    if (existing != null) {
      final merged = existing.copyWith(
        name: existing.name ?? firebaseUser.displayName,
        email: existing.email ?? firebaseUser.email,
        phoneNumber: existing.phoneNumber ?? firebaseUser.phoneNumber,
        photoUrl: existing.photoUrl ?? firebaseUser.photoURL,
        updatedAt: DateTime.now(),
      );
      await saveUserProfile(merged);
      return merged;
    }

    final appUser = _mapFirebaseUserToAppUser(firebaseUser);
    await saveUserProfile(appUser);
    return appUser;
  }

  AppUser _mapFirebaseUserToAppUser(User firebaseUser) {
    final now = DateTime.now();

    return AppUser(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName,
      email: firebaseUser.email,
      phoneNumber: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoURL,
      profileCompleted: false,
      createdAt: firebaseUser.metadata.creationTime ?? now,
      updatedAt: firebaseUser.metadata.lastSignInTime ?? now,
    );
  }
}