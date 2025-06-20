import 'package:flutter/material.dart';

class RecipientInfoStep extends StatelessWidget {
  final TextEditingController recipientNameController;
  final TextEditingController recipientPhoneController;

  const RecipientInfoStep({
    super.key,
    required this.recipientNameController,
    required this.recipientPhoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recipient name
        TextFormField(
          controller: recipientNameController,
          decoration: InputDecoration(
            labelText: 'Recipient Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter recipient name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Recipient phone
        TextFormField(
          controller: recipientPhoneController,
          decoration: InputDecoration(
            labelText: 'Recipient Phone Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter recipient phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Recipient email
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Recipient Email (Optional)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
