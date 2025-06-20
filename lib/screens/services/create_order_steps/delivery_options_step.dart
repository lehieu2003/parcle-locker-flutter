import 'package:flutter/material.dart';

class DeliveryOptionsStep extends StatelessWidget {
  final TextEditingController noteController;

  const DeliveryOptionsStep({
    super.key,
    required this.noteController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Delivery type
        const Text(
          'Delivery Type',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Icon(Icons.local_shipping, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Standard Delivery',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('2-3 business days'),
                  ],
                ),
                const Spacer(),
                Radio(
                  value: true,
                  groupValue: true,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Icon(Icons.delivery_dining, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Express Delivery',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Next business day'),
                  ],
                ),
                const Spacer(),
                Radio(
                  value: false,
                  groupValue: true,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Special instructions
        TextFormField(
          controller: noteController,
          decoration: InputDecoration(
            labelText: 'Special Instructions (Optional)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
