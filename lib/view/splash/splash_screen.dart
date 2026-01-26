import 'package:flutter/material.dart';
import 'package:gb_ride/view/auth/login_screen.dart';
// import 'package:gb_ride/view/module/student/home/home_screen.dart';
import '../../utils/constants/color_string.dart';
import '../../utils/constants/image_string.dart';
import '../../utils/constants/text_string.dart';
import '../module/driver/payment/payment_summary.dart';
import '../module/driver/setting/profile/profile_screen.dart';
import '../module/driver/wallet/driver_wallet.dart';
import '../module/local/home/home_screen.dart';

// import '../auth/signup_screen.dart';
// import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds then navigate
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => PaymentSummary()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 120),
          Text(
            GBText.welcometoGBRide,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 10),

          Text(
            GBText.journeyWithComfort,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: GBColor.gray,
            ),
          ),

          const SizedBox(height: 30),

          Center(child: Image(image: AssetImage(GBImagePath.logo))),
        ],
      ),
    );
  }
}
