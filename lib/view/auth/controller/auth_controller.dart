import 'package:gb_ride/utils/constants/app_snackbar_string.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Restore session on app start
    currentUser.value = supabase.auth.currentUser;

    supabase.auth.onAuthStateChange.listen((data) {
      currentUser.value = data.session?.user;

      if (data.event == AuthChangeEvent.signedIn) {
        // ✅ MAGIC LINK SUCCESS → GO TO SPLASH
        Get.offAllNamed('/');
      }

      if (data.event == AuthChangeEvent.signedOut) {
        Get.offAllNamed('/login');
      }
    });
  }

  Future<void> signInWithEmail(String email) async {
    loading.value = true;

    try {
      await supabase.auth.signInWithOtp(
        email: email,
        emailRedirectTo: 'gbride://login-callback',
      );

      Get.snackbar('Check your email', 'We sent you a login link');
    } catch (e) {
      Get.snackbar('Login failed', e.toString());
    } finally {
      loading.value = false;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  //delete account method
  Future<void> deleteAccount() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      bool deleted = false;

      // 1️⃣ Try driver
      final driverRes = await supabase
          .from('drivers')
          .update({'is_deleted': true})
          .eq('auth_id', user.id)
          .select();

      if (driverRes.isNotEmpty) {
        deleted = true;
      }

      // 2️⃣ If not driver, try local
      if (!deleted) {
        final localRes = await supabase
            .from('locals')
            .update({'is_deleted': true})
            .eq('auth_id', user.id)
            .select();

        if (localRes.isNotEmpty) {
          deleted = true;
        }
      }

      if (!deleted) {
        throw Exception('No user record found');
      }

      // 3️⃣ Sign out
      await supabase.auth.signOut();

      // 4️⃣ Same snackbar style as login
      Get.snackbar(
        AppSnackBarString.accountDeletedTitle,
        AppSnackBarString.accountDeletedMessage,
      );
    } catch (e) {
      Get.snackbar('Delete failed', e.toString());
    }
  }
}
