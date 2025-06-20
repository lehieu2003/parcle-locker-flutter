import 'package:flutter/material.dart';

class PackageDetailsStep extends StatelessWidget {
  final TextEditingController packageNameController;
  final String selectedSize;
  final List<String> sizes;
  final Function(String?) onSizeChanged;

  const PackageDetailsStep({
    super.key,
    required this.packageNameController,
    required this.selectedSize,
    required this.sizes,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Package name
        TextFormField(
          controller: packageNameController,
          decoration: InputDecoration(
            labelText: 'Package Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a package name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Package size
        DropdownButtonFormField<String>(
          value: selectedSize,
          decoration: InputDecoration(
            labelText: 'Package Size',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: sizes.map((String size) {
            return DropdownMenuItem<String>(
              value: size,
              child: Text(size),
            );
          }).toList(),
          onChanged: onSizeChanged,
        ),
        const SizedBox(height: 16),

        // Package weight
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Weight (kg)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter package weight';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Package description
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Package Description (Optional)',
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
