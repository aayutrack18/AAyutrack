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

    final existingProfile =
        await firestoreUserDataSource.getUserProfile(firebaseUser.uid);

    if (existingProfile != null) {
      return existingProfile;
    }

    final fallbackUser = _mapFirebaseUserToAppUser(firebaseUser);
    await saveUserProfile(fallbackUser);
    return fallbackUser;
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

    final appUser = AppUser(
      uid: firebaseUser.uid,
      name: name,
      email: email,
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
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
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

    final existingProfile =
        await firestoreUserDataSource.getUserProfile(firebaseUser.uid);

    if (existingProfile != null) {
      return existingProfile;
    }

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
        message: 'Google sign-in failed.',
      );
    }

    final existingProfile =
        await firestoreUserDataSource.getUserProfile(firebaseUser.uid);

    if (existingProfile != null) {
      return existingProfile;
    }

    final appUser = AppUser(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName,
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

  AppUser _mapFirebaseUserToAppUser(User firebaseUser) {
    return AppUser(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName,
      email: firebaseUser.email,
      phoneNumber: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoURL,
      profileCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}