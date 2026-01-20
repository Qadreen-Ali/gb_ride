import 'package:flutter/material.dart';
import '../../../../../../../common/text_field.dart';
import '../../../../../../../utils/constants/app_sizes.dart';
import '../../../../../../../utils/constants/color_string.dart';
import '../../../../../../../utils/constants/image_string.dart';
import '../../../rating/driver_rating_screen.dart';
import 'action_circle.dart';
import 'location_container.dart';
import 'rating_widget.dart';

class CommonItemWidget extends StatelessWidget {
  const CommonItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Car + Plate Row
        Row(
          children: [
            const Expanded(
              child: Text(
                "Yellow Alto",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: GBSizes.fontSizeMd,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(width: GBSizes.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: GBSizes.sm,
                vertical: GBSizes.xs,
              ),
              decoration: BoxDecoration(
                color: GBColor.primary,
                borderRadius: BorderRadius.circular(GBSizes.borderRadiusLg),
              ),
              child: const Text(
                "SMz4U",
                style: TextStyle(
                  color: GBColor.secondary,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: GBSizes.fontSizeSm,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: GBSizes.spaceBtwItems),

        /// Driver Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: GBSizes.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Left: profile + name + rating
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: GBSizes.sm),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: GBSizes.iconLg,
                              backgroundImage: AssetImage(GBImagePath.profile),
                            ),

                            const SizedBox(height: GBSizes.xs),

                            const Text(
                              "Hassan",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: GBSizes.fontSizeSm,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: GBSizes.xs),

                            // ✅ FIX OVERFLOW: make it flexible
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  RatingWidget(icon: Icons.star),
                                  RatingWidget(icon: Icons.star),
                                  RatingWidget(icon: Icons.star),
                                  RatingWidget(icon: Icons.star_half),
                                  SizedBox(width: GBSizes.xs),
                                  Text(
                                    "(5)",
                                    style: TextStyle(
                                      color: GBColor.messageTextColor,
                                      fontSize: GBSizes.fontSizeESm,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Right: actions (kept same UI, but safe)
              ActionCircle(
                icon: Icons.call,
                label: "Contact Driver",
                onTap: () {},
              ),
              const SizedBox(width: GBSizes.sm),
              ActionCircle(icon: Icons.verified, label: "Verified"),
            ],
          ),
        ),

        Container(
          width: double.infinity,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: GBSizes.sm),
          decoration: BoxDecoration(
            color: GBColor.secondary,
            borderRadius: BorderRadius.circular(GBSizes.inputFieldRadius),
            border: Border.all(color: GBColor.borderColor),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.message_outlined,
                color: GBColor.messageTextColor,
              ),
              const SizedBox(width: GBSizes.sm),

              const Expanded(
                child: Text(
                  "Any Message For Driver",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: GBSizes.fontSizeLg,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DriverRatingScreen(
                        driverName: 'ABC',
                        driverImage: 'null',
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: GBColor.messageTextColor,
                  size: GBSizes.iconSm,
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
          prefixIcon: Image.asset(GBImagePath.card, width: GBSizes.iconMd),
        ),

        const SizedBox(height: GBSizes.sm),

        const Padding(
          padding: EdgeInsets.only(left: GBSizes.xs),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Your current trip",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: GBSizes.fontSizeEaSm,
              ),
            ),
          ),
        ),

        const SizedBox(height: GBSizes.xs),

        /// Location
        const LocationContainer(),

        const SizedBox(height: GBSizes.spaceBtwItems),

        /// Emergency Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: GBSizes.sm),
          child: Row(
            children: [
              Image.asset(GBImagePath.emergency, width: 21, height: 16),
              const SizedBox(width: GBSizes.sm),
              const Expanded(
                child: Text(
                  "Call Emergency",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: GBColor.error,
                    fontSize: GBSizes.fontSizeEaSm,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: GBColor.error,
                size: GBSizes.iconMd,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
