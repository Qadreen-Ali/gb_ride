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

    // Listen to auth changes
    supabase.auth.onAuthStateChange.listen((data) {
      currentUser.value = data.session?.user;

      if (data.event == AuthChangeEvent.signedIn) {
        _handlePostLogin();
      }

      if (data.event == AuthChangeEvent.signedOut) {
        Get.offAllNamed('/login');
      }
    });
  }

  /// Send magic link to email
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

  /// Called automatically after magic link success
  Future<void> _handlePostLogin() async {
    // DO NOT put redirect logic here yet
    // FormController will decide where to go
    Get.offAllNamed('/loading');
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
