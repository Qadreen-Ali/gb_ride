// 03465407068
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:gb_ride/common/bottom_navbar.dart';
// import 'package:gb_ride/setting/help_screen.dart';
import 'package:gb_ride/setting/profile_screen.dart';
import 'package:gb_ride/setting/setting_screen.dart';
import 'package:gb_ride/view/module/notifications/notification_screen.dart';
// import 'package:gb_ride/setting/profile_screen.dart';
=======
import 'package:gb_ride/view/module/local/home/home_screen.dart';
import 'package:gb_ride/view/module/local/notifications/notification_screen.dart';
import 'package:gb_ride/view/module/local/setting/profile/profile_screen.dart';
import 'package:gb_ride/view/module/local/setting/setting_screen.dart';
>>>>>>> 1d74f430651599d8135ed11545ff0192188f626b
import 'package:gb_ride/view/auth/login_screen.dart';
import 'package:gb_ride/view/auth/otp_verification_screen.dart';
import 'package:gb_ride/view/splash/splash_screen.dart';
<<<<<<< HEAD
// import 'package:gb_ride/view/home/home_screen.dart';
// import 'package:logger/logger.dart';
import 'package:gb_ride/view/auth/form_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:gb_ride/setting/setting_screen.dart';
=======
import 'package:gb_ride/view/auth/form_screen.dart';
import 'package:firebase_core/firebase_core.dart';
>>>>>>> 1d74f430651599d8135ed11545ff0192188f626b

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      //   home: const BottomNavBar(),
      routes: {
        '/': (context) => SplashScreen(), //initial Screen
        '/login': (context) => const LoginScreen(),
        '/otp': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String?;
          return OTPVerificationScreen(phoneNumber: args ?? '');
        },
        '/form': (context) => const FormScreen(),
<<<<<<< HEAD
        //'/bottomnavbar': (context) => const BottomNavBar(),
=======
>>>>>>> 1d74f430651599d8135ed11545ff0192188f626b
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/notification': (context) => const NotificationScreen(),
      },
    );
  }
}
