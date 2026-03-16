// FILE: lib/screens/delete_screen.dart

import 'package:flutter/material.dart';
import 'package:gb_ride/view/auth/controller/auth_controller.dart';
import 'package:gb_ride/view/module/local/setting/widget/confirmation_dialogue.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

void showDeleteConfirmation(BuildContext context) {
  final authController = Get.find<AuthController>();
  showConfirmationDialogue(
    context,
    title: 'Delete',
    message: 'Are you sure want Delete?',
    confirmButtonText: 'Yes, Delete',
    confirmButtonColor: Colors.orange,
    onConfirm: () async {
      await authController.deleteAccount();

      // Handle delete account logic here
      // Get.snackbar(
      //   AppSnackBarString.accountDeletedTitle,
      //   AppSnackBarString.accountDeletedMessage,
      // );

      // Navigate to welcome/login screen
      // Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);

      // Or call API to delete account
      // await AccountService.deleteAccount();
    },
  );
}
