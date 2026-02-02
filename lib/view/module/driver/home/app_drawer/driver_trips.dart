import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/custom_app-bar.dart';
import 'package:gb_ride/services/supabase_service.dart';
import 'package:gb_ride/models/ride_adapter.dart';

class DriverTripsScreen extends StatefulWidget {
  const DriverTripsScreen({super.key});

  @override
  State<DriverTripsScreen> createState() => _DriverTripsScreenState();
}

class _DriverTripsScreenState extends State<DriverTripsScreen> {
  late Future<List<dynamic>> _tripsFuture;
  final SupabaseService _supabaseService = SupabaseService();
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  void _loadTrips() {
    final driverId = _supabaseService.getCurrentUserId();
    if (driverId != null) {
      _tripsFuture = _supabaseService.fetchRidesByDriver(driverId);
    } else {
      _tripsFuture = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GBColor.secondary,
      appBar: const CustomAppBar(title: "Driver Trips"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTabBar(),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _tripsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No trips found'));
                  }
                  final rides = snapshot.data!;
                  return ListView.builder(
                    itemCount: rides.length,
                    itemBuilder: (context, index) {
                      final ride = rides[index];
                      return _buildTripCard(ride);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: GBColor.secondary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildTabItem("All", 0),
          _buildTabItem("Completed", 1),
          _buildTabItem("Canceled", 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _selectedTab == index
                ? GBColor.secondary.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: _selectedTab == index
                ? Border.all(color: GBColor.primary)
                : null,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: _selectedTab == index ? GBColor.primary : GBColor.gray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripCard(dynamic ride) {
    final pickup = ride.pickupLocation ?? 'Pickup Location';
    final destination = ride.destinationLocation ?? 'Destination';
    final status = ride.status ?? 'pending';
    final fare = ride.acceptedFare ?? ride.offeredFare ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GBColor.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GBColor.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(status),
                ),
              ),
              Text(
                'Rs. $fare',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                children: [
                  _LocationIndicator(color: GBColor.primary, showLine: true),
                  SizedBox(height: 6),
                  _LocationIndicator(color: GBColor.green, showLine: false),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pickup.toString().split(',').first,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          destination.toString().split(',').first,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return GBColor.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return GBColor.primary;
    }
  }
}

/// 🔵 Ring icon + dotted vertical line
class _LocationIndicator extends StatelessWidget {
  final Color color;
  final bool showLine;

  const _LocationIndicator({required this.color, required this.showLine});

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
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        ),
        if (showLine)
          Container(
            height: 42,
            margin: const EdgeInsets.only(top: 2),
            child: CustomPaint(painter: _DottedLinePainter()),
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
