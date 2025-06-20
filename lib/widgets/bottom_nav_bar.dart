import 'package:flutter/material.dart';
import 'package:parcel_locker_ui/screens/services/create_order_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  final bool showUnselectedLabels;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
    this.showUnselectedLabels = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, -1),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            top: false,
            child: BottomAppBar(
              height: 60,
              padding: EdgeInsets.zero,
              elevation: 0,
              color: Colors.white,
              shape: const CircularNotchedRectangle(),
              notchMargin: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_outlined, 'Home'),
                  _buildNavItem(1, Icons.list_alt_outlined, 'Tasks'),
                  const SizedBox(width: 30),
                  _buildNavItem(
                      2, Icons.notifications_outlined, 'Notifications'),
                  _buildNavItem(3, Icons.person_outlined, 'Profile'),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -25,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: const Color(0xFFFF8A00),
            elevation: 4,
            child: const Icon(Icons.add, color: Colors.white, size: 32),
            onPressed: () {
              // Use MaterialPageRoute with fullscreenDialog set to true
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => const CreateOrderScreen(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onTabTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? const Color(0xFFFF8A00) : Colors.grey[400],
            ),
            if (showUnselectedLabels || isSelected)
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  color:
                      isSelected ? const Color(0xFFFF8A00) : Colors.grey[400],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
