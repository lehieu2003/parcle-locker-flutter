import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:parcel_locker_ui/models/locker_model.dart';
import 'package:url_launcher/url_launcher.dart';

class FindLockerScreen extends StatefulWidget {
  const FindLockerScreen({super.key});

  @override
  State<FindLockerScreen> createState() => _FindLockerScreenState();
}

class _FindLockerScreenState extends State<FindLockerScreen> {
  // Map controller
  final MapController _mapController = MapController();

  // Set initial map position (Ho Chi Minh City center)
  final LatLng _initialPosition =
      const LatLng(10.771890, 106.698425); // Ho Chi Minh City

  // Search controller
  final TextEditingController _searchController = TextEditingController();

  // Selected locker index
  int _selectedLockerIndex = -1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Show locker details dialog
  void _showLockerDetails(LockerModel locker) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locker.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: locker.isOpen ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    locker.isOpen ? 'Open' : 'Closed',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(locker.address),
            const SizedBox(height: 4),
            Text('Operating hours: ${locker.operatingHours}'),
            const SizedBox(height: 16),
            const Text(
              'Available Slots',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSlotInfo('Small', locker.availableSmallSlots),
                _buildSlotInfo('Medium', locker.availableMediumSlots),
                _buildSlotInfo('Large', locker.availableLargeSlots),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: locker.isOpen
                          ? () {
                              // Handle select locker action
                              Navigator.pop(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2B48),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Select This Locker'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () async {
                      final url =
                          'https://www.openstreetmap.org/?mlat=${locker.latitude}&mlon=${locker.longitude}&zoom=16';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      }
                    },
                    icon: const Icon(Icons.directions),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      foregroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build widget to display slot information
  Widget _buildSlotInfo(String type, int count) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: count > 0
                ? Colors.blue.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.inbox,
            color: count > 0 ? Colors.blue : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          type,
          style: const TextStyle(fontSize: 12),
        ),
        Text(
          count.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: count > 0 ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Locker'),
        backgroundColor: const Color(0xFF1B2B48),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by location...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),

          // Map view
          Expanded(
            child: Stack(
              children: [
                // OpenStreetMap
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _initialPosition,
                    initialZoom: 14.0,
                    minZoom: 10.0,
                    maxZoom: 18.0,
                    onTap: (tapPosition, point) {
                      // Hide any popup when tapping on the map
                      setState(() {
                        _selectedLockerIndex = -1;
                      });
                    },
                  ),
                  children: [
                    // Base map layer
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.parcel_locker_ui',
                      maxZoom: 19,
                    ),
                    // Markers layer
                    MarkerLayer(
                      markers: LockerData.lockers.map((locker) {
                        return Marker(
                          point: LatLng(locker.latitude, locker.longitude),
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap: () {
                              _showLockerDetails(locker);
                            },
                            child: Icon(
                              Icons.location_on,
                              color: locker.isOpen ? Colors.green : Colors.red,
                              size: 40,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                // Current location button
                Positioned(
                  right: 16,
                  bottom: 180,
                  child: FloatingActionButton(
                    heroTag: 'locateMe',
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    mini: true,
                    onPressed: () {
                      // For a real app, you would get actual user location
                      // For demo, just center back to Ho Chi Minh City
                      _mapController.move(_initialPosition, 14.0);
                    },
                    child: const Icon(Icons.my_location),
                  ),
                ),

                // OpenStreetMap attribution
                Positioned(
                  left: 8,
                  bottom: 170,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '© OpenStreetMap contributors',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),

                // Locker list at the bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 160, // Giảm chiều cao từ 170 xuống 160
                    clipBehavior: Clip
                        .antiAlias, // Thêm clipBehavior để cắt phần nội dung bị tràn
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16,
                              4), // Giảm padding từ top 12 xuống 8 và bottom từ 8 xuống 4
                          child: Text(
                            'Nearby Lockers',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.fromLTRB(
                                8, 0, 8, 4), // Adjust padding for better fit
                            itemCount: LockerData.lockers.length,
                            physics:
                                const ClampingScrollPhysics(), // Thêm physics để kiểm soát hành vi cuộn
                            shrinkWrap:
                                true, // Đảm bảo ListView không cố gắng mở rộng
                            itemBuilder: (context, index) {
                              final locker = LockerData.lockers[index];
                              return _buildLockerCard(locker);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build horizontal locker card
  Widget _buildLockerCard(LockerModel locker) {
    return GestureDetector(
      onTap: () {
        // Move map to locker position
        _mapController.move(
          LatLng(locker.latitude, locker.longitude),
          16.0,
        );

        // Show locker details
        _showLockerDetails(locker);
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 4), // Giảm margin dọc từ 6 xuống 4
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize
              .min, // Add this to make the column use minimum vertical space
          children: [
            Container(
              padding: const EdgeInsets.all(8), // Giảm padding từ 10 xuống 8
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.location_on, color: Colors.orange),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locker.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12, // Smaller font size
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${locker.distanceKm} km away',
                          style: TextStyle(
                            fontSize: 11, // Smaller font size
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 0, thickness: 0.5),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 6), // Giảm padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locker.isOpen ? 'Open' : 'Closed',
                        style: TextStyle(
                          color: locker.isOpen ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${locker.availableSmallSlots + locker.availableMediumSlots + locker.availableLargeSlots} slots available',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
