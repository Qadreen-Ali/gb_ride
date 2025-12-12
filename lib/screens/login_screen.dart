import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Email & Password inputs here...
          PrimaryButton(
            title: "Login",
            onPressed: () {
              // Handle login action
            },
            width: 350,
            height: 54,
            fontsize: 16,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
