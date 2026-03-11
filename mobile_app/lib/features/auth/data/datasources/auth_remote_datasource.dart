import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSource({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  Stream<String?> authStateChanges() {
    return firebaseAuth.authStateChanges().map((user) => user?.uid);
  }

  String? getCurrentUserId() {
    return firebaseAuth.currentUser?.uid;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();

    if (!kIsWeb) {
      await googleSignIn.signOut();
    }
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createAccountWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> signInAnonymously() async {
    return firebaseAuth.signInAnonymously();
  }

  Future<UserCredential> signInWithGoogle() async {
  if (kIsWeb) {
    final provider = GoogleAuthProvider();
    provider.setCustomParameters({'prompt': 'select_account'});
    return firebaseAuth.signInWithPopup(provider);
  }

  final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
  final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
    idToken: googleAuth.idToken,
  );

  return firebaseAuth.signInWithCredential(credential);
}
}