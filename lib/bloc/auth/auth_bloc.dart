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
        emit(AuthAuthenticated(user: currentUser));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      debugPrint('Auth check error: $e');
      emit(AuthUnauthenticated());
    }
  }

  void _onSignInRequested(
      AuthSignInRequested event, Emitter<AuthState> emit) async {
    debugPrint('AuthBloc: Processing SignInRequested for ${event.email}');
    emit(AuthLoading());
    try {
      // Disable reCAPTCHA verification for testing and configure settings
      await _firebaseAuth.setSettings(
        appVerificationDisabledForTesting: true,
        forceRecaptchaFlow: false,
      );

      // Set language code to prevent null locale issues
      _firebaseAuth.setLanguageCode('en');

      debugPrint('AuthBloc: Attempting Firebase sign in for ${event.email}');
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user != null) {
        try {
          // Save user info to shared preferences
          await _saveUserData(userCredential.user!);
          debugPrint(
              'AuthBloc: Login successful, emitting AuthAuthenticated for ${userCredential.user!.email}');
          emit(AuthAuthenticated(user: userCredential.user!));
        } catch (saveError) {
          debugPrint('Error saving user data: $saveError');
          // Still emit authenticated since login was successful
          emit(AuthAuthenticated(user: userCredential.user!));
        }
      } else {
        debugPrint('AuthBloc: Login failed, userCredential.user is null');
        emit(const AuthError(message: 'Login failed. Please try again.'));
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Exception: ${e.code} - ${e.message}');
      String errorMessage = 'An error occurred during login';

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This account has been disabled.';
      }

      emit(AuthError(message: errorMessage));
    } catch (e) {
      debugPrint('Login error: ${e.toString()}');
      emit(AuthError(message: 'Login error: ${e.toString()}'));
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
      // Disable reCAPTCHA verification for testing and configure settings
      await _firebaseAuth.setSettings(
        appVerificationDisabledForTesting: true,
        forceRecaptchaFlow: false,
      );

      // Set language code to prevent null locale issues
      _firebaseAuth.setLanguageCode('en');

      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user != null) {
        try {
          // Save user info to shared preferences
          await _saveUserData(userCredential.user!);
          emit(AuthAuthenticated(user: userCredential.user!));
        } catch (saveError) {
          debugPrint('Error saving user data during signup: $saveError');
          // Still emit authenticated since signup was successful
          emit(AuthAuthenticated(user: userCredential.user!));
        }
      } else {
        emit(
            const AuthError(message: 'Registration failed. Please try again.'));
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Exception: ${e.code} - ${e.message}');
      String errorMessage = 'An error occurred during registration';

      if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists with this email.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format.';
      }

      emit(AuthError(message: errorMessage));
    } catch (e) {
      debugPrint('Registration error: ${e.toString()}');
      emit(AuthError(message: 'Registration error: ${e.toString()}'));
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
}
