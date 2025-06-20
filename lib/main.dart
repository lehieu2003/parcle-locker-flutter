import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:parcel_locker_ui/navigators/main_auth_navigator.dart';
import 'package:parcel_locker_ui/navigators/main_navigator.dart';
import 'bloc/auth/auth_bloc.dart';
import 'providers/auth_provider.dart' as local_auth;
import 'screens/login_screen.dart';
import 'utils/navigation_service.dart';

// Tạo GlobalKey để có thể truy cập NavigatorState từ bất kỳ đâu trong ứng dụng
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Configure Firebase Auth settings globally
  FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: true,
    forceRecaptchaFlow: false,
  );

  // Set default language
  FirebaseAuth.instance.setLanguageCode('en');

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => local_auth.AuthProvider()..loadUserData(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        debugPrint(
            'MyApp BlocListener: Auth state changed to ${state.runtimeType}');
        if (state is AuthAuthenticated) {
          debugPrint('MyApp: User authenticated, navigating to MainNavigator');
          NavigationService.navigateToMain();
        } else if (state is AuthUnauthenticated) {
          debugPrint('MyApp: User unauthenticated, navigating to LoginScreen');
          NavigationService.navigateToLogin();
        }
      },
      child: MaterialApp(
        title: 'Parcel Locker App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          // Add these to ensure bottom navigation bar styling
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey[600],
          ),
        ),
        navigatorKey: navigatorKey, // Sử dụng navigatorKey toàn cục
        onGenerateRoute: (settings) {
          // Xử lý điều hướng chuyển trang ở đây nếu cần
          if (settings.name == '/login') {
            debugPrint('Main: Generating route for /login');
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          } else if (settings.name == '/main') {
            debugPrint('Main: Generating route for /main');
            return MaterialPageRoute(builder: (_) => const MainNavigator());
          }
          return null;
        },
        home: const MainAuth(),
      ),
    );
  }
}
