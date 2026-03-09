import 'package:flutter/material.dart';
import 'package:gb_ride/view/module/local/home/bottom_sheet/ride_flow/widgets/auto_accept_tile.dart';
import 'package:gb_ride/view/module/local/home/bottom_sheet/ride_flow/widgets/booking_button.dart';
import 'package:gb_ride/view/module/local/home/bottom_sheet/ride_flow/widgets/bottom_sheet_title.dart';
import 'package:gb_ride/view/module/local/home/bottom_sheet/ride_flow/widgets/location_container.dart';
import 'package:gb_ride/view/module/local/controller/ride_controller.dart';
import 'package:get/get.dart';
import '../../../../../common/text_field.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/color_string.dart';
import '../../../../../utils/constants/image_string.dart';
import '../../../../../utils/constants/primary_button.dart';
import '../../../../../utils/constants/text_string.dart';

/// Inline bottom sheet shown when local is searching for a driver.
/// NOT a modal — swapped in by the home screen based on RideController.isSearching.
class FindDriverBottomSheet extends StatefulWidget {
  final VoidCallback? onCancelled;

  const FindDriverBottomSheet({super.key, this.onCancelled});

  @override
  State<FindDriverBottomSheet> createState() => _FindDriverBottomSheetState();
}

class _FindDriverBottomSheetState extends State<FindDriverBottomSheet> {
  final RideController _rideController = Get.find<RideController>();
  bool isAutoAccept = false;
  int fare = 60;

  @override
  void initState() {
    super.initState();
    final currentRide = _rideController.currentRide.value;
    if (currentRide != null) {
      fare = currentRide.fare.toInt();
    }
    final currentFare = _rideController.currentFare.value;
    if (currentFare > 0) {
      fare = currentFare.toInt();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GBSizes.lg,
                vertical: GBSizes.sm,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 2,
                      decoration: BoxDecoration(
                        color: GBColor.black,
                        borderRadius: BorderRadius.circular(
                          GBSizes.borderRadiusLg,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: GBSizes.spaceBtwItems - 4),

                  BottomSheetTopTitle(
                    tiltetext: GBText.waitingForOffersFromDrivers,
                    image: Image.asset(GBImagePath.loading),
                  ),
                  const SizedBox(height: GBSizes.spaceBtwItems - 4),

                  // -5 / +5 buttons
                  Row(
                    children: [
                      BookingsButton(
                        text: '-5',
                        onTap: () {
                          if (fare > 5) {
                            setState(() => fare -= 5);
                            _rideController.adjustFare(fare.toDouble());
                          }
                        },
                      ),
                      const Spacer(),
                      BookingsButton(
                        text: '+5',
                        onTap: () {
                          setState(() => fare += 5);
                          _rideController.adjustFare(fare.toDouble());
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: GBSizes.spaceBtwItems - 4),

                  PrimaryButton(
                    width: double.infinity,
                    height: 50,
                    title: GBText.raiseFare,
                    backgroundColor: Colors.green,
                    textColor: GBColor.secondary,
                    borderRadius: BorderRadius.circular(
                      GBSizes.buttonRadius + 3,
                    ),
                    onPressed: () {
                      setState(() => fare += 5);
                      _rideController.adjustFare(fare.toDouble());
                    },
                  ),
                  const SizedBox(height: GBSizes.spaceBtwItems - 4),

                  AutoAcceptTile(
                    value: isAutoAccept,
                    onChanged: (v) => setState(() => isAutoAccept = v),
                  ),

                  TTextField(
                    titleText: "",
                    hintText: 'PKR $fare',
                    hintTextColor: Colors.black,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(top: GBSizes.md),
                      child: Text(
                        GBText.cash,
                        style: const TextStyle(
                          fontSize: GBSizes.fontSizeSm,
                          fontWeight: FontWeight.w500,
                          color: GBColor.buttonTextText,
                        ),
                      ),
                    ),
                    prefixIcon: Image.asset(GBImagePath.card, width: 28),
                  ),
                  const SizedBox(height: GBSizes.spaceBtwInputFields - 2),

                  const LocationContainer(),
                  const SizedBox(height: GBSizes.spaceBtwItems),

                  PrimaryButton(
                    title: GBText.cancelRequest,
                    backgroundColor: GBColor.primary,
                    textColor: GBColor.secondary,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: GBColor.secondary,
                          contentPadding: const EdgeInsets.fromLTRB(
                            24,
                            12,
                            24,
                            4,
                          ),
                          actionsPadding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 8,
                            top: 0,
                          ),
                          title: const Text(
                            'Cancel Request',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          content: const Text(
                            'Are you sure you want to cancel this request?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: GBColor.messageTextColor,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text(
                                'No',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx); // close dialog
                                _rideController.cancelRide();
                                widget.onCancelled?.call();
                              },
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: GBSizes.defaultSpace),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
