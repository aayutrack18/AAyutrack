import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/firestore_user_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

const _webClientId =
    '969513127632-n1qlvkm2e51tu7vsrdj9mfl3255o11ur.apps.googleusercontent.com';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  if (kIsWeb) {
    return GoogleSignIn(
      clientId: _webClientId,
      scopes: const ['email', 'profile'],
    );
  }

  return GoogleSignIn(
    serverClientId: _webClientId,
    scopes: const ['email', 'profile'],
  );
});

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

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    authRemoteDataSource: ref.read(authRemoteDataSourceProvider),
    firestoreUserDataSource: ref.read(firestoreUserDataSourceProvider),
  );
});