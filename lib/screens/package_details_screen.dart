import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parcel_locker_ui/widgets/custom_button.dart';

class PackageDetailsScreen extends StatefulWidget {
  const PackageDetailsScreen({super.key});

  @override
  State<PackageDetailsScreen> createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {
  String _selectedSize = 'Small';
  final TextEditingController _weightController = TextEditingController();
  final List<String> _specialHandlingOptions = [
    'Fragile',
    'Express Delivery',
    'Insurance',
    'Temperature Controlled'
  ];
  final List<bool> _selectedOptions = [false, false, false, false];

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _goToPaymentScreen() {
    // Calculate package details
    final packageDetails = {
      'size': _selectedSize,
      'weight': _weightController.text,
      'specialHandling': <String>[], // Initialize as an empty list
    };

    // Create a local variable with proper type to avoid null issues
    final List<String> specialHandling =
        packageDetails['specialHandling'] as List<String>;

    for (int i = 0; i < _specialHandlingOptions.length; i++) {
      if (_selectedOptions[i]) {
        specialHandling.add(_specialHandlingOptions[i]);
      }
    }

    // Navigate to payment screen with package details
    Navigator.pushNamed(
      context,
      '/payment',
      arguments: packageDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Package Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Package Size',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSizeOption(
                    'Small', 'assets/images/small-package-icon.png'),
                _buildSizeOption(
                    'Medium', 'assets/images/medium-package-icon.png'),
                _buildSizeOption(
                    'Large', 'assets/images/large-package-icon.png'),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Package Weight (kg)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter weight',
                suffixText: 'kg',
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Special Handling Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(
              _specialHandlingOptions.length,
              (index) => CheckboxListTile(
                title: Text(_specialHandlingOptions[index]),
                value: _selectedOptions[index],
                onChanged: (bool? value) {
                  setState(() {
                    _selectedOptions[index] = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: CustomButton(
                text: 'Continue to Payment',
                onPressed: _goToPaymentScreen,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeOption(String size, String imagePath) {
    final isSelected = _selectedSize == size;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : null,
        ),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 60,
              width: 60,
            ),
            const SizedBox(height: 8),
            Text(
              size,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
