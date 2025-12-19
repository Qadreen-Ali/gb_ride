import 'package:flutter/material.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header with profile info
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 16,
                right: 16,
                bottom: 20,
              ),
              child: Row(
                children: [
                  // Profile avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.pink.shade300, Colors.orange.shade300],
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Profile text
                  const Expanded(
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // Close button
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _DrawerMenuItem(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    isSelected: true,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to home
                    },
                  ),
                  _DrawerMenuItem(
                    icon: Icons.pedal_bike_outlined,
                    label: 'Ride',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to ride
                    },
                  ),
                  _DrawerMenuItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Bookings',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to bookings
                    },
                  ),
                  _DrawerMenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to notifications
                    },
                  ),
                  _DrawerMenuItem(
                    icon: Icons.shield_outlined,
                    label: 'Safety',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to safety
                    },
                  ),
                  _DrawerMenuItem(
                    icon: Icons.settings_outlined,
                    label: 'Setting',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to settings
                    },
                  ),
                  _DrawerMenuItem(
                    icon: Icons.help_outline,
                    label: 'Help',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to help
                    },
                  ),
                  _DrawerMenuItem(
                    icon: Icons.headset_mic_outlined,
                    label: 'Support',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to support
                    },
                  ),
                  _DrawerMenuItem(
                    icon: Icons.history_outlined,
                    label: 'History',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to history
                    },
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

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue.shade700 : Colors.black87,
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.blue.shade700 : Colors.black87,
          ),
        ),
       // trailing: badge != null
         //   ? Container(
           //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
             //   decoration: BoxDecoration(
               //   color: Colors.red,
        //          borderRadius: BorderRadius.circular(10),
          //      ),
            //    child: Text(
              //    badge!,
                //  style: const TextStyle(
                  //  color: Colors.white,
                    //fontSize: 12,
                 //   fontWeight: FontWeight.w600,
                //  ),
                //),
             // )
          //  : null,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
