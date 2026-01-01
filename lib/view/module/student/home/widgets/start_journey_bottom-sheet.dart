import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:gb_ride/view/module/student/home/widgets/rating_widget.dart';
import '../../../../../common/textField.dart';
import '../../../../../utils/constants/color_string.dart';
import '../../../../../utils/constants/image_string.dart';
import '../../../../../utils/constants/primary_button.dart';
import '../../../../../utils/constants/text_string.dart';
import 'action_circle.dart';
import 'bottom_sheet_title.dart';
import 'common/common_item_widget.dart';
import 'destination_bottom_sheet.dart';
import 'location_container.dart';

class StartJourneyBottomSheet extends StatelessWidget {
  const StartJourneyBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
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
            BottomSheetTopTitle(tiltetext: GBText.startJourney, image: Image.asset(GBImagePath.car),),
            const SizedBox(height: 14),


            CommonItemWidget(),

            // Destination
            PrimaryButton(
              title: GBText.accepeted,
              backgroundColor: GBColor.primary,
              textColor: GBColor.secondary,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const DestinationBottomSheet(),
                );
              },

            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}


