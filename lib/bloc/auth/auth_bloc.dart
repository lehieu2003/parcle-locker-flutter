import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/navigation_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;

  AuthBloc(this._firebaseAuth) : super(AuthInitial()) {
    // Check if user is already authenticated
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);

    // Initial check
    add(AuthCheckRequested());
  }
  void _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay

      final User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        try {
          // Reload user to ensure we have fresh data
          await currentUser.reload();
          final refreshedUser = _firebaseAuth.currentUser;

          if (refreshedUser != null) {
            emit(AuthAuthenticated(user: refreshedUser));
          } else {
            emit(AuthUnauthenticated());
          }
        } catch (reloadError) {
          debugPrint('Error reloading user: $reloadError');
          // If reload fails but we have a user, still consider authenticated
          emit(AuthAuthenticated(user: currentUser));
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      debugPrint('Auth check error: $e');
      // Handle the specific PigeonUserDetails casting error
      if (e.toString().contains('PigeonUserDetails') ||
          e.toString().contains('type cast')) {
        debugPrint(
            'PigeonUserDetails casting error detected, treating as unauthenticated');
        emit(AuthUnauthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    }
  }

  void _onSignInRequested(
      AuthSignInRequested event, Emitter<AuthState> emit) async {
    debugPrint('AuthBloc: Processing SignInRequested for ${event.email}');
    emit(AuthLoading());
    try {
      // Clear any existing auth state
      await _firebaseAuth.signOut();

      // Configure Firebase Auth settings
      await _firebaseAuth.setSettings(
        appVerificationDisabledForTesting: true,
        forceRecaptchaFlow: false,
      );

      // Set language code to prevent null locale issues
      await _firebaseAuth.setLanguageCode('en');

      debugPrint('AuthBloc: Attempting Firebase sign in for ${event.email}');

      // Add retry mechanism for authentication
      UserCredential? userCredential;
      int retryCount = 0;
      const maxRetries = 3;

      while (retryCount < maxRetries && userCredential == null) {
        try {
          userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: event.email.trim(),
            password: event.password,
          );
          break;
        } catch (e) {
          retryCount++;
          if (retryCount >= maxRetries) {
            rethrow;
          }
          debugPrint('Auth attempt $retryCount failed, retrying...');
          await Future.delayed(Duration(milliseconds: 500 * retryCount));
        }
      }

      if (userCredential?.user != null) {
        final user = userCredential!.user!;

        // Ensure user is properly loaded
        await user.reload();
        final currentUser = _firebaseAuth.currentUser;

        if (currentUser != null) {
          try {
            // Save user info to shared preferences
            await _saveUserData(currentUser);
            debugPrint(
                'AuthBloc: Login successful, emitting AuthAuthenticated for ${currentUser.email}');
            emit(AuthAuthenticated(user: currentUser));
          } catch (saveError) {
            debugPrint('Error saving user data: $saveError');
            // Still emit authenticated since login was successful
            emit(AuthAuthenticated(user: currentUser));
          }
        } else {
          debugPrint('AuthBloc: Current user is null after successful login');
          emit(const AuthError(
              message: 'Authentication failed. Please try again.'));
        }
      } else {
        debugPrint('AuthBloc: Login failed, userCredential.user is null');
        emit(const AuthError(message: 'Login failed. Please try again.'));
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Exception: ${e.code} - ${e.message}');
      String errorMessage = _getFirebaseAuthErrorMessage(e.code);
      emit(AuthError(message: errorMessage));
    } catch (e) {
      debugPrint('Login error: ${e.toString()}');
      // Handle the specific PigeonUserDetails casting error
      if (e.toString().contains('PigeonUserDetails') ||
          e.toString().contains('type cast')) {
        emit(const AuthError(
            message: 'Authentication service error. Please try again.'));
      } else {
        emit(AuthError(message: 'Login error: ${e.toString()}'));
      }
    }
  }

  void _onSignOutRequested(
      AuthSignOutRequested event, Emitter<AuthState> emit) async {
    try {
      // Đăng xuất khỏi Firebase
      await _firebaseAuth.signOut();

      // Xóa toàn bộ dữ liệu người dùng trong SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      await prefs.remove('username');
      await prefs.remove('email');
      await prefs.remove('uid');
      await prefs.remove('phoneNumber');
      await prefs.remove('role');
      await prefs
          .remove('rememberedEmail'); // Xóa cả email đã lưu cho "Remember me"

      // Ghi log để debug
      debugPrint('User logged out successfully, all data cleared');

      // Điều hướng về màn hình đăng nhập
      NavigationService.navigateToLogin();

      // Emit trạng thái đã đăng xuất để trigger navigation về login screen
      emit(AuthUnauthenticated());
    } catch (e) {
      debugPrint('Logout error: ${e.toString()}');
      emit(AuthError(message: 'Sign out error: ${e.toString()}'));
    }
  }

  void _onSignUpRequested(
      AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Configure Firebase Auth settings
      await _firebaseAuth.setSettings(
        appVerificationDisabledForTesting: true,
        forceRecaptchaFlow: false,
      );

      // Set language code to prevent null locale issues
      await _firebaseAuth.setLanguageCode('en');

      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password,
      );

      if (userCredential.user != null) {
        final user = userCredential.user!;

        // Ensure user is properly loaded
        await user.reload();
        final currentUser = _firebaseAuth.currentUser;

        if (currentUser != null) {
          try {
            // Save user info to shared preferences
            await _saveUserData(currentUser);
            emit(AuthAuthenticated(user: currentUser));
          } catch (saveError) {
            debugPrint('Error saving user data during signup: $saveError');
            // Still emit authenticated since signup was successful
            emit(AuthAuthenticated(user: currentUser));
          }
        } else {
          emit(const AuthError(
              message: 'Registration failed. Please try again.'));
        }
      } else {
        emit(
            const AuthError(message: 'Registration failed. Please try again.'));
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Exception: ${e.code} - ${e.message}');
      String errorMessage = _getFirebaseAuthErrorMessage(e.code);
      emit(AuthError(message: errorMessage));
    } catch (e) {
      debugPrint('Registration error: ${e.toString()}');
      // Handle the specific PigeonUserDetails casting error
      if (e.toString().contains('PigeonUserDetails') ||
          e.toString().contains('type cast')) {
        emit(const AuthError(
            message: 'Authentication service error. Please try again.'));
      } else {
        emit(AuthError(message: 'Registration error: ${e.toString()}'));
      }
    }
  }

  Future<void> _saveUserData(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', user.email ?? '');
      await prefs.setString('uid', user.uid);

      // If you want to store the user token
      final idToken = await user.getIdToken();
      await prefs.setString('accessToken', idToken ?? '');

      debugPrint('User data saved successfully to shared preferences');
    } catch (e) {
      debugPrint('Error saving user data: $e');
      // Handle the error but don't rethrow to prevent app crash
    }
  }

  String _getFirebaseAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'An error occurred during authentication.';
    }
  }
}
