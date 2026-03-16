import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/secondary_button.dart';
import 'package:gb_ride/view/module/driver/common/widget/heading_text.dart';
import 'package:gb_ride/view/module/driver/settings/profile/widget/trip_widget.dart';
import 'package:gb_ride/services/ride_services/ride_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../utils/constants/color_string.dart';
import '../../../../../utils/constants/custom_app_bar.dart';
import '../../../../../utils/constants/image_string.dart';
import '../../../local/setting/profile/widget/profile_picker.dart';
import '../../../local/setting/logout/logout_screen.dart';
import '../wallet/widget/transaction_detail_widget.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  String _name = '';
  String _vehicleType = '';
  String _vehicleNumber = '';
  double _avgRating = 0.0;
  int _totalRides = 0;
  int _totalReviews = 0;
  String _joinedDate = '';
  bool _isLoading = true;

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

      if (res != null) {
        final driverId = res['id']?.toString() ?? '';
        final rating = await RideService.instance.getDriverAverageRating(
          driverId,
        );
        final rides = await RideService.instance.getDriverTotalRides(driverId);

        // Count total reviews
        final reviews = await Supabase.instance.client
            .from('ratings')
            .select('id')
            .eq('driver_id', driverId);

        final createdAt = DateTime.tryParse(res['created_at'] ?? '');
        String joined = '–';
        if (createdAt != null) {
          const months = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ];
          joined =
              '${months[createdAt.month - 1]}, ${createdAt.year.toString().substring(2)}';
        }

        if (mounted) {
          setState(() {
            _name = res['full_name'] ?? '';
            _vehicleType = res['vehicle_type'] ?? '';
            _vehicleNumber = res['vehicle_number'] ?? '';
            _avgRating = rating;
            _totalRides = rides;
            _totalReviews = reviews.length;
            _joinedDate = joined;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: GBColor.secondary,
        appBar: CustomAppBar(title: 'Profile', background: GBColor.secondary),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: GBColor.secondary,
      appBar: CustomAppBar(
        title: 'Profile',
        background: GBColor.secondary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/driver(profile)');
            },
            icon: Icon(Icons.edit, size: 20, color: GBColor.black),
          ),
        ],
      ),
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
                  _name.isNotEmpty ? _name : 'Driver',
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
                          _avgRating > 0 ? _avgRating.toStringAsFixed(1) : '–',
                          style: TextStyle(
                            color: GBColor.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '($_totalReviews reviews)',
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
                  Tripwidget(
                    text1: _totalRides.toString(),
                    text2: "Total Trips",
                  ),
                  SizedBox(width: 12),
                  Tripwidget(text1: _joinedDate, text2: "Joined"),
                ],
              ),
              SizedBox(height: 14),
              HeadingText(titleText: "Vehicle"),
              SizedBox(height: 14),
              TransactionDetailsWidget(
                rideNumber: _vehicleType.isNotEmpty ? _vehicleType : '–',
                rideTime: _vehicleNumber.isNotEmpty ? _vehicleNumber : '–',
                image: GBImagePath.car,
                showImage: false,
                ridePkr: '',
              ),
              SizedBox(height: 14),
              HeadingText(titleText: "Account"),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: GBColor.borderColor),
                  borderRadius: BorderRadius.circular(18),
                ),
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
                  ],
                ),
              ),
              SizedBox(height: 40),
              SecondaryButton(
                title: "Logout",
                onPressed: () => showLogoutConfirmation(context),
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
