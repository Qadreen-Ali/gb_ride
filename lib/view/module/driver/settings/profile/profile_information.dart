import 'package:dotted_border/dotted_border.dart' as dotted_border;
import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:gb_ride/view/module/driver/common/widget/heading_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();

  bool isSelected = false;
  bool _isLoading = true;
  bool _isSaving = false;
  String _driverId = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final authId = Supabase.instance.client.auth.currentUser?.id ?? '';
      if (authId.isEmpty) return;

      final res = await Supabase.instance.client
          .from('drivers')
          .select()
          .eq('auth_id', authId)
          .maybeSingle();

      if (res != null && mounted) {
        _driverId = res['id']?.toString() ?? '';
        _nameController.text = res['full_name'] ?? '';
        _phoneController.text = res['phone_number'] ?? '';
        _addressController.text = res['address'] ?? '';
        _genderController.text = res['gender'] ?? '';
        _vehicleTypeController.text = res['vehicle_type'] ?? '';
        _vehicleNumberController.text = res['vehicle_number'] ?? '';
      }
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _updateProfile() async {
    if (_driverId.isEmpty) return;
    setState(() => _isSaving = true);
    try {
      await Supabase.instance.client
          .from('drivers')
          .update({
            'full_name': _nameController.text.trim(),
            'address': _addressController.text.trim(),
            'gender': _genderController.text.trim(),
            'vehicle_type': _vehicleTypeController.text.trim(),
            'vehicle_number': _vehicleNumberController.text.trim(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _driverId);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile updated')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
    if (mounted) setState(() => _isSaving = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _genderController.dispose();
    _vehicleTypeController.dispose();
    _vehicleNumberController.dispose();
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
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TTextField(
                        titleText: '',
                        hintText: 'Enter your full name',
                        controller: _nameController,
                        prefixIcon: Icon(
                          Icons.person,
                          color: isSelected ? GBColor.primary : GBColor.black,
                        ),
                      ),

                      TTextField(
                        titleText: '',
                        hintText: 'Enter your phone number',
                        controller: _phoneController,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: isSelected ? GBColor.primary : GBColor.black,
                        ),
                        keyboardType: TextInputType.number,
                        readOnly: true,
                      ),

                      TTextField(
                        titleText: '',
                        hintText: 'Enter your address',
                        controller: _addressController,
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
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
                        hintText: 'Vehicle type',
                        controller: _vehicleTypeController,
                        prefixIcon: Icon(
                          Icons.local_taxi,
                          color: isSelected ? GBColor.primary : GBColor.black,
                        ),
                      ),
                      TTextField(
                        titleText: '',
                        hintText: 'Vehicle number',
                        controller: _vehicleNumberController,
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

                      SecondaryButton(
                        title: _isSaving ? 'Saving...' : 'Update',
                        onPressed: _isSaving ? () {} : _updateProfile,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
