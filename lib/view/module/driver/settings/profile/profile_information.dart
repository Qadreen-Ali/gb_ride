import 'package:dotted_border/dotted_border.dart' as dotted_border;
import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:gb_ride/view/module/driver/common/widget/heading_text.dart';

import '../../../../../common/text_field.dart';
import '../../../../../utils/constants/color_string.dart';
import '../../../../../utils/constants/custom_app_bar.dart';
import '../../../../../utils/constants/secondary_button.dart';
import '../../../../auth/common/bottom_sheet_selector.dart';

class DriverProfileInformation extends StatefulWidget {
  const DriverProfileInformation({super.key});

  @override
  State<DriverProfileInformation> createState() =>
      _DriverProfileInformationState();
}

class _DriverProfileInformationState extends State<DriverProfileInformation> {
  final TextEditingController _genderController = TextEditingController();
  bool isSelected = false;

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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TTextField(
                  titleText: '',
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(
                    Icons.person,
                    color: isSelected ? GBColor.primary : GBColor.black,
                  ),
                ),

                TTextField(
                  titleText: '',
                  hintText: 'Enter your phone number',
                  prefixIcon: Icon(
                    Icons.phone,
                    color: isSelected ? GBColor.primary : GBColor.black,
                  ),
                  keyboardType: TextInputType.number,
                ),

                TTextField(
                  titleText: '',
                  hintText: 'Enter your email address',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: isSelected ? GBColor.primary : GBColor.black,
                  ),
                ),

                TTextField(
                  titleText: '',
                  hintText: 'Gender',
                  prefixIcon: Icon(Icons.person_outlined),
                  controller: _genderController,
                  readOnly: true,
                  onTap: _openGenderSheet,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    onPressed: _openGenderSheet,
                  ),
                ),
                SizedBox(height: 12),
                HeadingText(titleText: "Vehicle Details"),
                SizedBox(height: 12),
                TTextField(
                  titleText: '',
                  hintText: 'Honda G11',
                  prefixIcon: Icon(
                    Icons.local_taxi,
                    color: isSelected ? GBColor.primary : GBColor.black,
                  ),
                ),
                TTextField(
                  titleText: '',
                  hintText: 'Gilgit237',
                  prefixIcon: Icon(
                    Icons.add_card,
                    color: isSelected ? GBColor.primary : GBColor.black,
                  ),
                ),
                SizedBox(height: 18),

                dotted_border.DottedBorder(
                  color: GBColor.primary,
                  strokeWidth: 1.5,
                  dashPattern: [6, 4],
                  borderType: dotted_border.BorderType.RRect,
                  radius: const Radius.circular(12),
                  child: Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      color: GBColor.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 37,
                      ),
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage(GBImagePath.cloud),
                            width: 24,
                            height: 24,
                            color: GBColor.primary,
                          ),
                          SizedBox(height: 18),
                          Text(
                            "Update documents",
                            style: TextStyle(
                              color: GBColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 50),

                SecondaryButton(title: 'Update', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
