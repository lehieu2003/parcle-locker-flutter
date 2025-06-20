class LockerModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int availableSmallSlots;
  final int availableMediumSlots;
  final int availableLargeSlots;
  final bool isOpen; // Whether the locker is currently accessible
  final String operatingHours;
  final double distanceKm; // Distance in kilometers

  const LockerModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.availableSmallSlots,
    required this.availableMediumSlots,
    required this.availableLargeSlots,
    required this.isOpen,
    required this.operatingHours,
    required this.distanceKm,
  });
}

// Mock data for lockers
class LockerData {
  static const List<LockerModel> lockers = [
    LockerModel(
      id: 'L001',
      name: 'Locker A',
      address: '123 Nguyen Hue, District 1, Ho Chi Minh City',
      latitude: 10.773417,
      longitude: 106.702835,
      availableSmallSlots: 5,
      availableMediumSlots: 3,
      availableLargeSlots: 2,
      isOpen: true,
      operatingHours: '6:00 AM - 10:00 PM',
      distanceKm: 0.5,
    ),
    LockerModel(
      id: 'L002',
      name: 'Locker B',
      address: '45 Le Loi, District 1, Ho Chi Minh City',
      latitude: 10.771890,
      longitude: 106.698425,
      availableSmallSlots: 2,
      availableMediumSlots: 4,
      availableLargeSlots: 1,
      isOpen: true,
      operatingHours: '24 Hours',
      distanceKm: 1.0,
    ),
    LockerModel(
      id: 'L003',
      name: 'Locker C',
      address: '222 Pham Ngu Lao, District 1, Ho Chi Minh City',
      latitude: 10.767552,
      longitude: 106.693105,
      availableSmallSlots: 7,
      availableMediumSlots: 2,
      availableLargeSlots: 0,
      isOpen: false, // Currently closed
      operatingHours: '7:00 AM - 11:00 PM',
      distanceKm: 1.5,
    ),
  ];
}
