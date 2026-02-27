import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// AUTH
import 'package:gb_ride/view/auth/login_screen.dart';
import 'package:gb_ride/view/auth/form_screen.dart';
import 'package:gb_ride/view/auth/controller/auth_controller.dart';

// SPLASH
import 'package:gb_ride/view/splash/splash_screen.dart';

// LOCAL
import 'package:gb_ride/view/module/local/home/home_screen.dart';
import 'package:gb_ride/view/module/local/notifications/notification_screen.dart';
import 'package:gb_ride/view/module/local/setting/help_and_support/help_screen.dart';
import 'package:gb_ride/view/module/local/setting/profile/profile_screen.dart';
import 'package:gb_ride/view/module/local/setting/safety/safety_screen.dart';
import 'package:gb_ride/view/module/local/setting/setting_screen.dart';
import 'package:gb_ride/view/module/local/setting/payment_method/payment_methods_screen.dart';
import 'package:gb_ride/view/module/local/setting/history/history_screen.dart';

// DRIVER
import 'package:gb_ride/view/module/driver/home/driver_home_screen.dart';
import 'package:gb_ride/view/module/driver/notifications/notification_driver.dart';
import 'package:gb_ride/view/module/driver/settings/profile/profile_information.dart';
import 'package:gb_ride/view/module/driver/settings/profile/profile_screen.dart';
import 'package:gb_ride/view/module/driver/settings/settings_driver.dart';
import 'package:gb_ride/view/module/driver/settings/wallet/driver_wallet.dart';
import 'package:gb_ride/view/module/driver/home/app_drawer/driver_trips.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANONKEY']!,
  );

  // ✅ AuthController registered ONCE
  Get.put(AuthController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GB Ride',
      debugShowCheckedModeBanner: false,

      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/form': (context) => const FormScreen(),

        // LOCAL
        '/localhome': (context) => const LocalHomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/help': (context) => const HelpScreen(),
        '/safety': (context) => const SafetyScreen(),
        '/paymentmethod': (context) => const PaymentMethodsScreen(),
        '/history': (context) => const HistoryScreen(),

        // DRIVER
        '/driverhome': (context) => const DriverHomeScreen(),
        '/notification(driver)': (context) => const NotificationDriverScreen(),
        '/settings(driver)': (context) => const DriverSettings(),
        '/driverProfile': (context) => const DriverProfileScreen(),
        '/driverWallet': (context) => const DriverWallet(),
        '/trips': (context) => const DriverTripsScreen(),
        '/driver(profile)': (context) => const DriverProfileInformation(),
      },
    );
  }
}
