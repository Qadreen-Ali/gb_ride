import 'package:flutter/material.dart';

class GlobalBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTap;

  const GlobalBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          // color: Colors.orange,
          width: 432,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFEB8E00),
            borderRadius: const BorderRadius.all(Radius.circular(44)),
            border: const Border(top: BorderSide(width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BottomItem(
                icon: Icons.home_outlined,
                label: "Home",
                isSelected: selectedIndex == 0,
                onTap: () => onItemTap(0),
              ),
              _BottomItem(
                icon: Icons.route_outlined,
                label: "Ride",
                isSelected: selectedIndex == 1,
                onTap: () => onItemTap(1),
              ),
              _BottomItem(
                icon: Icons.bookmark_add_outlined,
                label: "Bookings",
                isSelected: selectedIndex == 2,
                onTap: () => onItemTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void show(
    BuildContext context, {
    required String message,
    required IconData icon1,
    required IconData icon2,
    required IconData icon3,
  }) {}
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: isSelected ? Colors.white : Colors.black),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}