import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
import 'package:gb_ride/view/home/home.dart';

import '../../common/textField.dart';

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
