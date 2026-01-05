import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
// import 'package:gb_ride/utils/constants/color_string.dart';
// import 'package:gb_ride/utils/constants/text_string.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text(
            'Account',
            style: TextStyle(fontSize: 16, color: GBColor.gray),
          ),
          SizedBox(width: 382, height: 56),
        ],
      ),
    );
  }
}
