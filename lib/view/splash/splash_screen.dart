import 'package:flutter/material.dart';
import 'package:gb_ride/view/auth/controller/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utils/constants/color_string.dart';
import '../../utils/constants/image_string.dart';
import '../../utils/constants/text_string.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleStartup();
  }

  Future<void> _handleStartup() async {
    // splash delay
    await Future.delayed(const Duration(seconds: 3));

    final session = Supabase.instance.client.auth.currentSession;

    if (!mounted) return;

    if (session != null) {
      final profile = await AuthController.instance.getExistingProfile(
        session.user.id,
      );

      if (!mounted) return;

      if (profile != null) {
        Navigator.pushNamed(
          context,
          profile['role'] == 'driver' ? '/driverhome' : '/localhome',
        );
      } else {
        Navigator.pushReplacementNamed(context, '/form');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            style: const TextStyle(
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
