import 'package:flutter/services.dart';

class PakPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Get only digits
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    // Remove leading zero
    if (digitsOnly.startsWith('0')) {
      digitsOnly = digitsOnly.substring(1);
    }
    // Limit to 10 digits
    if (digitsOnly.length > 10) {
      digitsOnly = digitsOnly.substring(0, 10);
    }
    // Format: 345 6789012 (space after 3th digit)
    String formatted = '';
    if (digitsOnly.length <= 3) {
      formatted = digitsOnly;
    } else {
      formatted = '${digitsOnly.substring(0, 3)} ${digitsOnly.substring(3)}';
    }
    // kept cursor at the end - this prevents the stuck issue
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}