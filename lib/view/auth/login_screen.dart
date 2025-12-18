import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/text_string.dart';

import '../../common/textField.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final bool _isPasswordVisible = false;

  final TextEditingController _phoneController = TextEditingController(
    text: '+92 ',
  );

  @override
  Widget build(BuildContext context) {
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
