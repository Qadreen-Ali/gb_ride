import 'package:flutter/material.dart';
import 'package:gb_ride/view/module/local/setting/widget/confirmation_dialogue.dart';

void showLogoutConfirmation(BuildContext context) {
  showConfirmationDialogue(
    context,
    title: 'Logout',
    message: 'Are you sure you want log out?',
    confirmButtonText: 'Yes, Logout',
    confirmButtonColor: Colors.orange,
    onConfirm: () {
      // Handle logout logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
      
      // Navigate to login screen
      // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      
      // Or navigate to specific screen
      // Navigator.of(context).pushReplacementNamed('/login');
    },
  );
}