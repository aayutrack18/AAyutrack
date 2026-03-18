import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../domain/entities/app_user.dart';
import 'auth_providers.dart';

class AuthViewState {
  final bool isLoading;
  final String? errorMessage;
  final String? uid;
  final AppUser? appUser;
  final String? phoneVerificationId;
  final int? phoneResendToken;
  final ConfirmationResult? phoneConfirmationResult;
  final bool otpSent;

  const AuthViewState({
    this.isLoading = false,
    this.errorMessage,
    this.uid,
    this.appUser,
    this.phoneVerificationId,
    this.phoneResendToken,
    this.phoneConfirmationResult,
    this.otpSent = false,
  });

  AuthViewState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? uid,
    AppUser? appUser,
    String? phoneVerificationId,
    int? phoneResendToken,
    ConfirmationResult? phoneConfirmationResult,
    bool? otpSent,
    bool clearError = false,
    bool clearPhoneSession = false,
  }) {
    return AuthViewState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      uid: uid ?? this.uid,
      appUser: appUser ?? this.appUser,
      phoneVerificationId: clearPhoneSession
          ? null
          : (phoneVerificationId ?? this.phoneVerificationId),
      phoneResendToken: clearPhoneSession
          ? null
          : (phoneResendToken ?? this.phoneResendToken),
      phoneConfirmationResult: clearPhoneSession
          ? null
          : (phoneConfirmationResult ?? this.phoneConfirmationResult),
      otpSent: clearPhoneSession ? false : (otpSent ?? this.otpSent),
    );
  }

  bool get isAuthenticated => uid != null;

  bool get hasPhoneSession =>
      phoneConfirmationResult != null ||
      (phoneVerificationId != null && phoneVerificationId!.isNotEmpty);
}

class AuthStateNotifier extends StateNotifier<AuthViewState> {
  final Ref ref;

  AuthStateNotifier(this.ref) : super(const AuthViewState());

  Future<void> checkCurrentSession() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(authRepositoryProvider);
      final uid = await repository.getCurrentUserId();

      if (uid == null) {
        state = state.copyWith(
          isLoading: false,
          uid: null,
          appUser: null,
          clearPhoneSession: true,
        );
        return;
      }

      final userProfile = await repository.getUserProfile(uid);

      state = state.copyWith(
        isLoading: false,
        uid: uid,
        appUser: userProfile,
      );
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseError(e),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
        uid: user.uid,
        appUser: user,
        clearPhoneSession: true,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.createAccountWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
        uid: user.uid,
        appUser: user,
        clearPhoneSession: true,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> sendPhoneOtp({required String phoneNumber}) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      otpSent: false,
    );

    try {
      final repository = ref.read(authRepositoryProvider);

      final session = await repository.sendOtpToPhone(
        phoneNumber: phoneNumber,
        forceResendingToken: state.phoneResendToken,
      );

      final currentUser = await repository.getCurrentUserId();

      if (currentUser != null) {
        final profile = await repository.getUserProfile(currentUser);
        state = state.copyWith(
          isLoading: false,
          uid: currentUser,
          appUser: profile,
          clearPhoneSession: true,
        );
        return true;
      }

      state = state.copyWith(
        isLoading: false,
        phoneVerificationId: session.verificationId,
        phoneResendToken: session.resendToken,
        phoneConfirmationResult: session.confirmationResult,
        otpSent: true,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        otpSent: false,
        errorMessage: _mapFirebaseError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        otpSent: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> verifyPhoneOtp({required String smsCode}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(authRepositoryProvider);

      final user = await repository.verifyPhoneOtp(
        smsCode: smsCode,
        verificationId: state.phoneVerificationId,
        confirmationResult: state.phoneConfirmationResult,
      );

      state = state.copyWith(
        isLoading: false,
        uid: user.uid,
        appUser: user,
        clearPhoneSession: true,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> sendResetPasswordEmail({required String email}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.sendPasswordResetEmail(email: email);

      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> signInGuest() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.signInAnonymously();

      state = state.copyWith(
        isLoading: false,
        uid: user.uid,
        appUser: user,
        clearPhoneSession: true,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.signInWithGoogle();

      state = state.copyWith(
        isLoading: false,
        uid: user.uid,
        appUser: user,
        clearPhoneSession: true,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.signOut();
      state = const AuthViewState();
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseError(e),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void clearPhoneAuthSession() {
    state = state.copyWith(clearPhoneSession: true, clearError: true);
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled in Firebase Console.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'popup-closed-by-user':
        return 'Google sign-in was cancelled.';
      case 'popup-blocked':
        return 'Popup was blocked. Please allow popups and try again.';
      case 'google-idtoken-null':
        return 'Google sign-in configuration error. Contact support.';
      case 'google-sign-in-failed':
        return e.message ?? 'Google sign-in failed. Please try again.';
      case 'invalid-phone-number':
        return 'Enter a valid phone number with country code.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Try again later.';
      case 'session-expired':
        return 'OTP expired. Please request a new code.';
      case 'invalid-verification-code':
        return 'Invalid OTP. Please check the code and try again.';
      case 'missing-verification-code':
        return 'Please enter the OTP code.';
      case 'missing-verification-id':
        return 'Verification expired. Please request a new OTP.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again.';
      case 'code-not-sent':
        return 'OTP could not be sent. Please try again.';
      case 'captcha-check-failed':
        return 'Phone verification failed. Please try again.';
      case 'app-not-authorized':
        return 'This app is not authorized for Firebase Authentication.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthViewState>((ref) {
  return AuthStateNotifier(ref);
});

final authStateChangesProvider = StreamProvider<String?>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return repository.authStateChanges();
});