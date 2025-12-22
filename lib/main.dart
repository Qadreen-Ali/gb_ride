import 'package:flutter/material.dart';
import 'package:gb_ride/common/bottom_navbar.dart';
import 'package:gb_ride/view/auth/login_screen.dart';
import 'package:gb_ride/view/auth/otp_verification_screen.dart';
import 'package:gb_ride/view/module/student/home/home_screen.dart';
import 'package:gb_ride/view/splash/splash_screen.dart';
//import 'package:gb_ride/view/home/home_screen.dart';
// import 'package:logger/logger.dart';

void main() {
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
        '/otp': (context) =>
            const OTPVerificationScreen(phoneNumber: '3001234567'),
        '/bottomnavbar': (context) => const BottomNavBar(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
