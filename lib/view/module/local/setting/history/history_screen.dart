import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/view/module/local/setting/history/ride_history_screen.dart';

import '../../../../../utils/constants/custom_app-bar.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: CustomAppBar(
       showLeading: false,
        title: 'History',
        actions: [Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:GBColor.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color:GBColor.secondary),
            ),
          ),
        ),],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only( bottom: 12),
        itemCount: 8,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          thickness: 1, 
          color: GBColor.linegrey, 
        ),
        itemBuilder: (context, index) {
          return _HistoryTile(
            date: '20 sep, 8:55 AM',
            pickupLocation: 'Sonikot Gilgit Baltistan',
            destinationLocation: 'Silicon Global Khomar',
            fare: 'PKR 130.00',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RideHistoryDetailScreen(
                    date: 'October 26, 2025, 10: 30 AM',
                    pickupLocation: 'Jutial Noor Plaza Gilgit',
                    destinationLocation: 'KIU main Road',
                    fare: '80.00PKR',
                    driverName: 'AbuHassan',
                    driverRating: '4.9',
                    vehicleModel: 'Blue Toyota\nSMz40',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class _HistoryTile extends StatelessWidget {
  final String date;
  final String pickupLocation;
  final String destinationLocation;
  final String fare;
  final VoidCallback onTap;

  const _HistoryTile({
    required this.date,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.fare,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.zero, 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// DATE
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// LOCATION TIMELINE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        children: [
                          _LocationIndicator(
                            color: GBColor.primary,
                            showLine: true,
                          ),
                          SizedBox(height: 6),
                          _LocationIndicator(
                            color: GBColor.green,
                            showLine: false,
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pickupLocation,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 26),
                            Text(
                              destinationLocation,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// FARE
            Text(
              fare,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔵 Ring icon + dotted vertical line
class _LocationIndicator extends StatelessWidget {
  final Color color;
  final bool showLine;

  const _LocationIndicator({
    required this.color,
    required this.showLine,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        if (showLine)
          Container(
            height: 20,
            margin: const EdgeInsets.only(top: 2),
            child: CustomPaint(
              painter: _DottedLinePainter(),
            ),
          ),
      ],
    );
  }
}

/// 🔹 Dotted vertical line painter
class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = GBColor.lightBlue
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    double startY = 0;
    const dashHeight = 4;
    const dashSpace = 4;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
