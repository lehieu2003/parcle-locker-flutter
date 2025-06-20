import 'package:flutter/material.dart';

class ReviewStep extends StatelessWidget {
  final TextEditingController packageNameController;
  final String selectedSize;
  final TextEditingController deliveryAddressController;
  final TextEditingController recipientNameController;
  final TextEditingController recipientPhoneController;
  final TextEditingController noteController;

  const ReviewStep({
    super.key,
    required this.packageNameController,
    required this.selectedSize,
    required this.deliveryAddressController,
    required this.recipientNameController,
    required this.recipientPhoneController,
    required this.noteController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReviewSection(
          'Package Details',
          [
            'Package: ${packageNameController.text}',
            'Size: $selectedSize',
          ],
        ),
        const Divider(),
        _buildReviewSection(
          'Delivery Address',
          [
            'Address: ${deliveryAddressController.text}',
          ],
        ),
        const Divider(),
        _buildReviewSection(
          'Recipient',
          [
            'Name: ${recipientNameController.text}',
            'Phone: ${recipientPhoneController.text}',
          ],
        ),
        const Divider(),
        _buildReviewSection(
          'Delivery Options',
          [
            'Delivery Type: Standard Delivery',
            'Notes: ${noteController.text.isEmpty ? 'None' : noteController.text}',
          ],
        ),
        const Divider(),
        _buildReviewSection(
          'Estimated Cost',
          [
            'Package Fee: \$10.00',
            'Delivery Fee: \$5.00',
            'Total: \$15.00',
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildReviewSection(String title, List<String> details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...details.map((detail) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(detail),
              )),
        ],
      ),
    );
  }
}
