import 'package:flutter/material.dart';
import '../main.dart';

/// Lớp tiện ích để xử lý điều hướng từ bất kỳ đâu trong ứng dụng
class NavigationService {
  /// Điều hướng đến màn hình login và xóa tất cả màn hình trong stack
  static void navigateToLogin() {
    debugPrint('NavigationService: Navigating to login screen');
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil('/login', (route) => false);
  }

  /// Điều hướng đến màn hình chính sau khi đăng nhập
  static void navigateToMain() {
    debugPrint('NavigationService: Navigating to main screen');
    navigatorKey.currentState?.pushReplacementNamed('/main');
  }

  /// Điều hướng trở về màn hình trước đó
  static void goBack() {
    debugPrint('NavigationService: Going back');
    navigatorKey.currentState?.pop();
  }

  /// Điều hướng đến một màn hình được chỉ định theo tên
  static void navigateTo(String routeName) {
    debugPrint('NavigationService: Navigating to $routeName');
    navigatorKey.currentState?.pushNamed(routeName);
  }
}
