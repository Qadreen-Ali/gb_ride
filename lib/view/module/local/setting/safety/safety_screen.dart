import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/global_appbar.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  void _onTap(BuildContext context, String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Tapped $title')));
  }

  Widget _safetyTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required backGroundcolor,
    Color iconColor = GBColor.black,
    
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: GBColor.secondary,
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: GlobalAppBar(
        title: 'Safety',
        profileImage: 'assets/icons/profile.jpg',
        showProfile: true,
        onCloseTap: () => Navigator.pop(context),
        onProfileTap: () {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),

            /// Subtitle
            const Text(
              'Your safety is our priority. Access tools and resources to help you feel secure',
              style: TextStyle(color: GBColor.black, fontSize: 13),
            ),

            const SizedBox(height: 18),

            /// SOS Buttons
            Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PrimaryButton(
                        title: 'Emergency',
                        height: 48,
                        backgroundColor: Colors.red,
                        onPressed: () {
                          // emergency action
                        },
                      ),
                      const Positioned(
                        left: 16,
                        child: Text(
                          'SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Positioned(
                        right: 16,
                        child: Text(
                          'SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            const SizedBox(height: 22),

            /// First Card Container - Share & Contacts
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: GBColor.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _safetyTile(
                    icon: SolarLinearIcons.share,
                    title: 'Share my Trip',
                    onTap: () => _onTap(context, 'Share my Trip'),
                    iconColor: Colors.black,
                    backGroundcolor: GBColor.secondary,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(
                      color: GBColor.borderColor,
                      thickness: 1,
                      height: 1,
                    ),
                  ),
                  _safetyTile(
                    icon: SolarLinearIcons.usersGroupRounded,
                    title: 'Trusted Contacts',
                    onTap: () => _onTap(context, 'Trusted Contacts'),
                    backGroundcolor: GBColor.secondary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Second Card Container - Safety Tools
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: GBColor.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _safetyTile(
                    icon: SolarLinearIcons.dangerTriangle,
                    title: 'Report a safety issue',
                    onTap: () => _onTap(context, 'Report a safety issue'),
                    backGroundcolor: GBColor.secondary,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(
                      color: GBColor.borderColor,
                      thickness: 1,
                      height: 1,
                    ),
                  ),
                  _safetyTile(
                    icon: SolarLinearIcons.shieldCheck,
                    title: 'Safety Guidelines & Tips',
                    onTap: () => _onTap(context, 'Safety Guidelines & Tips'),
                    backGroundcolor: GBColor.secondary,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(
                      color: GBColor.borderColor,
                      thickness: 1,
                      height: 1,
                    ),
                  ),
                  _safetyTile(
                    icon: SolarLinearIcons.phoneCalling,
                    title: 'Call Emergency services',
                    iconColor: Colors.red,
                    onTap: () => _onTap(context, 'Call Emergency services'),
                    backGroundcolor: GBColor.secondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}