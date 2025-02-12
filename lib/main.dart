import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/create_new_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider()..loadUserData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parcel Locker App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/', // Ensure HomeScreen is the initial route
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/otp-verification': (context) => const OtpVerificationScreen(),
        '/create-new-password': (context) => const CreateNewPasswordScreen(),
        '/home': (context) => Scaffold(
              body: const HomeScreen(),
              bottomNavigationBar: BottomNavBar(currentRoute: '/home'),
            ),
        '/inventory': (context) => Scaffold(
              body: const InventoryScreen(),
              bottomNavigationBar: BottomNavBar(currentRoute: '/inventory'),
            ),
        '/notifications': (context) => Scaffold(
              body: const NotificationsScreen(),
              bottomNavigationBar: BottomNavBar(currentRoute: '/notifications'),
            ),
        '/profile': (context) => Scaffold(
              body: const ProfileScreen(),
              bottomNavigationBar: BottomNavBar(currentRoute: '/profile'),
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          );
        }
        return null;
      },
    );
  }
}
