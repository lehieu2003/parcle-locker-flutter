import 'package:flutter/material.dart';
import 'package:parcel_locker_ui/screens/inventory_screen.dart';

class InventoryNavigator extends StatelessWidget {
  const InventoryNavigator({super.key, this.navigatorKey});

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
            builder = (BuildContext context) => const InventoryScreen();
            break;
          // Add routes for other screens within the Inventory tab
          case '/inventory-detail':
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
