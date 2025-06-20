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
            // Sử dụng PageRouteBuilder cho route create-order để ẩn bottom nav
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                const CreateOrderScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;
                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
              settings: settings,
              fullscreenDialog: true,
            );
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
