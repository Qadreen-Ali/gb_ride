import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/utils/constants/social_button.dart';
import 'package:gb_ride/utils/constants/text_string.dart';

import '../../common/textField.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

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
    // Format: 3456 789012 (space after 4th digit)
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

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      body: Column(
        children: [
          TTextField(
            //controller: _emailController,
            titleText: GBText.emailAddress,
            hintText: GBText.emailAddress,
            prefixIcon: Icon(Icons.email_outlined),
          ),


        ],
      ),
    );
  }
}
