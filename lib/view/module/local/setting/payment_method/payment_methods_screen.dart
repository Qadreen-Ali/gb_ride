import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/global_appbar.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GBColor.secondary,
      appBar: GlobalAppBar(
        title: 'Payment Methods',
        showProfile: false,
        onCloseTap: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Credit & Debit Card Section
                  const Text(
                    'Credit & Debit Card',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Add a card option
                  Container(
                    decoration: BoxDecoration(
                      color: GBColor.secondary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: GBColor.secondary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.credit_card,
                          color: Colors.black87,
                          size: 20,
                        ),
                      ),
                      title: const Text(
                        'Add a card',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: GBColor.primary,
                      ),
                      onTap: () {
                        // Navigate to add card screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Add card tapped')),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// More Payment Options Section
                  const Text(
                    'More Payment Options',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Payment options container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildPaymentOption(
                          icon: 'assets/icons/easypaisa.png',
                          label: 'Easy paisa',
                          value: 'easypaisa',
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey.shade200,
                          indent: 16,
                          endIndent: 16,
                        ),
                        _buildPaymentOption(
                          icon: 'assets/icons/jazzcash.png',
                          label: 'Jazz cash',
                          value: 'jazzcash',
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey.shade200,
                          indent: 16,
                          endIndent: 16,
                        ),
                        _buildPaymentOption(
                          icon: 'assets/icons/sadapay.png',
                          label: 'Sada pay',
                          value: 'sadapay',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Confirm Payment Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withValues(alpha:0.05),
              //     blurRadius: 10,
              //     offset: const Offset(0, -5),
              //   ),
              // ],
            ),
            child: PrimaryButton(
              title: 'Confirm Payment',
              backgroundColor: GBColor.primary,
              textColor: Colors.white,
              onPressed: _selectedPaymentMethod != null
                  ? () {
                      // Handle payment confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Payment confirmed with $_selectedPaymentMethod',
                          ),
                        ),
                      );
                    }
                  : () {
                      // Show message if no payment method selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a payment method'),
                        ),
                      );
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String icon,
    required String label,
    required String value,
  }) {
    final isSelected = _selectedPaymentMethod == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? GBColor.primary.withValues(alpha:0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              /// Icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(6),
                child: Image.asset(icon, fit: BoxFit.contain),
              ),

              const SizedBox(width: 12),

              /// Text
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? GBColor.primary : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
