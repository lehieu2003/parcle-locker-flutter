class NotificationModel {
  final String id;
  final String message;
  final DateTime timestamp;
  final String icon;

  NotificationModel({
    required this.id,
    required this.message,
    required this.timestamp,
    this.icon = 'assets/images/package.png',
  });
}
