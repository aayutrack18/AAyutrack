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
      } catch (_) {
        // Ignore: Google may not be the auth provider used.
      }
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
    await firebaseAuth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  Future<UserCredential> signInAnonymously() async {
    return firebaseAuth.signInAnonymously();
  }

  Future<PhoneAuthSession> sendOtpToPhone({
    required String phoneNumber,
    int? forceResendingToken,
  }) async {
    if (kIsWeb) {
      try {
        final confirmationResult =
            await firebaseAuth.signInWithPhoneNumber(phoneNumber.trim());
        return PhoneAuthSession(confirmationResult: confirmationResult);
      } on FirebaseAuthException {
        rethrow;
      } catch (e) {
        throw FirebaseAuthException(
          code: 'web-otp-error',
          message: 'Failed to send OTP on web. '
              'Ensure Phone Auth is enabled in Firebase Console and '
              'your domain is in Authorized Domains. '
              'Detail: ${e.toString()}',
        );
      }
    }

    PhoneAuthSession? session;
    FirebaseAuthException? failure;

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber.trim(),
      forceResendingToken: forceResendingToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await firebaseAuth.signInWithCredential(credential);
        } on FirebaseAuthException catch (e) {
          failure = e;
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        failure = e;
      },
      codeSent: (String verificationId, int? resendToken) {
        session = PhoneAuthSession(
          verificationId: verificationId,
          resendToken: resendToken,
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        session ??= PhoneAuthSession(verificationId: verificationId);
      },
    );

    if (failure != null) {
      throw failure!;
    }

    if (firebaseAuth.currentUser != null) {
      return const PhoneAuthSession();
    }

    if (session == null) {
      throw FirebaseAuthException(
        code: 'code-not-sent',
        message: 'OTP could not be sent. Please try again.',
      );
    }

    return session!;
  }

  Future<UserCredential> verifyPhoneOtp({
    required String smsCode,
    String? verificationId,
    ConfirmationResult? confirmationResult,
  }) async {
    if (confirmationResult != null) {
      return confirmationResult.confirm(smsCode.trim());
    }

    if (verificationId == null || verificationId.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-verification-id',
        message: 'Verification session expired. Please request a new OTP.',
      );
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode.trim(),
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
      } catch (_) {
        // Ignore disconnect errors.
      }

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