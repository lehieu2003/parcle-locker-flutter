import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  String? _username;
  String? _accessToken;
  String? _email;
  String? _phoneNumber;
  String? _role;
  bool _isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  String? get username => _username;
  String? get accessToken => _accessToken;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get role => _role;
  bool get isLoading => _isLoading;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('accessToken');
    _username = prefs.getString('username');
    _email = prefs.getString('email');
    _phoneNumber = prefs.getString('phoneNumber');
    _role = prefs.getString('role');
    _isLoading = false;
    _user = _auth.currentUser;
    notifyListeners();
  }

  void setUser(User user) async {
    try {
      _user = user;
      _email = user.email;
      _phoneNumber = user.phoneNumber;

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', user.email ?? '');
      await prefs.setString('uid', user.uid);

      // Get and store the user token
      final idToken = await user.getIdToken();
      _accessToken = idToken;
      await prefs.setString('accessToken', idToken ?? '');

      debugPrint('User data set successfully in AuthProvider');
    } catch (e) {
      debugPrint('Error setting user data: $e');
      // Handle the error but don't rethrow to prevent app crash
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearUser() async {
    _user = null;
    _username = null;
    _accessToken = null;
    _email = null;
    _phoneNumber = null;
    _role = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('uid');

    _isLoading = false;
    notifyListeners();
  }

  Future<String?> signIn(String email, String password) async {
    try {
      // Disable reCAPTCHA verification for testing and configure settings
      await _auth.setSettings(
        appVerificationDisabledForTesting: true,
        forceRecaptchaFlow: false,
      );

      // Set language code to prevent null locale issues
      _auth.setLanguageCode('en');

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = userCredential.user;
      if (_user != null) {
        setUser(_user!);
      }
      return null; // No error
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
      return errorMessage;
    } catch (e) {
      return 'Login error: ${e.toString()}';
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      // Disable reCAPTCHA verification for testing and configure settings
      await _auth.setSettings(
        appVerificationDisabledForTesting: true,
        forceRecaptchaFlow: false,
      );

      // Set language code to prevent null locale issues
      _auth.setLanguageCode('en');

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('username');
    _username = null;
    _accessToken = null;
    notifyListeners();
  }

  Future<void> signUpWithDetails(String username, String email, String password,
      String name, String phone, String address, int age, String role) async {
    // Implement sign-up logic and update state
    notifyListeners();
  }

  Future<void> signUpByCode(String email, String code) async {
    // Implement sign-up by code logic and update state
    notifyListeners();
  }
}
