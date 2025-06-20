// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:parcel_locker_ui/navigators/home_navigator.dart';
import 'package:parcel_locker_ui/navigators/inventory_navigator.dart';
import 'package:parcel_locker_ui/navigators/notifications_navigator.dart';
import 'package:parcel_locker_ui/navigators/profile_navigator.dart';
import 'package:parcel_locker_ui/navigators/auth_navigator.dart';
import 'package:parcel_locker_ui/widgets/bottom_nav_bar.dart';

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
        endDrawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.7,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: const Color(0xFF1B2B48),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/images/user-image.jpg'),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Hieuthuhai',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Premium User',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildDrawerItem(0, Icons.home, 'Home'),
                      _buildDrawerItem(1, Icons.inventory, 'Inventory'),
                      _buildDrawerItem(2, Icons.notifications, 'Notifications'),
                      _buildDrawerItem(3, Icons.person, 'Profile'),
                      const Divider(),
                      _buildDrawerOption(Icons.settings, 'Settings'),
                      _buildDrawerOption(Icons.help_outline, 'Help & Support'),
                      _buildDrawerOption(Icons.info_outline, 'About Us'),
                      const Divider(),
                      _buildDrawerOption(Icons.logout, 'Logout',
                          textColor: Colors.red),
                    ],
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildDrawerItem(int index, IconData icon, String label) {
    final bool isSelected = _currentIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.orange : Colors.grey[600],
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.orange : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        _onTabTapped(index);
        _scaffoldKey.currentState?.closeEndDrawer();
      },
      tileColor: isSelected ? const Color(0xFFFFF8EE) : null,
    );
  }

  Widget _buildDrawerOption(IconData icon, String label, {Color? textColor}) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? Colors.grey[600],
      ),
      title: Text(
        label,
        style: TextStyle(
          color: textColor ?? Colors.black,
        ),
      ),
      onTap: () {
        if (label == 'Logout') {
          // Show logout confirmation dialog
          _showLogoutConfirmationDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label tapped')),
          );
          _scaffoldKey.currentState?.closeEndDrawer();
        }
      },
    );
  }

  // Add this new method for logout confirmation
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Perform logout action
                _logout();
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // Fix the logout method
  void _logout() {
    // Close the drawer
    _scaffoldKey.currentState?.closeEndDrawer();

    // Show logout message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have been logged out successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Use a simpler approach to navigate to the login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AuthNavigator()),
    );
  }
}
