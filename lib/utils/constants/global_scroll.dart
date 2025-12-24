// import 'package:flutter/material.dart';

// /// Global reusable scroll wrapper
// class GlobalScroll extends StatelessWidget {
//   /// List of widgets to display inside the scroll
//   final List<Widget> children;

//   /// Optional padding around the scroll content
//   final EdgeInsetsGeometry padding;

//   /// Optional scroll physics
//   final ScrollPhysics physics;

//   const GlobalScroll({
//     super.key,
//     required this.children,
//     this.padding = const EdgeInsets.all(16),
//     this.physics = const BouncingScrollPhysics(),
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: padding,
//       physics: physics,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: children,
//       ),
//     );
//   }
// }
