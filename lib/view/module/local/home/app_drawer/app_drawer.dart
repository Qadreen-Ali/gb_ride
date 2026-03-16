import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  int _selectedIndex = -1;
  String _userName = 'Profile';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    try {
      final authId = Supabase.instance.client.auth.currentUser?.id ?? '';
      if (authId.isEmpty) return;
      final res = await Supabase.instance.client
          .from('locals')
          .select('full_name')
          .eq('auth_id', authId)
          .maybeSingle();
      if (res != null && mounted) {
        setState(() => _userName = res['full_name'] ?? 'Profile');
      }
    } catch (_) {}
  }

  void _onSelect(int index, VoidCallback action) {
    setState(() => _selectedIndex = index);
    action();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: GBColor.secondary,
      width: 255,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header with profile info
            Container(
              padding: const EdgeInsets.only(
                top: 55,
                left: 16,
                right: 16,
                bottom: 10,
              ),
              child: Row(
                children: [
                  // Profile avatar
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: GBColor.primary,
                    child: Text(
                      _userName.isNotEmpty ? _userName[0].toUpperCase() : 'P',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: const Expanded(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),

            // Menu items
            Expanded(
              child: ListView(
                children: [
                  DrawerMenuItem(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    isSelected: _selectedIndex == 0,
                    onTap: () => _onSelect(0, () {
                      Navigator.pop(context);
                      // Navigate to home
                    }),
                  ),

                  DrawerMenuItem(
                    image: Image.asset(GBImagePath.safety, fit: BoxFit.contain),
                    label: 'Safety',
                    imageColor: Colors.black,
                    isSelected: _selectedIndex == 1,
                    onTap: () => _onSelect(1, () {
                      Navigator.pushNamed(context, '/safety');
                    }),
                  ),

                  DrawerMenuItem(
                    icon: Icons.settings_sharp,
                    label: 'Setting',
                    isSelected: _selectedIndex == 2,
                    onTap: () => _onSelect(2, () {
                      Navigator.pushNamed(context, '/settings');
                    }),
                  ),

                  DrawerMenuItem(
                    icon: Icons.help_outline,
                    label: 'Help',
                    imageColor: Colors.black,
                    isSelected: _selectedIndex == 3,
                    onTap: () => _onSelect(3, () {
                      Navigator.pushNamed(context, '/help');
                    }),
                  ),
                ],
              ),
            ),

            // History
            InkWell(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen(),));
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/history');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      border: Border.all(color: GBColor.borderColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.history),
                          SizedBox(width: 12),
                          Text(
                            "History",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Social Icons
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.facebook, color: Colors.blue, size: 30),
                  const SizedBox(width: 15),
                  Image(
                    image: AssetImage(GBImagePath.google),
                    width: 25,
                    height: 25,
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

class DrawerMenuItem extends StatelessWidget {
  final IconData? icon;
  final Image? image;
  final Color? imageColor;
  final Color? selectedImageColor;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawerMenuItem({
    super.key,
    this.icon,
    this.image,
    required this.label,
    this.isSelected = false,
    required this.onTap,
    this.imageColor,
    this.selectedImageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? GBColor.primary : GBColor.secondary,
      ),
      child: ListTile(
        leading: _buildIcon(),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? GBColor.secondary : Colors.black,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildIcon() {
    if (image != null) {
      return SizedBox(
        width: 24,
        height: 24,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            isSelected
                ? (selectedImageColor ?? GBColor.secondary)
                : (imageColor ?? Colors.black),
            BlendMode.srcIn,
          ),
          child: FittedBox(fit: BoxFit.contain, child: image!),
        ),
      );
    } else if (icon != null) {
      return Icon(
        icon,
        color: isSelected ? GBColor.secondary : Colors.black,
        size: 24,
      );
    } else {
      return const SizedBox(width: 24);
    }
  }
}
