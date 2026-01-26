import 'package:flutter/material.dart';
import 'package:gb_ride/common/text_field.dart';
import 'package:gb_ride/view/auth/common/bottom_sheet_selector.dart';

class StudentForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const StudentForm({super.key, required this.formKey});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final TextEditingController _genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // Name
          TTextField(titleText: '', hintText: 'Full Name'),
          // Number
          TTextField(
            titleText: '',
            hintText: 'Number',
            keyboardType: TextInputType.phone,
          ),

          // Father Name
          TTextField(titleText: '', hintText: 'Father Name'),

          // Gender
          TTextField(
            titleText: '',
            controller: _genderController,
            hintText: 'Gender',
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

          // Address
          TTextField(titleText: '', hintText: 'Address'),

          // Institution (Optional)
          TTextField(titleText: '', hintText: 'Institution (Optional)'),

          // Institution ID
          TTextField(titleText: '', hintText: 'Institution Id'),

          // CNIC / B-Form
          TTextField(
            titleText: '',
            hintText: 'CNIC / B-Form',
            keyboardType: TextInputType.number,
            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
    );
  }
}
