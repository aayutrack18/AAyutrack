import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PhoneAuthSession {
  final String? verificationId;
  final int? resendToken;
  final ConfirmationResult? confirmationResult;

  const PhoneAuthSession({
    this.verificationId,
    this.resendToken,
    this.confirmationResult,
  });
}

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
      try {
        await googleSignIn.signOut();
      } catch (_) {}
    }
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<UserCredential> createAccountWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  Future<UserCredential> signInAnonymously() async {
    return firebaseAuth.signInAnonymously();
  }

  String _normalizePhoneNumber(String phoneNumber) {
    var normalized = phoneNumber.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (normalized.startsWith('00')) {
      normalized = '+${normalized.substring(2)}';
    }

    if (!normalized.startsWith('+')) {
      throw FirebaseAuthException(
        code: 'invalid-phone-number',
        message: 'Phone number must include country code.',
      );
    }

    if (!RegExp(r'^\+\d{8,15}$').hasMatch(normalized)) {
      throw FirebaseAuthException(
        code: 'invalid-phone-number',
        message: 'Enter a valid phone number in international format.',
      );
    }

    return normalized;
  }

  Future<PhoneAuthSession> sendOtpToPhone({
    required String phoneNumber,
    int? forceResendingToken,
  }) async {
    final normalizedPhoneNumber = _normalizePhoneNumber(phoneNumber);

    if (kIsWeb) {
      try {
        final confirmationResult =
            await firebaseAuth.signInWithPhoneNumber(normalizedPhoneNumber);
        return PhoneAuthSession(confirmationResult: confirmationResult);
      } on FirebaseAuthException {
        rethrow;
      } catch (e) {
        throw FirebaseAuthException(
          code: 'web-otp-error',
          message: 'Failed to send OTP on web. Detail: ${e.toString()}',
        );
      }
    }

    final completer = Completer<PhoneAuthSession>();
    bool completed = false;

    void completeOnce(PhoneAuthSession session) {
      if (!completed && !completer.isCompleted) {
        completed = true;
        completer.complete(session);
      }
    }

    void failOnce(FirebaseAuthException error) {
      if (!completed && !completer.isCompleted) {
        completed = true;
        completer.completeError(error);
      }
    }

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: normalizedPhoneNumber,
      forceResendingToken: forceResendingToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await firebaseAuth.signInWithCredential(credential);
          completeOnce(const PhoneAuthSession());
        } on FirebaseAuthException catch (e) {
          failOnce(e);
        } catch (e) {
          failOnce(
            FirebaseAuthException(
              code: 'auto-verification-failed',
              message: e.toString(),
            ),
          );
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        failOnce(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        completeOnce(
          PhoneAuthSession(
            verificationId: verificationId,
            resendToken: resendToken,
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        completeOnce(
          PhoneAuthSession(
            verificationId: verificationId,
          ),
        );
      },
    );

    return completer.future;
  }

  Future<UserCredential> verifyPhoneOtp({
    required String smsCode,
    String? verificationId,
    ConfirmationResult? confirmationResult,
  }) async {
    final code = smsCode.trim();

    if (code.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-verification-code',
        message: 'Please enter the OTP code.',
      );
    }

    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      throw FirebaseAuthException(
        code: 'invalid-verification-code',
        message: 'OTP must be 6 digits.',
      );
    }

    if (confirmationResult != null) {
      return confirmationResult.confirm(code);
    }

    if (verificationId == null || verificationId.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-verification-id',
        message: 'Verification session expired. Please request a new OTP.',
      );
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );

    return firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      provider.setCustomParameters({'prompt': 'select_account'});
      return firebaseAuth.signInWithPopup(provider);
    }

    try {
      try {
        await googleSignIn.disconnect();
      } catch (_) {}

      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'popup-closed-by-user',
          message: 'Google sign-in was cancelled.',
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if ((googleAuth.idToken == null || googleAuth.idToken!.isEmpty) &&
          (googleAuth.accessToken == null || googleAuth.accessToken!.isEmpty)) {
        throw FirebaseAuthException(
          code: 'google-idtoken-null',
          message: 'Unable to retrieve Google authentication tokens.',
        );
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      return firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: e.toString(),
      );
    }
  }
}