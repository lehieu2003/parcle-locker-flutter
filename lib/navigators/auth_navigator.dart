import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/otp_verification_screen.dart';
import '../screens/create_new_password_screen.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Navigator(
        initialRoute: '/login',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/login':
              builder = (BuildContext context) => const LoginScreen();
              break;
            case '/register':
              builder = (BuildContext context) => const RegisterScreen();
              break;
            case '/forgot-password':
              builder = (BuildContext context) => const ForgotPasswordScreen();
              break;
            case '/otp-verification':
              builder = (BuildContext context) => const OtpVerificationScreen();
              break;
            case '/create-new-password':
              builder =
                  (BuildContext context) => const CreateNewPasswordScreen();
              break;
            default:
              builder = (BuildContext context) => const LoginScreen();
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }
}
