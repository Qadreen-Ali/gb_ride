import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/secondary_button.dart';
import 'package:gb_ride/view/module/driver/common/widget/heading_text.dart';

import '../../../../../utils/constants/color_string.dart';
import '../../../../../utils/constants/custom_app-bar.dart';
import '../../../../../utils/constants/image_string.dart';
import '../../../local/setting/profile/widget/profile_picker.dart';
import '../../wallet/widget/transaction_detail_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GBColor.secondary,
      appBar: CustomAppBar(title: 'Profile', background: GBColor.secondary),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              SizedBox(height: 30),
              Center(child: ProfileImagePicker()),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Ali",
                  style: TextStyle(
                    color: GBColor.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Review
              Center(
                child: Container(
                  width: 150,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: GBColor.borderColor),
                    borderRadius: BorderRadius.circular(25),
                    color: GBColor.selectedContainerColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: GBColor.primary, size: 20),
                        SizedBox(width: 6),
                        Text(
                          "4.9",
                          style: TextStyle(
                            color: GBColor.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "(152 reviwes)",
                          style: TextStyle(
                            color: GBColor.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tripwidget(text1: "1,240", text2: "Total Trips"),
                  SizedBox(width: 12),
                  Tripwidget(text1: "Oct , 21", text2: "Joined"),
                ],
              ),
              SizedBox(height: 14),
              HeadingText(titleText: "Vehicle"),
              SizedBox(height: 14),
              TransactionDetailsWidget(
                rideNumber: 'Honda G11',
                rideTime: 'Gilgit237',
                image: GBImagePath.car,
                showImage: true,
                ridePkr: '',
              ),
              SizedBox(height: 14),
              HeadingText(titleText: "Account"),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 228,
                decoration: BoxDecoration(
                  border: Border.all(color: GBColor.borderColor),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      AccountItems(
                        headingText: "My Documents",
                        imagePath: GBImagePath.file,
                        badgeText: "Verified",
                        badgeColor: GBColor.lightBlue,
                        showBadge: true,
                      ),
                      AccountItems(
                        headingText: "Online Check",
                        imagePath: GBImagePath.verify,
                        badgeText: "Passed",
                        badgeColor: GBColor.secondary,
                        badgeTextColor: GBColor.gray,
                        showBadge: true,
                      ),
                      AccountItems(
                        headingText: "Language",
                        imagePath: GBImagePath.language,
                        badgeText: "English",
                        badgeColor: GBColor.secondary,
                        badgeTextColor: GBColor.gray,
                        showBadge: true,
                      ),
                      AccountItems(
                        headingText: "Settings",
                        imagePath: GBImagePath.setting,
                        showBadge: false,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              SecondaryButton(
                title: "Logout",
                onPressed: () {},
                borderColor: GBColor.error,
                backgroundColor: GBColor.secondary,
                textColor: GBColor.error,
                leadingIcon: Icon(Icons.logout, color: GBColor.error),
              ),
              SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
    );
  }
}

class AccountItems extends StatelessWidget {
  final String headingText;
  final String imagePath;

  // Optional badge (container)
  final bool showBadge;
  final String? badgeText;
  final Color badgeColor;
  final Color badgeTextColor;

  const AccountItems({
    super.key,
    required this.headingText,
    required this.imagePath,
    this.showBadge = false,
    this.badgeText,
    this.badgeColor = GBColor.lightBlue,
    this.badgeTextColor = GBColor.green,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        children: [
          Image.asset(imagePath, width: 20, height: 20, color: GBColor.gray),

          const SizedBox(width: 12),

          Text(
            headingText,
            style: const TextStyle(
              color: GBColor.gray,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),

          const Spacer(),

          if (showBadge && badgeText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badgeText!,
                style: TextStyle(
                  color: badgeTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ),

          if (showBadge) const SizedBox(width: 10),

          const Icon(Icons.arrow_forward_ios, color: GBColor.gray, size: 20),
        ],
      ),
    );
  }
}

class Tripwidget extends StatelessWidget {
  final String text1;
  final String text2;

  const Tripwidget({super.key, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 90,
      decoration: BoxDecoration(
        border: Border.all(color: GBColor.borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text1,
            style: TextStyle(
              color: GBColor.black,
              fontSize: 24,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            text2,
            style: TextStyle(
              color: GBColor.gray,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
