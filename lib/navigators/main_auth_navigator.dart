import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import '../bloc/auth/auth_bloc.dart';
import '../providers/auth_provider.dart' as my_auth_provider;
import '../screens/login_screen.dart';
import '../navigators/main_navigator.dart';

class MainAuth extends StatelessWidget {
  const MainAuth({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Listen to authentication state changes
        if (state is AuthAuthenticated) {
          debugPrint(
              'MainAuth: AuthAuthenticated state received, navigating to MainNavigator');
          Provider.of<my_auth_provider.AuthProvider>(context, listen: false)
              .setUser(state.user);
          Navigator.of(context).pushReplacement(
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: const MainNavigator(),
            ),
          );
        } else if (state is AuthUnauthenticated) {
          debugPrint(
              'MainAuth: AuthUnauthenticated state received, navigating to LoginScreen');
          Provider.of<my_auth_provider.AuthProvider>(context, listen: false)
              .clearUser();
          Navigator.of(context).pushReplacement(
            PageTransition(
              type: PageTransitionType.leftToRight,
              child: const LoginScreen(),
            ),
          );
        } else if (state is AuthError) {
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        // Show loading indicator while checking auth state
        debugPrint('MainAuth builder: Current state is ${state.runtimeType}');
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // Initial screen based on auth state
        if (state is AuthAuthenticated) {
          debugPrint('MainAuth builder: Returning MainNavigator');
          return const MainNavigator();
        } else {
          debugPrint('MainAuth builder: Returning LoginScreen');
          return const LoginScreen();
        }
      },
    );
  }
}
