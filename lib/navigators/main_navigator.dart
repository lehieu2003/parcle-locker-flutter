// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:parcel_locker_ui/navigators/home_navigator.dart';
import 'package:parcel_locker_ui/navigators/inventory_navigator.dart';
import 'package:parcel_locker_ui/navigators/notifications_navigator.dart';
import 'package:parcel_locker_ui/navigators/profile_navigator.dart';
import 'package:parcel_locker_ui/widgets/bottom_nav_bar.dart';
import 'package:parcel_locker_ui/widgets/app_drawer.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeNavigator(navigatorKey: _navigatorKeys[0]),
      InventoryNavigator(navigatorKey: _navigatorKeys[1]),
      NotificationsNavigator(navigatorKey: _navigatorKeys[2]),
      ProfileNavigator(navigatorKey: _navigatorKeys[3]),
    ];
  }

  void _onTabTapped(int index) {
    // If we're not re-tapping the active tab
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    } else {
      // If same tab, pop to first route in navigator stack
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) async {
        if (didPop) return;

        // Close drawer if open
        if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
          Navigator.of(context).pop();
          return;
        }

        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentIndex].currentState!.maybePop();

        if (isFirstRouteInCurrentTab) {
          // If not on the first tab, switch to first tab
          if (_currentIndex != 0) {
            _onTabTapped(0);
          } else {
            // Let system handle back button if we're on the first route of the first tab
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(
          currentIndex: _currentIndex,
          onNavItemTapped: _onTabTapped,
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTabTapped: _onTabTapped,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}
