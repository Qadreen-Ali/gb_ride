import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/custom_app-bar.dart';

class DriverTripsScreen extends StatelessWidget {
  const DriverTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GBColor.secondary,
      appBar: const CustomAppBar(title: "Driver Trips"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _tabBar(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _sectionTitle("Today"),
                  _tripCard(),
                  const SizedBox(height: 16),
                  _sectionTitle("Yesterday"),
                  _tripCard(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: GBColor.secondary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _tabItem("All", true),
          _tabItem("Upcoming", false),
          _tabItem("Canceled", false),
        ],
      ),
    );
  }

  Widget _tabItem(String title, bool selected) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? GBColor.secondary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: selected
              ? Border.all(color: GBColor.primary)
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? GBColor.primary : GBColor.gray,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: GBColor.textFieldText,
          ),
        ),
      ),
    );
  }

  Widget _tripCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GBColor.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GBColor.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topRow(),
          const SizedBox(height: 12),

          // Custom location row with vertical indicators
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
                  children: const [
                    // First location
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Khomar Gilgit",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Khomar XYZ Gilgit", 
                          style: TextStyle(
                            fontSize: 10,
                            color: GBColor.gray,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 26),

                    // Second location
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "KIU Gilgit",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "KIU  XYZ Gilgit", 
                          style: TextStyle(
                            fontSize: 10,
                            color: GBColor.gray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: GBColor.linegrey, thickness: 1, height: 16), // Divider 
          _driverRow(),
        ],
      ),
    );
  }

  Widget _topRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Time + Price Column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "10:45 AM",
              style: TextStyle(
                fontSize: 14,
                color: GBColor.textFieldText,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "PKR 850", 
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.w500,
                color: GBColor.black,
              ),
            ),
          ],
        ),

        // Status Container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: GBColor.green.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Completed",
            style: TextStyle(
              color: GBColor.green,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _driverRow() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage("assets/driver.png"),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Muzafar D", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 14),
                SizedBox(width: 4),
                Text("4.9", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: GBColor.containerGrayColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Details",
            style: TextStyle(
              color: GBColor.gray,
              fontSize: 12,
            ),
          ),
        ),
      ],
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
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        if (showLine)
          Container(
            height: 42,
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
