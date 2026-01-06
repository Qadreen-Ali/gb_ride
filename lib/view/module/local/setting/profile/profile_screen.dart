import 'package:flutter/material.dart';
import 'package:gb_ride/common/text_field.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/global_appbar.dart';
import 'package:gb_ride/utils/constants/secondary_button.dart';
import 'package:gb_ride/view/auth/common/bottom_sheet_selector.dart';
import 'package:gb_ride/view/module/local/setting/profile/widget/profile_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GBColor.secondary,
      appBar: GlobalAppBar(
        title: 'Profile',
        onCloseTap: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(child: ProfileImagePicker()),
            const SizedBox(height: 30),
            const Text(
              'Name',
              style: TextStyle(
                fontSize: 16,
                color: GBColor.gray,
                fontWeight: FontWeight.w600,
              ),
            ),
            TTextField(titleText: '', hintText: 'Enter your full name'),
            const SizedBox(height: 20),
            const Text(
              'Phone Number',
              style: TextStyle(
                fontSize: 16,
                color: GBColor.gray,
                fontWeight: FontWeight.w600,
              ),
            ),
            TTextField(
              titleText: '',
              hintText: 'Enter your phone number',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            const Text(
              'Mail',
              style: TextStyle(
                fontSize: 16,
                color: GBColor.gray,
                fontWeight: FontWeight.w600,
              ),
            ),
            TTextField(titleText: '', hintText: 'Enter your email address'),
            const SizedBox(height: 20),
            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 16,
                color: GBColor.gray,
                fontWeight: FontWeight.w600,
              ),
            ),
            TTextField(
              titleText: '',
              hintText: 'Gender',
              controller: _genderController,
              readOnly: true,
              onTap: () {
                showSelectionBottomSheet(
                  context: context,
                  title: 'Select Gender',
                  options: ['Male', 'Female', 'Other'],
                  onSelected: (value) {
                    _genderController.text = value;
                  },
                );
              },
            ),
            const SizedBox(height: 30),
            SecondaryButton(title: 'Update', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
