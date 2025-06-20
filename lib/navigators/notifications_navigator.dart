import 'package:flutter/material.dart';
import 'package:parcel_locker_ui/screens/notifications_screen.dart';

class NotificationsNavigator extends StatelessWidget {
  const NotificationsNavigator({super.key, this.navigatorKey});

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
            builder = (BuildContext context) => const NotificationsScreen();
            break;
          // Add routes for other screens within the Notifications tab
          case '/notification-detail':
            builder = (BuildContext context) =>
                const Placeholder(); // Replace with your detail screen
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
