import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> notifications = [
    NotificationModel(
      id: '1',
      message: 'Don hang cua ban da den noi. Vui long ra nhan hang',
      timestamp: DateTime.now(),
    ),
    NotificationModel(
      id: '2',
      message: 'Don hang cua ban da den noi. Vui long ra nhan hang',
      timestamp: DateTime.now(),
    ),
    NotificationModel(
      id: '3',
      message: 'Don hang cua ban da den noi. Vui long ra nhan hang',
      timestamp: DateTime.now(),
    ),
    NotificationModel(
      id: '4',
      message: 'Don hang cua ban da den noi. Vui long ra nhan hang',
      timestamp: DateTime.now(),
    ),
    NotificationModel(
      id: '5',
      message: 'Don hang cua ban da den noi. Vui long ra nhan hang',
      timestamp: DateTime.now(),
    ),
    NotificationModel(
      id: '6',
      message: 'Don hang cua ban da den noi. Vui long ra nhan hang',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Group notifications by date
    final Map<String, List<NotificationModel>> groupedNotifications = {};

    for (var notification in notifications) {
      final String date = _isToday(notification.timestamp)
          ? 'Today'
          : _isYesterday(notification.timestamp)
              ? 'Yesterday'
              : DateFormat('dd/MM/yyyy').format(notification.timestamp);

      if (!groupedNotifications.containsKey(date)) {
        groupedNotifications[date] = [];
      }
      groupedNotifications[date]!.add(notification);
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2B48),
        title: const Text(
          'Notification',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: groupedNotifications.length,
        itemBuilder: (context, index) {
          final date = groupedNotifications.keys.elementAt(index);
          final notificationsForDate = groupedNotifications[date]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              ...notificationsForDate
                  .map((notification) => _buildNotificationItem(notification)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          notifications.remove(notification);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notification dismissed')),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: InkWell(
          onTap: () {
            // Handle notification tap
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.inventory_2,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.message,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('h:mm a')
                            .format(notification.timestamp)
                            .toLowerCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }
}
