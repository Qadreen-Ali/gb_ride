import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

import '../../../../../utils/constants/custom_app_bar.dart';
import '../../../../../utils/constants/image_string.dart';

class RideHistoryDetailScreen extends StatelessWidget {
  final String date;
  final String pickupLocation;
  final String destinationLocation;
  final String fare;
  final String driverName;
  final String driverRating;
  final String vehicleModel;

  const RideHistoryDetailScreen({
    super.key,
    required this.date,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.fare,
    this.driverName = 'AbuHassan',
    this.driverRating = '4.9',
    this.vehicleModel = 'Blue Toyota SMz40',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: CustomAppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: GBColor.primary,
                shape: BoxShape.circle,
                image: DecorationImage(image:  AssetImage(GBImagePath.profile))
            ),
          ),
        ),
        title: 'Ride details',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// MAP
            _mapSection(),

            /// LOCATION + DATE (SAME CONTAINER)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  LocationTimeline(
                    pickup: pickupLocation,
                    destination: destinationLocation,
                  ),

                  const SizedBox(height: 14),
                  Divider(color: GBColor.linegrey, thickness: 1),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 10),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                       const SizedBox(width: 6),
                       const Spacer(),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          size: 20,
                          color: Colors.black,
                        ),

                    ],
                    
                  ),
                 
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// FARE BREAKDOWN
            _fareCard(),

            const SizedBox(height: 16),

            /// DRIVER INFO
            _driverCard(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// ================= MAP =================
  Widget _mapSection() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(35.9249, 74.3080),
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.gb_ride',
            ),
          ],
        ),
      ),
    );
  }


  /// ================= FARE =================
  Widget _fareCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Fare Breakdown',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _fareRow('Base Fare', '50 PKR'),
          _fareRow('Tip', '20 PKR'),
          _fareRow('Time', '15 Minutes'),
          _fareRow('Distance', '5 KM'),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Fare',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(fare,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= DRIVER =================
  Widget _driverCard() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.all(16),
    decoration: _cardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// DRIVER INFO ROW
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// DRIVER IMAGE
            const CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('assets/icons/profile.jpg'),
            ),
            const SizedBox(width: 12),

            /// DRIVER NAME + RATING
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driverName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        driverRating,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        /// VEHICLE INFO 
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56, // radius*2 = avatar diameter
              height: 56,
              decoration: BoxDecoration(
                color: GBColor.lightGray,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_car,
                size: 32, 
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),

            /// Vehicle text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Blue Toyota',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'SMz4U',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

  /// ================= HELPERS =================
  static BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static Widget _fareRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  TextStyle(fontSize: 14, color: Colors.grey.shade700)),
          Text(value,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

/// ================= LOCATION TIMELINE =================

class LocationTimeline extends StatelessWidget {
  final String pickup;
  final String destination;

  const LocationTimeline({
    super.key,
    required this.pickup,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: const [
            _TimelineIcon(
              icon: Icons.my_location,
              color: GBColor.black,
              showLine: true,
            ),
            SizedBox(height: 8),
            _TimelineIcon(
              icon: Icons.location_on,
              color: GBColor.black,
              showLine: false,
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pickup',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(pickup,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 36),
              const Text('Destination',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(destination,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}

/// ================= ICON + DOTTED LINE =================

class _TimelineIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool showLine;

  const _TimelineIcon({
    required this.icon,
    required this.color,
    required this.showLine,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: GBColor.lightGray, // grey background ✔
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        if (showLine)
          Container(
            height: 32, 
            margin: const EdgeInsets.only(top: 4),
            child: CustomPaint(painter: _DottedLinePainter()),
          ),
      ],
    );
  }
}

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
