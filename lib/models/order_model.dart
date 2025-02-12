enum OrderStatus { delivered, onDelivery, cancelled }

class OrderModel {
  final String id;
  final String merchantName;
  final String address;
  final DateTime date;
  final OrderStatus status;

  OrderModel({
    required this.id,
    required this.merchantName,
    required this.address,
    required this.date,
    required this.status,
  });
}
