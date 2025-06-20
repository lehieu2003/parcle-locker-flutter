import 'package:flutter/material.dart';
import 'package:parcel_locker_ui/screens/profile_screen.dart';

class ProfileNavigator extends StatelessWidget {
  const ProfileNavigator({super.key, this.navigatorKey});

  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) => const ProfileScreen();
            break;
          // Add routes for other screens within the Profile tab
          case '/profile-settings':
            builder = (BuildContext context) =>
                const Placeholder(); // Replace with your settings screen
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
