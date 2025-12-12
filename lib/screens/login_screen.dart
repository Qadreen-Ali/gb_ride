import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Create your account', style: TextStyle(color: Colors.black ,fontSize: 24)),
          // SizedBox(),
          Text('Connecting Gilgit Baltistan, One Ride at a Time'),
          Container(),
        ],
      ),
    );
  }
}
