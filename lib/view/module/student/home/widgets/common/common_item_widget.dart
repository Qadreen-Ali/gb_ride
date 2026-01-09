import 'package:flutter/material.dart';

import '../../../../../../common/text_field.dart';
import '../../../../../../utils/constants/color_string.dart';
import '../../../../../../utils/constants/image_string.dart';
import '../action_circle.dart';
import '../location_container.dart';
import '../rating_widget.dart';

class CommonItemWidget extends StatelessWidget {
  const CommonItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Car + Plate Row
        Row(
          children: [
            const Text(
              "Yellow Alto",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
            const Spacer(),
            Container(
              width: 73,
              height: 25,
              decoration: BoxDecoration(
                color: GBColor.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  "SMz4U",
                  style: TextStyle(
                    color: GBColor.secondary,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        /// Driver Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage(GBImagePath.profile),
                          ),
                          const Text(
                            "Hassan",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: const [
                              RatingWidget(icon: Icons.star),
                              RatingWidget(icon: Icons.star),
                              RatingWidget(icon: Icons.star),
                              RatingWidget(icon: Icons.star_half),

                              SizedBox(width: 2),
                              Text(
                                "(5)",
                                style: TextStyle(
                                  color: GBColor.messageTextColor,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ActionCircle(
                icon: Icons.call,
                label: "Contact Driver",
                onTap: () {
                  // TODO: call driver logic
                },
              ),
              ActionCircle(icon: Icons.verified, label: "Verified"),
            ],
          ),
        ),

        const SizedBox(height: 14),

        /// Message box
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: GBColor.secondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GBColor.borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.message_outlined, color: GBColor.messageTextColor),
              Text(
                "Any Message For Driver",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: GBColor.messageTextColor,
                  size: 18,
                ),
              ),
            ],
          ),
        ),

        /// Payment
        TTextField(
          titleText: 'PKR60',
          hintText: 'PKR60',
          hintTextColor: Colors.black,
          prefixIcon: Image(image: AssetImage(GBImagePath.card), width: 28),
        ),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: const Text(
            "Your current trip",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 5),

        /// Location
        const LocationContainer(),
        const SizedBox(height: 14),

        /// Emergency Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Image(
                image: AssetImage(GBImagePath.emergency),
                width: 21,
                height: 16,
              ),
              const SizedBox(width: 12),
              Text(
                "Call Emergency",
                style: TextStyle(
                  color: GBColor.error,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: GBColor.error,
                size: 20,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
