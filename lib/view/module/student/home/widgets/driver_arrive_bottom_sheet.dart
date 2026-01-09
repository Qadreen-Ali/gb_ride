import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:gb_ride/view/module/student/home/widgets/common/common_item_widget.dart';
import 'package:gb_ride/view/module/student/home/widgets/start_ride_bottom_sheet.dart';

import '../../../../../utils/constants/color_string.dart';
import '../../../../../utils/constants/text_string.dart';
import '../../../../../utils/constants/primary_button.dart';
import 'bottom_sheet_title.dart';

class DriveArrivingBottomSheet extends StatelessWidget {
  const DriveArrivingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context); // ✅ back closes sheet
        return false;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,

        // ✅ BACKGROUND TAP → CLOSE
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        },

        child: GestureDetector(
          // ✅ Prevent closing when tapping inside panel
          onTap: () {},

          child: SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 2,
                      decoration: BoxDecoration(
                        color: GBColor.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Title
                  BottomSheetTopTitle(
                    tiltetext: GBText.driverArriveIn2Min,
                    image: Image.asset(GBImagePath.car),
                  ),
                  const SizedBox(height: 14),

                  const CommonItemWidget(),
                  const SizedBox(height: 16),

                  /// Cancel
                  PrimaryButton(
                    title: GBText.cancelRequest,
                    backgroundColor: GBColor.primary,
                    textColor: GBColor.secondary,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),

                  /// Start Ride
                  PrimaryButton(
                    title: GBText.startRide,
                    backgroundColor: GBColor.primary,
                    textColor: GBColor.secondary,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const StartRideBottomSheet(),
                      );
                    },
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
