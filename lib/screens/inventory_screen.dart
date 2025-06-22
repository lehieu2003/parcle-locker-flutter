import 'package:flutter/material.dart';
import '../models/order_model.dart';
import 'package:intl/intl.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = [
    'All',
    'On Delivery',
    'Delivered',
    'Cancelled'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<OrderModel> _orders = [
    OrderModel(
      id: '1',
      merchantName: 'Shopee',
      address: '129 Nguyen Thi Minh Khai, Ho Chi Minh City',
      date: DateTime(2024, 2, 17),
      status: OrderStatus.delivered,
    ),
    OrderModel(
      id: '2',
      merchantName: 'Document',
      address: 'Internation University,..',
      date: DateTime(2023, 11, 24),
      status: OrderStatus.cancelled,
    ),
    OrderModel(
      id: '3',
      merchantName: "Mom's Present",
      address: 'Locker B13, 81 Le Van Sy,...',
      date: DateTime(2024, 3, 26),
      status: OrderStatus.onDelivery,
    ),
    OrderModel(
      id: '4',
      merchantName: 'Shopee',
      address: '129 Nguyen Thi Minh Khai, Ho Chi Minh City',
      date: DateTime(2024, 2, 17),
      status: OrderStatus.delivered,
    ),
    OrderModel(
      id: '5',
      merchantName: 'Shopee',
      address: '129 Nguyen Thi Minh Khai, Ho Chi Minh City',
      date: DateTime(2024, 2, 17),
      status: OrderStatus.delivered,
    ),
  ];
  List<OrderModel> get filteredOrders {
    return _orders.where((order) {
      // Filter by status
      bool statusMatch = true;
      if (_selectedFilter != 'All') {
        statusMatch = order.status.toString().split('.').last.toLowerCase() ==
            _selectedFilter.replaceAll(' ', '').toLowerCase();
      }

      // Filter by search text
      bool searchMatch = true;
      if (_searchController.text.isNotEmpty) {
        final searchText = _searchController.text.toLowerCase();
        searchMatch = order.merchantName.toLowerCase().contains(searchText) ||
            order.address.toLowerCase().contains(searchText) ||
            order.id.toLowerCase().contains(searchText);
      }

      return statusMatch && searchMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2B48),
        title: const Text(
          'Order History',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by merchant, address, or order ID',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                isSelected ? Colors.orange : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? Colors.orange : Colors.grey,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return _buildOrderCard(order);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.inventory_2, color: Colors.orange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order.merchantName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        _buildStatusBadge(order.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMMM, yyyy').format(order.date),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.address,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case OrderStatus.delivered:
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green;
        text = 'Delivered';
        break;
      case OrderStatus.onDelivery:
        backgroundColor = Colors.yellow[50]!;
        textColor = Colors.orange;
        text = 'On Delivery';
        break;
      case OrderStatus.cancelled:
        backgroundColor = Colors.red[50]!;
        textColor = Colors.red;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
