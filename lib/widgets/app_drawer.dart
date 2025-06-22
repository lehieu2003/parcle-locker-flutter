import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../utils/navigation_service.dart';

class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavItemTapped;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onNavItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1B2B48),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user-image.jpg'),
                    radius: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Hieuthuhai',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem(context, 0, Icons.home, 'Home'),
                _buildNavItem(context, 1, Icons.inventory, 'Inventory'),
                _buildNavItem(context, 2, Icons.notifications, 'Notifications'),
                _buildNavItem(context, 3, Icons.person, 'Profile'),
                const Divider(),
                _buildMenuOption(context, Icons.settings, 'Settings'),
                _buildMenuOption(context, Icons.help_outline, 'Help & Support'),
                _buildMenuOption(context, Icons.info_outline, 'About Us'),
                const Divider(),
                _buildMenuOption(
                  context,
                  Icons.logout,
                  'Logout',
                  textColor: Colors.red,
                  onTap: () {
                    // Hiển thị dialog xác nhận đăng xuất
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isSelected = currentIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFFFF8A00) : Colors.grey[600],
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFFFF8A00) : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        onNavItemTapped(index);
        Navigator.pop(context); // Close the drawer
      },
      tileColor: isSelected ? const Color(0xFFFFF8EE) : null,
      shape: isSelected
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            )
          : null,
    );
  }

  Widget _buildMenuOption(
    BuildContext context,
    IconData icon,
    String label, {
    Color? textColor,
    VoidCallback? onTap,
  }) {
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
      onTap: onTap ??
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$label pressed')),
            );
            Navigator.pop(context);
          },
    );
  }

  // Thêm phương thức hiển thị dialog đăng xuất
  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                // Sử dụng BlocProvider để lấy instance của AuthBloc
                final authBloc = BlocProvider.of<AuthBloc>(context);
                // Gửi event AuthSignOutRequested để đăng xuất
                authBloc.add(AuthSignOutRequested());
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close drawer

                // Sử dụng NavigationService để điều hướng đến màn hình đăng nhập
                NavigationService.navigateToLogin();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
