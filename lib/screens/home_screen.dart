import 'package:flutter/material.dart';
import 'package:parcel_locker_ui/screens/services/create_order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Add a FocusNode for the search field
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    // Clean up the focus node when the widget is disposed
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            expandedHeight: 190,
            backgroundColor: const Color(0xFF1B2B48),
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 10),
                child: Column(
                  children: [
                    // Profile and Menu Row
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/user-image.jpg'),
                          radius: 30,
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreetingMessage(),
                              style: const TextStyle(
                                  color: Colors.orange, fontSize: 12),
                            ),
                            const Text(
                              'Hieuthuhai',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            // Open the end drawer
                            Scaffold.of(context).openEndDrawer();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Search Bar - updated with focusNode
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        focusNode: _searchFocusNode, // Add the focus node
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search your parcels...',
                          hintStyle:
                              TextStyle(color: Colors.white.withAlpha(128)),
                          border: InputBorder.none,
                          icon: Icon(Icons.search,
                              color: Colors.white.withAlpha(128)),
                        ),
                        // When tapped, explicitly request focus to prevent automatic focus
                        onTap: () {
                          _searchFocusNode.requestFocus();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Promotional Banner
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2B48),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ramadan Offers',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Get 25%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF1B2B48),
                            ),
                            child: const Text('Grab Offer'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Services Categories
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Services categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildServiceItem(
                              context,
                              'assets/images/find-locker-icon.png',
                              'Find\nLocker',
                              Colors.orange,
                              '/find-locker'),
                          _buildServiceItem(
                              context,
                              'assets/images/create-order-icon.png',
                              'Create\nOrder',
                              Colors.orange,
                              '/create-order'),
                          _buildServiceItem(
                              context,
                              'assets/images/check-order-icon.png',
                              'Check\nOrder',
                              Colors.orange,
                              '/check-order'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Live Tracking
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Live tracking',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTrackingCard(
                          'assets/images/large-package-icon.png'),
                      const SizedBox(height: 16),
                      _buildTrackingCard(
                          'assets/images/medium-package-icon.png'),
                      const SizedBox(height: 16),
                      _buildTrackingCard(
                          'assets/images/small-package-icon.png'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Widget _buildServiceItem(BuildContext context, String iconPath, String label,
      Color color, String route) {
    return InkWell(
      onTap: () {
        if (route == '/create-order') {
          // Use MaterialPageRoute with fullscreenDialog set to true
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateOrderScreen(),
              fullscreenDialog: true,
            ),
          );
        } else {
          Navigator.of(context).pushNamed(route);
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(iconPath, width: 35, height: 35),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingCard(String iconPath) {
    String packageName;
    if (iconPath == 'assets/images/large-package-icon.png') {
      packageName = "Dad's Present";
    } else if (iconPath == 'assets/images/medium-package-icon.png') {
      packageName = "Friend's Gift";
    } else if (iconPath == 'assets/images/small-package-icon.png') {
      packageName = "Mom's Present";
    } else {
      packageName = "Unknown Package";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(iconPath, width: 24, height: 24),
              ),
              const SizedBox(width: 12),
              Text(
                packageName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTrackingStep('Packaging', true, false),
              _buildTrackingStep('Sending', true, false),
              _buildTrackingStep('Delivery', false, false),
              _buildTrackingStep('Arrived', false, true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStep(String label, bool isCompleted, bool isLast) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? Colors.orange : Colors.grey.shade300,
                  ),
                ),
                if (isCompleted)
                  const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
              ],
            ),
            if (!isLast)
              Container(
                width: 64,
                height: 2,
                color: isCompleted ? Colors.orange : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isCompleted ? Colors.orange : Colors.grey,
          ),
        ),
      ],
    );
  }
}
