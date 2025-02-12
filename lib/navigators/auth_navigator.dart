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
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/login':
            builder = (BuildContext _) => const LoginScreen();
            break;
          case '/register':
            builder = (BuildContext _) => const RegisterScreen();
            break;
          case '/forgot-password':
            builder = (BuildContext _) => const ForgotPasswordScreen();
            break;
          case '/otp-verification':
            builder = (BuildContext _) => const OtpVerificationScreen();
            break;
          case '/create-new-password':
            builder = (BuildContext _) => const CreateNewPasswordScreen();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
