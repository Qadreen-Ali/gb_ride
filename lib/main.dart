import 'package:flutter/material.dart';
import 'package:gb_ride/view/auth/login_screen.dart';
import 'package:gb_ride/view/splash/splash_screen.dart';
import 'package:gb_ride/view/home/home.dart';
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
      // home: const SplashScreen(),
      routes: {
        '/': (context) => SplashScreen(), //initial Screen
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
