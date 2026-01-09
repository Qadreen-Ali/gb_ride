import 'package:flutter/material.dart';
import 'package:gb_ride/view/module/local/home/bottom_sheet/ride_flow/ride_flow_bottom_sheet.dart';
import 'package:gb_ride/view/module/local/home/bottom_sheet/ride_flow/widgets/auto-accept_tile.dart';
import 'package:gb_ride/view/module/local/home/bottom_sheet/ride_flow/widgets/booking_button.dart';
import 'package:gb_ride/view/module/local/home/bottom_sheet/ride_flow/widgets/bottom_sheet_title.dart';
import 'package:gb_ride/view/module/local/home/bottom_sheet/ride_flow/widgets/location_container.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../../../common/text_field.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/color_string.dart';
import '../../../../../utils/constants/image_string.dart';
import '../../../../../utils/constants/primary_button.dart';
import '../../../../../utils/constants/text_string.dart';

class FindDriverBottomSheet extends StatefulWidget {
  const FindDriverBottomSheet({super.key});

  @override
  State<FindDriverBottomSheet> createState() => _FindDriverBottomSheetState();
}

class _FindDriverBottomSheetState extends State<FindDriverBottomSheet> {
  bool isAutoAccept = false;
  int fare = 60;

  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context); // close bottom sheet
        return false;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,


        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        },

        child: GestureDetector(

          onTap: () {},

          child: SlidingUpPanel(
            controller: _panelController,
            minHeight: h * 0.42,
            maxHeight: h * 0.70,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(GBSizes.cardRadiusLg),
            ),
            color: Colors.white,
            panelSnapping: true,
            backdropEnabled: false,

            body: const SizedBox.expand(),

            panelBuilder: (ScrollController sc) {
              return SafeArea(
                top: false,
                bottom: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GBSizes.lg, // 24
                    vertical: GBSizes.sm,  // 8
                  ),
                  child: Column(
                    children: [
                      // FIXED HEADER
                      Center(
                        child: Container(
                          width: 40, // keep same UI
                          height: 2,
                          decoration: BoxDecoration(
                            color: GBColor.black,
                            borderRadius:
                            BorderRadius.circular(GBSizes.borderRadiusLg), // ✅
                          ),
                        ),
                      ),
                      const SizedBox(height: GBSizes.spaceBtwItems - 4), // ✅ (12)

                      BottomSheetTopTitle(
                        tiltetext: GBText.waitingForOffersFromDrivers,
                        image: Image.asset(GBImagePath.loading),
                      ),
                      const SizedBox(height: GBSizes.spaceBtwItems - 4), // ✅ (12)

                      Expanded(
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
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
                              const SizedBox(height: GBSizes.spaceBtwItems - 4), // ✅ (12)

                              PrimaryButton(
                                width: double.infinity,
                                height: 50, // keep same UI
                                title: GBText.raiseFare,
                                backgroundColor: Colors.green,
                                textColor: GBColor.secondary,
                                borderRadius:
                                BorderRadius.circular(GBSizes.buttonRadius + 3), // ✅ (15)
                                onPressed: () => setState(() => fare += 5),
                              ),
                              const SizedBox(height: GBSizes.spaceBtwItems - 4), // ✅ (12)

                              AutoAcceptTile(
                                value: isAutoAccept,
                                onChanged: (v) =>
                                    setState(() => isAutoAccept = v),
                              ),

                              TTextField(
                                titleText: 'PKR $fare',
                                hintText: 'PKR $fare',
                                hintTextColor: Colors.black,
                                suffixIcon: Padding(
                                  // ✅
                                  padding: const EdgeInsets.only(top: GBSizes.md), // 16
                                  child: Text(
                                    GBText.cash,
                                    style: const TextStyle(
                                      fontSize: GBSizes.fontSizeSm, // ✅ 14
                                      fontWeight: FontWeight.w500,
                                      color: GBColor.buttonTextText,
                                    ),
                                  ),
                                ),
                                prefixIcon:
                                Image.asset(GBImagePath.card, width: 28),
                              ),
                              const SizedBox(height: GBSizes.spaceBtwInputFields - 2), // ✅ (14)

                              const LocationContainer(),
                              const SizedBox(height: GBSizes.spaceBtwItems), // ✅ 16

                              PrimaryButton(
                                title: GBText.cancelRequest,
                                backgroundColor: GBColor.primary,
                                textColor: GBColor.secondary,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: GBColor.secondary,

                                      // ✅ Reduce space around content
                                      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 4),

                                      // ✅ Reduce space above buttons
                                      actionsPadding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: 8,
                                        top: 0,
                                      ),

                                      title: const Text(
                                        'Cancel Request',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                                          onPressed: () => Navigator.pop(context),
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
                                            Navigator.pop(context);
                                            // cancel logic here
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


                              SizedBox(height: 10,),
                              PrimaryButton(title: "Drive Arrive",
                                  borderColor:GBColor.borderColor,onPressed: (){
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => const RideFlowBottomSheet(),
                                    );
                              }),

                              const SizedBox(height: GBSizes.defaultSpace),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
