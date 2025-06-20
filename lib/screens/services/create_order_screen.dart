import 'package:flutter/material.dart';
import 'create_order_steps/package_details_step.dart';
import 'create_order_steps/delivery_address_step.dart';
import 'create_order_steps/recipient_info_step.dart';
import 'create_order_steps/delivery_options_step.dart';
import 'create_order_steps/review_step.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedSize = 'Medium';
  final List<String> _sizes = ['Small', 'Medium', 'Large'];

  // Current step tracker
  int _currentStep = 0;

  // Controllers for form fields
  final TextEditingController _packageNameController = TextEditingController();
  final TextEditingController _deliveryAddressController =
      TextEditingController();
  final TextEditingController _recipientNameController =
      TextEditingController();
  final TextEditingController _recipientPhoneController =
      TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // Define step titles
  final List<String> _stepTitles = [
    'Package Details',
    'Delivery Address',
    'Recipient Information',
    'Delivery Options',
    'Review & Confirm'
  ];

  @override
  void dispose() {
    _packageNameController.dispose();
    _deliveryAddressController.dispose();
    _recipientNameController.dispose();
    _recipientPhoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Go to the next step
  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      // Submit the form when on the last step
      _submitForm();
    }
  }

  // Go to the previous step
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  // Submit the form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process the form data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing order...')),
      );

      // TODO: Add your form submission logic here

      // Navigate back to previous screen after submission
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Order'),
        backgroundColor: const Color(0xFF1B2B48),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // Hide bottom navigation
      resizeToAvoidBottomInset: true,
      extendBody: false,
      body: Column(
        children: [
          // Step indicator
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            color: const Color(0xFFF5F5F5),
            child: Row(
              children: List.generate(
                5,
                (index) => Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: index <= _currentStep
                          ? const Color(0xFF1B2B48)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Step title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Step ${_currentStep + 1}: ${_stepTitles[_currentStep]}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Step content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: _buildStepContent(),
              ),
            ),
          ),

          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                if (_currentStep > 0)
                  ElevatedButton(
                    onPressed: _previousStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Back'),
                  )
                else
                  const SizedBox(width: 80),

                // Step indicator text
                Text(
                  '${_currentStep + 1}/5',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Next/Submit button
                ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B2B48),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(_currentStep < 4 ? 'Next' : 'Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return PackageDetailsStep(
          packageNameController: _packageNameController,
          selectedSize: _selectedSize,
          sizes: _sizes,
          onSizeChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedSize = newValue;
              });
            }
          },
        );
      case 1:
        return DeliveryAddressStep(
          deliveryAddressController: _deliveryAddressController,
        );
      case 2:
        return RecipientInfoStep(
          recipientNameController: _recipientNameController,
          recipientPhoneController: _recipientPhoneController,
        );
      case 3:
        return DeliveryOptionsStep(
          noteController: _noteController,
        );
      case 4:
        return ReviewStep(
          packageNameController: _packageNameController,
          selectedSize: _selectedSize,
          deliveryAddressController: _deliveryAddressController,
          recipientNameController: _recipientNameController,
          recipientPhoneController: _recipientPhoneController,
          noteController: _noteController,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
