import 'package:flutter/material.dart';
import 'package:gb_ride/common/text_field.dart';
import 'package:gb_ride/view/auth/common/bottom_sheet_selector.dart';

class LocalForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const LocalForm({super.key, required this.formKey});

  @override
  State<LocalForm> createState() => _LocalFormState();

  /// Get form data for rider registration
  static Map<String, dynamic>? getFormData(BuildContext context) {
    final state = context.findAncestorStateOfType<_LocalFormState>();
    if (state == null) {
      return null;
    }

    return {
      'fullName': state._nameController.text,
      'cnic': state._cnicController.text,
      'gender': state._genderController.text,
      'address': state._addressController.text,
    };
  }
}

class _LocalFormState extends State<LocalForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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
