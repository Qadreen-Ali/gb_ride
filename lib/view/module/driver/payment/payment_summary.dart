import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../../utils/constants/app_sizes.dart';
import '../../../../../utils/constants/color_string.dart';

class PaymentSummary extends StatefulWidget {
  const PaymentSummary({super.key});

  @override
  State<PaymentSummary> createState() => _PaymentSummaryState();
}

class _PaymentSummaryState extends State<PaymentSummary> {
  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    // ignore: deprecated_member_use
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
            minHeight: h * 0.38,
            maxHeight: h * 0.75,
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
                    vertical: GBSizes.sm, // 8
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 55,
                        height: 1,
                        decoration: BoxDecoration(
                          color: GBColor.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // Heading
                      SizedBox(height: 20),
                      Text(
                        'Trip Summary',
                        style: TextStyle(
                          color: GBColor.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 6),

                      Divider(),
                      SizedBox(height: 10),

                      Text(
                        "200.PKR",
                        style: TextStyle(
                          fontFamily: 'Poppins,',
                          fontWeight: FontWeight.w600,
                          fontSize: 36,
                          color: GBColor.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 150,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: GBColor.primary),
                          borderRadius: BorderRadius.circular(25),
                          color: GBColor.black.withOpacity(0.73),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: GBColor.primary,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Cash to collect",
                                style: TextStyle(
                                  color: GBColor.secondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TripDetails(
                            text1: 'Distance',
                            text2: '12.3 km',
                            icon: Icons.location_on_outlined,
                          ),
                          SizedBox(width: 12),
                          TripDetails(
                            text1: 'Distance',
                            text2: '12.5',
                            icon: Icons.access_time_outlined,
                          ),
                          SizedBox(width: 12),

                          TripDetails(
                            text1: 'Distance',
                            text2: '10.3',
                            icon: Icons.star_border,
                          ),
                        ],
                      ),
                      SizedBox(height: 18),

                      Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          border: Border.all(color: GBColor.borderColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 10,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Route Details",
                                  style: TextStyle(
                                    color: GBColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.radio_button_checked,
                                      color: GBColor.green,
                                      size: 18,
                                    ),
                                    SizedBox(width: 12),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Noor Plaza Jutial Gilglit ",
                                            style: TextStyle(
                                              color: GBColor.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Poppins',
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "122 street  10 min away",
                                            style: TextStyle(
                                              color: GBColor.gray,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Poppins',
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    bottom: 2,
                                    top: 0,
                                  ),
                                  child: Image(
                                    image: AssetImage(GBImagePath.line),
                                    height: 17,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.adjust,
                                      color: GBColor.primary,
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "KIU Road Gilgit ",
                                          style: TextStyle(
                                            color: GBColor.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins',
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Faculty Gate KIU",
                                          style: TextStyle(
                                            color: GBColor.gray,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins',
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                //
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 90,
                        decoration: BoxDecoration(
                          color: GBColor.secondary,
                          border: Border.all(color: GBColor.borderColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: GBColor.lightblue,
                                        width: 1.5,
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage(GBImagePath.profile),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: -5,
                                    left: 35,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: GBColor.lightblue,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: GBColor.borderColor,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            "4.9",
                                            style: TextStyle(
                                              color: GBColor.secondary,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Poppins',
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(width: 30),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hassan ",
                                      style: TextStyle(
                                        color: GBColor.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Verified Rider",
                                      style: TextStyle(
                                        color: GBColor.gray,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Text(
                                "Rate passenger",
                                style: TextStyle(
                                  color: GBColor.gray,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  decoration: TextDecoration.none,
                                ),
                              ),
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

class TripDetails extends StatelessWidget {
  final String text1;
  final String text2;
  final IconData icon;

  const TripDetails({
    super.key,
    required this.text1,
    required this.text2,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 115,
        height: 110,
        decoration: BoxDecoration(
          border: Border.all(color: GBColor.borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: GBColor.primary, size: 24),
            SizedBox(height: 3),
            Text(
              text1,
              style: TextStyle(
                color: GBColor.gray,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 6),

            Text(
              text2,
              style: TextStyle(
                color: GBColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
