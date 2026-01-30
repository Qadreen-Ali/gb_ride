import 'package:flutter/material.dart';
import '../../../../../../utils/constants/color_string.dart';

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