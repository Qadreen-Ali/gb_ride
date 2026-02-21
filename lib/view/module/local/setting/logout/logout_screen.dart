import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/app_snackbar_string.dart';
import 'package:get/get.dart';
import 'package:gb_ride/view/module/local/setting/widget/confirmation_dialogue.dart';
import 'package:gb_ride/view/auth/controller/auth_controller.dart';

void showLogoutConfirmation(BuildContext context) {
  final authController = Get.find<AuthController>();

  showConfirmationDialogue(
    context,
    title: 'Logout',
    message: 'Are you sure you want to log out?',
    confirmButtonText: 'Yes, Logout',
    confirmButtonColor: Colors.orange,
    onConfirm: () async {
      try {
        await authController.signOut();

        Get.snackbar(
          AppSnackBarString.logoutSuccessTitle,
          AppSnackBarString.logoutSuccessMessage,
        );

        // ❌ DO NOT navigate here
        // AuthController already handles it via onAuthStateChange
      } catch (e) {
        Get.snackbar(
          AppSnackBarString.logoutFailedTitle,
          AppSnackBarString.logoutFailedMessage,
        );
      }
    },
  );
}
