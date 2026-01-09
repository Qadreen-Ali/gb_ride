import 'package:flutter/material.dart';
class LocationWidget extends StatelessWidget {
  final String location;
  final Color iconColor;
  final IconData icon;
  const LocationWidget({
    super.key,
    required this.location, required this.icon, required this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(  icon,color: iconColor,size: 24,),
        SizedBox(width: 16,),
        Text(location, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),),
      ],
    );
  }
}