import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/text_string.dart';

import '../../common/textField.dart';
import '../../utils/constants/primary_button.dart';
import '../../utils/constants/secondary_button.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(GBText. welcomeBack),
          TTextField(titleText: 'email', hintText: 'email', prefixIcon: Icon(Icons.email_outlined),

          ),

          PrimaryButton(title: 'Primary button', onPressed: () {  },),
          SizedBox(height: 10,),
          SecondaryButton(title: 'secondary Button', onPressed: () {  },)


        ],
      ),
    );
  }
}
