import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notification_model.dart';
import '../widgets/empty_notification_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationType? _selectedFilter;
  bool _showActionableOnly = false;

  // Sample notification data with different types
  List<NotificationModel> allNotifications = [
    NotificationModel(
      id: '1',
      message: 'Your package has arrived. Please pick it up.',
      timestamp: DateTime.now(),
      type: NotificationType.pickup,
      isActionable: true,
      actionLabel: 'View Details',
    ),
    NotificationModel(
      id: '2',
      message: 'Your package is on its way to the locker.',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      type: NotificationType.delivery,
      isActionable: false,
    ),
    NotificationModel(
      id: '3',
      message: 'Payment received for order #1234.',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      type: NotificationType.payment,
      isActionable: false,
    ),
    NotificationModel(
      id: '4',
      message: 'Special Offer: 20% off on your next delivery!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.promo,
      isActionable: true,
      actionLabel: 'Use Now',
    ),
    NotificationModel(
      id: '5',
      message: 'Your package delivery has been scheduled.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.delivery,
      isActionable: false,
    ),
    NotificationModel(
      id: '6',
      message: 'Package delivery failed. Please update your delivery instructions.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.delivery,
      isActionable: true,
      actionLabel: 'Update',
    ),
  ];

  List<NotificationModel> get filteredNotifications {
    return allNotifications.where((notification) {
      // Apply type filter if selected
      if (_selectedFilter != null && notification.type != _selectedFilter) {
        return false;
      }

      // Apply actionable filter if enabled
      if (_showActionableOnly && !notification.isActionable) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Group notifications by date
    final Map<String, List<NotificationModel>> groupedNotifications = {};

    for (var notification in filteredNotifications) {
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
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedFilter != null || _showActionableOnly)
            _buildActiveFilters(),
          Expanded(
            child: filteredNotifications.isEmpty
                ? const EmptyNotificationState()
                : ListView.builder(
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
                          ...notificationsForDate.map(
                              (notification) => _buildNotificationItem(notification)),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[200],
      child: Row(
        children: [
          const Text('Active filters:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          if (_selectedFilter != null)
            _buildFilterChip(_getFilterName(_selectedFilter!), () {
              setState(() {
                _selectedFilter = null;
              });
            }),
          if (_showActionableOnly)
            _buildFilterChip('Actionable', () {
              setState(() {
                _showActionableOnly = false;
              });
            }),
          const Spacer(),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedFilter = null;
                _showActionableOnly = false;
              });
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Notifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'By Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildTypeFilterOption(NotificationType.delivery, 'Delivery', setModalState),
                      _buildTypeFilterOption(NotificationType.pickup, 'Pickup', setModalState),
                      _buildTypeFilterOption(NotificationType.payment, 'Payment', setModalState),
                      _buildTypeFilterOption(NotificationType.promo, 'Promotions', setModalState),
                      _buildTypeFilterOption(NotificationType.general, 'General', setModalState),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Other Filters',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('Show actionable items only'),
                    value: _showActionableOnly,
                    onChanged: (value) {
                      setModalState(() {
                        _showActionableOnly = value!;
                      });
                      setState(() {
                        _showActionableOnly = value!;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTypeFilterOption(NotificationType type, String label, StateSetter setModalState) {
    final isSelected = _selectedFilter == type;

    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (selected) {
        setModalState(() {
          _selectedFilter = selected ? type : null;
        });
        setState(() {
          _selectedFilter = selected ? type : null;
        });
      },
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: _getNotificationColor(notification.type).withOpacity(0.1),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: _getNotificationColor(notification.type),
              ),
            ),
            title: Text(
              notification.message,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                DateFormat('HH:mm').format(notification.timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          if (notification.isActionable)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: OutlinedButton(
                onPressed: () => _handleNotificationAction(notification),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _getNotificationColor(notification.type),
                  side: BorderSide(color: _getNotificationColor(notification.type)),
                ),
                child: Text(notification.actionLabel ?? 'Action'),
              ),
            ),
        ],
      ),
    );
  }

  void _handleNotificationAction(NotificationModel notification) {
    switch (notification.type) {
      case NotificationType.pickup:
        // Navigate to pickup details or check order screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigating to package details...')),
        );
        break;
      case NotificationType.promo:
        // Apply promo code
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Promo code applied to your account')),
        );
        break;
      case NotificationType.delivery:
        // Update delivery instructions
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update your delivery preferences')),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Action handled')),
        );
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.delivery:
        return Colors.blue;
      case NotificationType.pickup:
        return Colors.green;
      case NotificationType.payment:
        return Colors.purple;
      case NotificationType.promo:
        return Colors.orange;
      case NotificationType.general:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.delivery:
        return Icons.local_shipping;
      case NotificationType.pickup:
        return Icons.inventory;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.promo:
        return Icons.discount;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  String _getFilterName(NotificationType type) {
    switch (type) {
      case NotificationType.delivery:
        return 'Delivery';
      case NotificationType.pickup:
        return 'Pickup';
      case NotificationType.payment:
        return 'Payment';
      case NotificationType.promo:
        return 'Promotions';
      case NotificationType.general:
        return 'General';
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.day == now.day && date.month == now.month && date.year == now.year;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.day == yesterday.day &&
        date.month == yesterday.month &&
        date.year == yesterday.year;
  }
}
