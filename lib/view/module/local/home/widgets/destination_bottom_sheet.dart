import 'package:flutter/material.dart';
import '../../../../../utils/constants/color_string.dart';
import '../../../../../utils/constants/image_string.dart';
import '../../../../../utils/constants/primary_button.dart';
import '../../../../../utils/constants/text_string.dart';
import 'bottom_sheet_title.dart';
import 'common/common_item_widget.dart';

class DestinationBottomSheet extends StatelessWidget {
  const DestinationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              tiltetext: GBText.yourDestination,
              image: Image.asset(GBImagePath.car),
            ),
            const SizedBox(height: 14),
            CommonItemWidget(),
            /// Go Back
            PrimaryButton(
              title: GBText.endRide,
              backgroundColor: GBColor.primary,
              textColor: GBColor.secondary,
              onPressed: () => Navigator.pop(context),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
