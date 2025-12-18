import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/text_string.dart';

import '../../common/textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
