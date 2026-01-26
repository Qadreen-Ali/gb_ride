// 03465407068
import 'package:flutter/material.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/offer_fare_screen.dart';
import 'package:gb_ride/view/module/driver/home/driver_home_screen.dart';
import 'package:gb_ride/view/module/driver/notifications/notification(driver).dart';
import 'package:gb_ride/view/module/local/home/home_screen.dart';
import 'package:gb_ride/view/module/local/notifications/notification_screen.dart';
import 'package:gb_ride/view/module/local/setting/help_and_support/help_screen.dart';
import 'package:gb_ride/view/module/local/setting/profile/profile_screen.dart';
import 'package:gb_ride/view/module/local/setting/safety/safety_screen.dart';
import 'package:gb_ride/view/module/local/setting/setting_screen.dart';
import 'package:gb_ride/view/auth/login_screen.dart';
import 'package:gb_ride/view/auth/otp_verification_screen.dart';
import 'package:gb_ride/view/splash/splash_screen.dart';
import 'package:gb_ride/view/auth/form_screen.dart';
import 'package:gb_ride/view/module/local/setting/payment_method/payment_methods_screen.dart';
import 'package:gb_ride/view/module/local/setting/history/history_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gb_ride/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        '/form': (context) => FormScreen(),
        '/localhome': (context) => const LocalHomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/help': (context) => const HelpScreen(),
        '/safety': (context) => const SafetyScreen(),
        '/paymentmethod': (context) => const PaymentMethodsScreen(),
        '/history': (context) => const HistoryScreen(),
        '/driverhome': (context) => const DriverHomeScreen(),
        '/fare': (context) => const OfferFareScreen(),
        '/notification(driver)': (context) => const NotificationDriverScreen(),
      },
    );
  }
}
