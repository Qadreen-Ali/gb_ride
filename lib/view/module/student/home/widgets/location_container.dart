import 'package:flutter/material.dart';

import '../../../../../utils/constants/color_string.dart';
import '../../../../../utils/constants/text_string.dart';
import 'location_widget.dart';

class LocationContainer extends StatelessWidget {
  const LocationContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 86,
      decoration: BoxDecoration(
        border: Border.all(color: GBColor.primary),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
        child: Column(
          children: const [
            LocationWidget(
              location: GBText.sonikotGilgit,
              icon: Icons.radio_button_checked,
              iconColor: Colors.black,
            ),
            SizedBox(height: 4),
            LocationWidget(
              location: GBText.siliconGlobalTech,
              icon: Icons.location_on,
              iconColor: GBColor.primary,
            ),
          ],
        ),
      ),
    );
  }
}
