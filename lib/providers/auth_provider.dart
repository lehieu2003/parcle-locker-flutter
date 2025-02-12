import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _username;
  String? _accessToken;
  String? _email;
  String? _phoneNumber;
  String? _role;
  bool _isLoading = true;

  String? get username => _username;
  String? get accessToken => _accessToken;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get role => _role;
  bool get isLoading => _isLoading;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('accessToken');
    _username = prefs.getString('username');
    _email = prefs.getString('email');
    _phoneNumber = prefs.getString('phoneNumber');
    _role = prefs.getString('role');
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signIn(String username, String password) async {
    // Implement sign-in logic and update state
    // Save accessToken and username to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', 'dummyAccessToken');
    await prefs.setString('username', username);
    _accessToken = 'dummyAccessToken';
    _username = username;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('username');
    _username = null;
    _accessToken = null;
    notifyListeners();
  }

  Future<void> signUp(String username, String email, String password,
      String name, String phone, String address, int age, String role) async {
    // Implement sign-up logic and update state
    notifyListeners();
  }

  Future<void> signUpByCode(String email, String code) async {
    // Implement sign-up by code logic and update state
    notifyListeners();
  }
}
