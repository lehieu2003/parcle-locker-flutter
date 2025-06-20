import 'package:flutter/material.dart';
import 'package:parcel_locker_ui/screens/home_screen.dart';
import 'package:parcel_locker_ui/screens/services/find_locker_screen.dart';
import 'package:parcel_locker_ui/screens/services/create_order_screen.dart';
import 'package:parcel_locker_ui/screens/services/check_order_screen.dart';

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({super.key, this.navigatorKey});

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
            builder = (BuildContext context) => const HomeScreen();
            break;
          case '/find-locker':
            builder = (BuildContext context) => const FindLockerScreen();
            break;
          case '/create-order':
            builder = (BuildContext context) => const CreateOrderScreen();
            break;
          case '/check-order':
            builder = (BuildContext context) => const CheckOrderScreen();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
