// FILE: lib/screens/delete_screen.dart

import 'package:flutter/material.dart';
import 'package:gb_ride/view/module/local/setting/widget/confirmation_dialogue.dart';

void showDeleteConfirmation(BuildContext context) {
  showConfirmationDialogue(
    context,
    title: 'Delete',
    message: 'Are you sure want Delete?',
    confirmButtonText: 'Yes, Delete',
    confirmButtonColor: Colors.orange,
    onConfirm: () {
      // Handle delete account logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted')),
      );
      
      // Navigate to welcome/login screen
      // Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
      
      // Or call API to delete account
      // await AccountService.deleteAccount();
    },
  );
}