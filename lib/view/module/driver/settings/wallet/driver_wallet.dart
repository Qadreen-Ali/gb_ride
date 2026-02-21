import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/utils/constants/secondary_button.dart';
import 'package:gb_ride/view/module/driver/settings/wallet/widget/transaction_detail_widget.dart';

import '../../../../../utils/constants/custom_app_bar.dart';
import '../../common/widget/heading_text.dart';
class DriverWallet extends StatefulWidget {
  const DriverWallet({super.key});

  @override
  State<DriverWallet> createState() => _DriverWalletState();
}

class _DriverWalletState extends State<DriverWallet> {
  bool isTodaySelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GBColor.secondary,
      appBar: CustomAppBar(title: 'Wallet', background: GBColor.secondary),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: GBColor.borderColor, width: 1),
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [GBColor.primary, GBColor.secondary],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Text(
                      "Current Balance",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "2000.PKR",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SecondaryButton(
                      title: "Withdraw Funds",
                      onPressed: () {},
                      backgroundColor: Colors.black,
                      textColor: GBColor.secondary,

                      leadingIcon: Icon(
                        Icons.wallet,
                        color: GBColor.primary,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// Toggle Buttons
            Container(
              height: 53,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: GBColor.borderColor, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      title: 'Today',
                      onPressed: () {
                        setState(() {
                          isTodaySelected = true;
                        });
                      },
                      backgroundColor: isTodaySelected
                          ? GBColor.primary
                          : GBColor.secondary,
                      textColor: isTodaySelected
                          ? GBColor
                                .secondary // text when selected
                          : GBColor.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      title: 'This Week',
                      onPressed: () {
                        setState(() {
                          isTodaySelected = false;
                        });
                      },
                      backgroundColor: isTodaySelected
                          ? GBColor.secondary
                          : GBColor.primary,
                      textColor: isTodaySelected
                          ? GBColor
                                .black // text when selected
                          : GBColor.secondary,
                    ),
                  ),
                ],
              ),
            ),
            // Transaction History
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Transaction History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                Spacer(),
                Icon(Icons.more_horiz_outlined, color: GBColor.black),
              ],
            ),
            SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingText(titleText: "Today"),
                    SizedBox(height: 12),
                    // Transaction History Details
                    TransactionDetailsWidget(
                      rideNumber: 'Ride #492944-KIU',
                      rideTime: "2:30 PM",
                      ridePkr: "200.PKR",
                      image: GBImagePath.dollar, showImage: false,
                    ),
                    SizedBox(height: 10),
                    TransactionDetailsWidget(
                      rideNumber: 'Ride #492944-KIU',
                      rideTime: "1:30 PM",
                      ridePkr: "180.PKR",
                      image: GBImagePath.dollar,
                      showImage: false,
                    ),
                    SizedBox(height: 12),
                    HeadingText(titleText: "Last Week"),
                    SizedBox(height: 12),

                    TransactionDetailsWidget(
                      rideNumber: 'Ride #492944-KIU',
                      rideTime: "1:30 PM",
                      ridePkr: "800.PKR",
                      image: GBImagePath.dollar,
                      showImage: false,
                    ),
                    SizedBox(height: 10),
                    TransactionDetailsWidget(
                      rideNumber: 'Withdrawal to Bank',
                      rideTime: "Processed  4:30 PM",
                      ridePkr: "-6000.PKR",
                      image: GBImagePath.bank,
                      showImage: false,
                    ),
                    SizedBox(height: 60),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Button
// Row(
//   children: [
//     Expanded(
//       flex: 1,
//       child: PrimaryButton(
//         title: 'Report issue',
//         onPressed: () {},
//         backgroundColor: GBColor.error,
//         textColor: GBColor.secondary,
//
//       ),
//     ),
//     SizedBox(width: 12),
//     Expanded(
//       flex: 2,
//       child: PrimaryButton(
//         title: 'Confirm Payment',
//         onPressed: () {},
//         backgroundColor: GBColor.primary,
//         textColor: GBColor.secondary,
//       ),
//     ),
//   ],
// ),
