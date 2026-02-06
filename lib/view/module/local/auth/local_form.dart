import 'package:flutter/material.dart';
import 'package:gb_ride/common/text_field.dart';
import 'package:gb_ride/view/auth/common/bottom_sheet_selector.dart';

class LocalForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const LocalForm({super.key, required this.formKey});

  @override
  State<LocalForm> createState() => LocalFormState();

  /// Get form data for rider registration
}

class LocalFormState extends State<LocalForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Map<String, dynamic> getFormData() {
    return {
      'fullName': _nameController.text.trim(),
      'cnic': _cnicController.text.trim(),
      'gender': _genderController.text.trim(),
      'address': _addressController.text.trim(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TTextField(
            titleText: '',
            hintText: 'Full Name (as per CNIC)',
            controller: _nameController,
          ),
          TTextField(
            titleText: '',
            hintText: 'CNIC / B-Form',
            controller: _cnicController,
            keyboardType: TextInputType.number,
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
          TTextField(
            titleText: '',
            hintText: 'Address',
            controller: _addressController,
          ),
        ],
      ),
    );
  }
}
