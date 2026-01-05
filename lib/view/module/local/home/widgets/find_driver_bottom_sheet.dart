import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import '../../../../../common/text_field.dart';
import '../../../../../utils/constants/color_string.dart';
import '../../../../../utils/constants/text_string.dart';
import '../../../../../utils/constants/primary_button.dart';
import 'auto_accept_tile.dart';
import 'booking_button.dart';
import 'bottom_sheet_title.dart';
import 'driver_arrive_bottom_sheet.dart';
import 'location_container.dart';

class FindDriverBottomSheet extends StatefulWidget {
  const FindDriverBottomSheet({super.key});

  @override
  State<FindDriverBottomSheet> createState() => _FindDriverBottomSheetState();
}

class _FindDriverBottomSheetState extends State<FindDriverBottomSheet> {
  bool isAutoAccept = false;
  int fare = 60;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: true,
      //  IMPORTANT: allows scroll inside
      initialChildSize: 0.55,
      // enough space for fixed header (prevents overflow)
      minChildSize: 0.55,
      maxChildSize: 0.99,

      builder: (context, scrollController) {
        return SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                /// DRAG HANDLE
                Container(
                  width: 40,
                  height: 2,
                  decoration: BoxDecoration(
                    color: GBColor.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 12),

                /// ✅ FIXED HEADER (Always visible)
                BottomSheetTopTitle(
                  tiltetext: GBText.waitingForOffersFromDrivers,
                  image: Image.asset(GBImagePath.loading),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    BookingsButton(
                      text: '-5',
                      onTap: () {
                        if (fare > 5) setState(() => fare -= 5);
                      },
                    ),
                    const Spacer(),
                    BookingsButton(
                      text: '+5',
                      onTap: () => setState(() => fare += 5),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                PrimaryButton(
                  width: double.infinity,
                  height: 50,
                  title: GBText.raiseFare,
                  backgroundColor: Colors.green,
                  textColor: GBColor.secondary,
                  borderRadius: BorderRadius.circular(15),
                  onPressed: () => setState(() => fare += 5),
                ),

                const SizedBox(height: 12),

                AutoAcceptTile(
                  value: isAutoAccept,
                  onChanged: (v) => setState(() => isAutoAccept = v),
                ),

                const SizedBox(height: 10),

                TTextField(
                  titleText: 'PKR $fare',
                  hintText: 'PKR $fare',
                  hintTextColor: Colors.black,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      GBText.cash,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: GBColor.buttonTextText,
                      ),
                    ),
                  ),
                  prefixIcon: Image.asset(GBImagePath.card, width: 28),
                ),

                const SizedBox(height: 8),

                /// ✅ SCROLLABLE AREA (Location + Cancel will appear on scroll)
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.only(top: 12, bottom: 24),
                    children: [
                      const LocationContainer(),
                      const SizedBox(height: 16),

                      PrimaryButton(
                        title: GBText.cancelRequest,
                        backgroundColor: GBColor.primary,
                        textColor: GBColor.secondary,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const DriveArrivingBottomSheet(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
