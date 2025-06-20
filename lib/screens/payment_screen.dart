import 'package:flutter/material.dart';
import 'package:parcel_locker_ui/widgets/custom_button.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? packageDetails;

  const PaymentScreen({super.key, this.packageDetails});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'Credit Card';
  bool _applyDiscount = false;
  final TextEditingController _promoCodeController = TextEditingController();

  // Mock pricing data
  late double _basePrice;
  late double _handlingFees;
  double _discountAmount = 0.0;
  late double _totalPrice;

  @override
  void initState() {
    super.initState();
    _calculatePricing();
  }

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  void _calculatePricing() {
    // Determine base price from package size
    final size = widget.packageDetails?['size'] ?? 'Small';
    switch (size) {
      case 'Small':
        _basePrice = 5.99;
        break;
      case 'Medium':
        _basePrice = 8.99;
        break;
      case 'Large':
        _basePrice = 12.99;
        break;
      default:
        _basePrice = 5.99;
    }

    // Add handling fees based on special options
    _handlingFees = 0.0;
    final specialHandling = widget.packageDetails?['specialHandling'] as List<dynamic>? ?? [];
    for (final option in specialHandling) {
      switch (option) {
        case 'Fragile':
          _handlingFees += 2.50;
          break;
        case 'Express Delivery':
          _handlingFees += 4.99;
          break;
        case 'Insurance':
          _handlingFees += 3.50;
          break;
        case 'Temperature Controlled':
          _handlingFees += 5.00;
          break;
      }
    }

    // Calculate total
    _totalPrice = _basePrice + _handlingFees - _discountAmount;
  }

  void _applyPromoCode() {
    // Simple promo code logic
    if (_promoCodeController.text.toUpperCase() == 'SAVE10') {
      setState(() {
        _discountAmount = (_basePrice + _handlingFees) * 0.1; // 10% discount
        _applyDiscount = true;
        _calculatePricing();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Discount applied successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid promo code')),
      );
    }
  }

  void _confirmOrder() {
    // Process order and navigate to confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Confirmed'),
        content: const Text('Your package has been successfully scheduled for delivery.'),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate back to home screen
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildPaymentMethodTile(
              'Credit Card',
              Icons.credit_card,
              'Pay with credit or debit card',
            ),
            _buildPaymentMethodTile(
              'PayPal',
              Icons.account_balance_wallet,
              'Pay with your PayPal account',
            ),
            _buildPaymentMethodTile(
              'Apple Pay',
              Icons.apple,
              'Quick payment with Apple Pay',
            ),
            _buildPaymentMethodTile(
              'Google Pay',
              Icons.g_mobiledata,
              'Pay with Google Pay',
            ),
            const SizedBox(height: 24),
            const Text(
              'Apply Discount',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _promoCodeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter promo code',
                      prefixIcon: Icon(Icons.discount),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: _applyPromoCode,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
            if (_applyDiscount) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset(
                    'assets/images/discount.png',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Discount Applied: -\$${_discountAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Pricing Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildPricingDetail('Base Price', '\$${_basePrice.toStringAsFixed(2)}'),
            _buildPricingDetail('Handling Fees', '\$${_handlingFees.toStringAsFixed(2)}'),
            if (_discountAmount > 0)
              _buildPricingDetail('Discount', '-\$${_discountAmount.toStringAsFixed(2)}'),
            const Divider(),
            _buildPricingDetail(
              'Total',
              '\$${_totalPrice.toStringAsFixed(2)}',
              isTotal: true,
            ),
            const SizedBox(height: 32),
            Center(
              child: CustomButton(
                text: 'Confirm Order',
                onPressed: _confirmOrder,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile(String title, IconData icon, String subtitle) {
    return RadioListTile<String>(
      title: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      subtitle: Text(subtitle),
      value: title,
      groupValue: _selectedPaymentMethod,
      onChanged: (value) {
        setState(() {
          _selectedPaymentMethod = value!;
        });
      },
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
    );
  }

  Widget _buildPricingDetail(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
