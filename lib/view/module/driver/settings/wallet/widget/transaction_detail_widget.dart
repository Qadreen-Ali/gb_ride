import 'package:flutter/material.dart';

import '../../../../../../utils/constants/color_string.dart';
import '../../../../../../utils/constants/image_string.dart';

class TransactionDetailsWidget extends StatelessWidget {
  final String rideNumber;
  final String rideTime;
  final String ridePkr;
  final String image;
  final bool showImage;

  const TransactionDetailsWidget({
    required this.rideNumber,
    required this.rideTime,
    required this.ridePkr,
    super.key,
    required this.image,
    required this.showImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 71,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: GBColor.borderColor, width: 1),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: GBColor.lightblack,
                border: Border.all(color: GBColor.borderColor, width: 1),
              ),
              child: Center(
                child: Image.asset(
                  image,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rideNumber,
                  style: TextStyle(
                    color: GBColor.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                  ),
                ),

                SizedBox(height: 3),
                Text(
                  rideTime,
                  style: TextStyle(
                    color: GBColor.gray,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: showImage == true
                ? Image.asset(GBImagePath.edit, width: 24, height: 24)
                : Text(
                    ridePkr,
                    style: const TextStyle(
                      color: GBColor.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
