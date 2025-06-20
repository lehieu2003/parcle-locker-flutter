import 'package:flutter/material.dart';

class DeliveryAddressStep extends StatelessWidget {
  final TextEditingController deliveryAddressController;

  const DeliveryAddressStep({
    super.key,
    required this.deliveryAddressController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Delivery address
        TextFormField(
          controller: deliveryAddressController,
          decoration: InputDecoration(
            labelText: 'Full Address',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter delivery address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // City
        TextFormField(
          decoration: InputDecoration(
            labelText: 'City',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter city';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Postal code
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Postal Code',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter postal code';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
