import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show Ref, StreamProvider;
import 'package:flutter_riverpod/legacy.dart'
    show StateNotifier, StateNotifierProvider;

import '../../domain/entities/app_user.dart';
import 'auth_providers.dart';

class AuthViewState {
  final bool isLoading;
  final String? errorMessage;
  final String? uid;
  final AppUser? appUser;

  const AuthViewState({
    this.isLoading = false,
    this.errorMessage,
    this.uid,
    this.appUser,
  });

  AuthViewState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? uid,
    AppUser? appUser,
    bool clearError = false,
  }) {
    return AuthViewState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      uid: uid ?? this.uid,
      appUser: appUser ?? this.appUser,
    );
  }
}

class AuthStateNotifier extends StateNotifier<AuthViewState> {
  late Ref ref;

  AuthStateNotifier() : super(const AuthViewState());

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
        );
        return;
      }

      final userProfile = await repository.getUserProfile(uid);

      state = state.copyWith(
        isLoading: false,
        uid: uid,
        appUser: userProfile,
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
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseAuthError(e),
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
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
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseAuthError(e),
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  Future<bool> sendResetPasswordEmail({
    required String email,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.sendPasswordResetEmail(email: email);

      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseAuthError(e),
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
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
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseAuthError(e),
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
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
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapFirebaseAuthError(e),
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Google sign-in failed. Please try again.',
      );
      return false;
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
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
        return 'Password is too weak.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled in Firebase.';
      case 'network-request-failed':
        return 'Network error. Please check your internet.';
      case 'popup-closed-by-user':
        return 'Google sign-in was cancelled.';
      case 'popup-blocked':
        return 'Popup was blocked. Please allow popups and try again.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthViewState>((ref) {
  final notifier = AuthStateNotifier();
  notifier.ref = ref;
  return notifier;
});

final authStateChangesProvider = StreamProvider<String?>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return repository.authStateChanges();
});