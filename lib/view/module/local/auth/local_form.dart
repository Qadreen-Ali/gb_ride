import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gb_ride/common/text_field.dart';
import 'package:gb_ride/view/auth/common/bottom_sheet_selector.dart';

class LocalForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController cnicController;
  final TextEditingController genderController;
  final TextEditingController addressController;

  const LocalForm({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.cnicController,
    required this.genderController,
    required this.addressController,
  });

  @override
  State<LocalForm> createState() => _LocalFormState();
}

class _LocalFormState extends State<LocalForm> {
  // final TextEditingController _genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // // Name
          TTextField(
            titleText: '',
            hintText: 'Full Name (as per CNIC)',
            controller: widget.fullNameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Full name is required';
              }
              return null;
            },
          ),
          // CNIC / B-Form
          TTextField(
            titleText: '',
            hintText: 'CNIC / B-Form',
            keyboardType: TextInputType.number,
            controller: widget.cnicController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'CNIC / B-Form is required';
              }
              return null;
            },
          ),

          // Gender
          TTextField(
            titleText: '',
            hintText: 'Gender',
            controller: widget.genderController,
            readOnly: true, //
            onTap: () {
              showSelectionBottomSheet(
                context: context,
                title: 'Select Gender',
                options: ['Male', 'Female', 'Other'],
                onSelected: (value) {
                  widget.genderController.text = value;
                },
              );
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Gender is required';
              }
              return null;
            },
          ),
          // Address
          TTextField(
            titleText: '',
            hintText: 'Address',
            controller: widget.addressController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Address is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
