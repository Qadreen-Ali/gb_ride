//  import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
//
// class MapMarkers extends StatelessWidget {
//   final LatLng currentLocation;
//   final LatLng? pickupLocation;
//   final LatLng? destinationLocation;
//
//   const MapMarkers({
//     super.key,
//     required this.currentLocation,
//     this.pickupLocation,
//     this.destinationLocation,
//   });
//
//   /// Logic to check if points are virtually identical (within ~1 meter)
//   bool _isOverlap(LatLng p1, LatLng? p2) {
//     if (p2 == null) return false;
//     return p1.latitude.toStringAsFixed(5) == p2.latitude.toStringAsFixed(5) &&
//         p1.longitude.toStringAsFixed(5) == p2.longitude.toStringAsFixed(5);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Determine visibility based on overlaps
//     final bool hideUserDot =
//         _isOverlap(currentLocation, pickupLocation) ||
//         _isOverlap(currentLocation, destinationLocation);
//
//     final bool hideDestination =
//         destinationLocation != null &&
//         _isOverlap(destinationLocation!, pickupLocation);
//
//     return MarkerLayer(
//       markers: [
//         /// 🟡 Live User Location (Yellow)
//         if (!hideUserDot)
//           Marker(
//             point: currentLocation,
//             width: 22,
//             height: 22,
//             alignment: Alignment.center,
//             child: const _SimpleCircleMarker(
//               color: Colors.yellow,
//               isUser: true,
//             ),
//           ),
//
//         /// 🔵 Pickup Location (Blue)
//         if (pickupLocation != null)
//           Marker(
//             point: pickupLocation!,
//             width: 26,
//             height: 26,
//             alignment: Alignment.center,
//             child: const _SimpleCircleMarker(color: Colors.blue),
//           ),
//
//         /// 🔴 Destination Location (Red)
//         if (destinationLocation != null && !hideDestination)
//           Marker(
//             point: destinationLocation!,
//             width: 26,
//             height: 26,
//             alignment: Alignment.center,
//             child: const _SimpleCircleMarker(color: Colors.red),
//           ),
//       ],
//     );
//   }
// }
//
// class _SimpleCircleMarker extends StatelessWidget {
//   final Color color;
//   final bool isUser;
//
//   const _SimpleCircleMarker({required this.color, this.isUser = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: color,
//         shape: BoxShape.circle,
//         border: Border.all(color: Colors.white, width: 3),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withAlpha(isUser ? 40 : 80),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Container(
//           width: 6,
//           height: 6,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//           ),
//         ),
//       ),
//     );
//   }
// }
