import 'package:flutter/material.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 120,),

          Text("Welcome to GB Ride", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
          SizedBox(height: 10,),
          Text("Make your Journey with comfort", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF7F7F7F),),)
        ],
      ),

    );
  }
}
