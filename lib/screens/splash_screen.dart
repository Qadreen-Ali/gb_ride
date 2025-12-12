import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
// import 'package:gb_ride/screens/login_screen.dart';

// Change StatelessWidget to StatefulWidget
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // This method is now correctly overriding the inherited method from StatefulWidget
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After 3 seconds, navigate to login screen
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // Best practice check before navigation
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Made the entire build return const as widgets are static
      body: Center(
        // Using Center widget is simpler than configuring Column alignment
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              GBImagePath.logo,
              width: 200,
              height: 200,
              // errorBuilder: (context, error, stackTrace) {
              // return Text("Image Not Found");
              // },
            ),

            SizedBox(height: 30), //Space btw image and text

            Text(
              "Welcome to GB Ride",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            Text(
              "Make your Journey with comfort",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF7F7F7F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
