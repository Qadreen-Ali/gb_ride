import 'package:flutter/material.dart';
import 'package:gb_ride/common/text_field.dart';
import 'package:gb_ride/view/auth/common/bottom_sheet_selector.dart';

class LocalForm extends StatefulWidget {
  const LocalForm({super.key});

  @override
  State<LocalForm> createState() => _LocalFormState();
}

class _LocalFormState extends State<LocalForm> {
  final TextEditingController _genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // // Name
        TTextField(titleText: '', hintText: 'Full Name (as per CNIC)'),
        // CNIC / B-Form
        TTextField(
          titleText: '',
          hintText: 'CNIC / B-Form',
          keyboardType: TextInputType.number,
          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),

        // Gender
        TTextField(
          titleText: '',
          hintText: 'Gender',
          controller: _genderController,
          readOnly: true, //
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
        // Number
        TTextField(
          titleText: '',
          hintText: 'Age',
          keyboardType: TextInputType.phone,
        ),
        // Address
        TTextField(titleText: '', hintText: 'Address'),
      ],
    );
  }
}
<<<<<<< HEAD
=======









>>>>>>> 1d74f430651599d8135ed11545ff0192188f626b
