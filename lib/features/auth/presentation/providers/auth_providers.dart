import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/firestore_user_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

// ── Firebase service singletons ───────────────────────────────────────────────

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// GoogleSignIn MUST receive the Web OAuth 2.0 client ID as [serverClientId].
/// This is the client_type: 3 entry from google-services.json.
/// Without this, Android Google Sign-In fails silently or returns null idToken.
final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(
    serverClientId:
        '969513127632-n1qlvkm2e51tu7vsrdj9mfl3255o11ur.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );
});

// ── Data sources ──────────────────────────────────────────────────────────────

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
    firebaseAuth: ref.read(firebaseAuthProvider),
    googleSignIn: ref.read(googleSignInProvider),
  );
});

final firestoreUserDataSourceProvider =
    Provider<FirestoreUserDataSource>((ref) {
  return FirestoreUserDataSource(
    firestore: ref.read(firebaseFirestoreProvider),
  );
});

// ── Repository ────────────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    authRemoteDataSource: ref.read(authRemoteDataSourceProvider),
    firestoreUserDataSource: ref.read(firestoreUserDataSourceProvider),
  );
});
