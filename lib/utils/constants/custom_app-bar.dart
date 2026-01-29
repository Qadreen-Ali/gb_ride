import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;
  final bool showLeading;
  final Widget? leading;
  final List<Widget>? actions;
  final Color background;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.showLeading = true,
    this.actions,
    this.background = Colors.white,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: background,
      elevation: 0,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.white,
      leading:
          leading ??
          (showLeading
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  ),
                  onPressed: onBackTap ?? () => Navigator.pop(context),
                )
              : null),
      title: Text(
        title,
        style: const TextStyle(
          color: GBColor.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
      centerTitle: true,
      actions: actions ?? [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
