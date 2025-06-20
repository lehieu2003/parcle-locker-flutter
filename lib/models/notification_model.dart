class NotificationModel {
  final String id;
  final String message;
  final DateTime timestamp;
  final String icon;
  final NotificationType type;
  final bool isActionable;
  final String? actionLabel;

  NotificationModel({
    required this.id,
    required this.message,
    required this.timestamp,
    this.icon = 'assets/images/package.png',
    this.type = NotificationType.general,
    this.isActionable = false,
    this.actionLabel,
  });
}

enum NotificationType {
  delivery,
  pickup,
  payment,
  promo,
  general,
}
