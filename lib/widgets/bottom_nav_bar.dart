import 'package:flutter/material.dart';
import 'package:parcel_locker_ui/screens/home_screen.dart';
import 'package:parcel_locker_ui/screens/inventory_screen.dart';
import 'package:parcel_locker_ui/screens/notifications_screen.dart';
import 'package:parcel_locker_ui/screens/profile_screen.dart';

int screenIndex = 0;
// ignore: non_constant_identifier_names
List Screen = [
  HomeScreen(),
  InventoryScreen(),
  NotificationsScreen(),
  ProfileScreen()
];

class BottomNavBar extends StatefulWidget {
  final String currentRoute;

  const BottomNavBar({super.key, required this.currentRoute});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  screenIndex = 0;
                });
                Navigator.pushNamed(context, '/home');
              },
              child: Icon(
                Icons.home,
                size: 27,
                color: widget.currentRoute == '/home'
                    ? Color(0xFFFF8A00)
                    : Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  screenIndex = 1;
                });
                Navigator.pushNamed(context, '/inventory');
              },
              child: Icon(
                Icons.inventory,
                size: 27,
                color: widget.currentRoute == '/inventory'
                    ? Color(0xFFFF8A00)
                    : Colors.black,
              ),
            ),
            const SizedBox(width: 30),
            GestureDetector(
              onTap: () {
                setState(() {
                  screenIndex = 2;
                });
                Navigator.pushNamed(context, '/notifications');
              },
              child: Icon(
                Icons.notifications,
                size: 27,
                color: widget.currentRoute == '/notifications'
                    ? Color(0xFFFF8A00)
                    : Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  screenIndex = 3;
                });
                Navigator.pushNamed(context, '/profile');
              },
              child: Icon(
                Icons.person,
                size: 27,
                color: widget.currentRoute == '/profile'
                    ? Color(0xFFFF8A00)
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {},
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Screen[screenIndex],
    );
  }
}
