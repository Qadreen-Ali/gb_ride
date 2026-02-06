import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/services/rider_service.dart';
import 'package:gb_ride/services/supabase_service.dart';
import 'package:gb_ride/models/ride_model.dart';
import 'package:gb_ride/view/module/local/setting/history/ride_history_screen.dart';
import '../../../../../utils/constants/custom_app-bar.dart';

class HistoryScreen extends StatefulWidget {
  final String riderId; // Receive from login/home

  const HistoryScreen({super.key, required this.riderId});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late RiderService _riderService;
  late SupabaseService _supabaseService;

  @override
  void initState() {
    super.initState();
    _supabaseService = SupabaseService();
    _riderService = RiderService(_supabaseService);
  }

  @override
  Widget build(BuildContext context) {
    final riderId = widget.riderId;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: CustomAppBar(
        showLeading: false,
        title: 'History',
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: GBColor.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: GBColor.secondary),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<RideModel>>(
        future: _riderService.getRideHistory(riderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: GBColor.primary),
            );
          }

          if (snapshot.hasError) return _errorState();

          final rides = snapshot.data ?? [];

          if (rides.isEmpty) return _emptyState();

          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 12),
            itemCount: rides.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              thickness: 1,
              color: GBColor.linegrey,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final ride = rides[index];
              return _HistoryTile(
                ride: ride,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RideHistoryScreen(riderId: riderId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  /// ================= STATES =================

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No rides yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your completed rides will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _errorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Failed to load ride history',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() {}),
            style:
                ElevatedButton.styleFrom(backgroundColor: GBColor.primary),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/// ================= TILE =================

class _HistoryTile extends StatelessWidget {
  final RideModel ride;
  final VoidCallback onTap;

  const _HistoryTile({
    required this.ride,
    required this.onTap,
  });

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown date';
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]}, '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getAddress(Map<String, dynamic>? location) {
    return location?['address']?.toString() ?? 'Unknown location';
  }

  @override
  Widget build(BuildContext context) {
    final pickup = _getAddress(
      ride.pickupLocation is String ? null : ride.pickupLocation,
    );
    final destination = _getAddress(
      ride.destinationLocation is String ? null : ride.destinationLocation,
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEFT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(ride.createdAt),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    pickup,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    destination,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            /// RIGHT
            Text(
              'PKR ${ride.acceptedFare?.toStringAsFixed(2) ?? '0.00'}',
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