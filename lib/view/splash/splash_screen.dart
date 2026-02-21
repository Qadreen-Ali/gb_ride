import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gb_ride/view/auth/controller/form_controller.dart';
import '../../utils/constants/color_string.dart';
import '../../utils/constants/image_string.dart';
import '../../utils/constants/text_string.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FormController _formController = Get.put(FormController());

  @override
  void initState() {
    super.initState();
    _handleStartup();
  }

  Future<void> _handleStartup() async {
    await Future.delayed(const Duration(seconds: 2));

    final session = Supabase.instance.client.auth.currentSession;

    if (!mounted) return;

    if (session == null) {
      Get.offAllNamed('/login');
      return;
    }

    final route = await _formController.checkUserRoute();

    if (!mounted) return;

    switch (route) {
      case FormRoute.driverHome:
        Get.offAllNamed('/driverhome');
        break;

      case FormRoute.localHome:
        Get.offAllNamed('/localhome');
        break;

      case FormRoute.formSelection:
        Get.offAllNamed('/form');
        break;

      case FormRoute.login:
        Get.offAllNamed('/login');
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
