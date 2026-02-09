import 'package:flutter/material.dart';
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
          ),
          // CNIC / B-Form
          TTextField(
            titleText: '',
            hintText: 'CNIC / B-Form',
            keyboardType: TextInputType.number,
            controller: widget.cnicController,
            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
          ),
          // Address
          TTextField(
            titleText: '',
            hintText: 'Address',
            controller: widget.addressController,
          ),
        ],
      ),
    );
  }
}
