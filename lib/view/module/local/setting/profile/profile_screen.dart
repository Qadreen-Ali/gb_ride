import 'package:flutter/material.dart';
import 'package:gb_ride/common/text_field.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/secondary_button.dart';
import 'package:gb_ride/view/auth/common/bottom_sheet_selector.dart';
import 'package:gb_ride/view/module/local/setting/profile/widget/profile_picker.dart';

import '../../../../../utils/constants/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _genderController = TextEditingController();

  @override
  void dispose() {
    _genderController.dispose();
    super.dispose();
  }

  void _openGenderSheet() {
    FocusScope.of(context).unfocus();
    showSelectionBottomSheet(
      context: context,
      title: 'Select Gender',
      options: ['Male', 'Female', 'Other'],
      onSelected: (value) {
        setState(() {
          _genderController.text = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomKeyboard = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: GBColor.secondary,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        showLeading: false,
        title: 'Profile',
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: GBColor.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: GBColor.secondary),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomKeyboard),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(child: ProfileImagePicker()),
              const SizedBox(height: 30),

              TTextField(titleText: 'Name', hintText: 'Enter your full name'),
              const SizedBox(height: 20),

              TTextField(
                titleText: 'Phone Number',
                hintText: 'Enter your phone number',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              TTextField(
                titleText: 'Email',
                hintText: 'Enter your email address',
              ),

              const SizedBox(height: 20),

              TTextField(
                titleText: 'Gender',
                hintText: 'Gender',
                controller: _genderController,
                readOnly: true,
                onTap: _openGenderSheet,
                suffixIcon: IconButton(
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  onPressed: _openGenderSheet,
                ),
              ),

              const SizedBox(height: 30),
              SecondaryButton(title: 'Update', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
