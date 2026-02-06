import 'package:flutter/material.dart';
import 'package:gb_ride/models/ride_history_model.dart';
import 'package:gb_ride/services/ride_history_service.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import '../../../../../utils/constants/custom_app-bar.dart';

class RideHistoryScreen extends StatefulWidget {
  final String riderId;

  const RideHistoryScreen({
    super.key,
    required this.riderId,
  });

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  final RideHistoryService _service = RideHistoryService();
  late Future<List<RideHistoryModel>> _ridesFuture;

  @override
  void initState() {
    super.initState();
    _ridesFuture = _service.getRideHistoryForRider(widget.riderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const CustomAppBar(title: 'Ride History'),
      body: FutureBuilder<List<RideHistoryModel>>(
        future: _ridesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: GBColor.primary),
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          final rides = snapshot.data ?? [];

          if (rides.isEmpty) {
            return const Center(child: Text('No ride history found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];

              final pickup =
                  (ride.pickupLocation['address'] ?? 'Pickup location')
                      .toString();
              final destination =
                  (ride.destinationLocation['address'] ?? 'Destination location')
                      .toString();

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// STATUS + DATE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ride.rideStatus.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ride.rideStatus == 'completed'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        Text(
                          _formatDate(ride.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// LOCATIONS
                    Text(
                      pickup,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Icon(Icons.arrow_downward, size: 16),
                    ),
                    Text(
                      destination,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),

                    const Divider(height: 20),

                    /// FARE + PAYMENT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PKR ${(ride.finalFare ?? ride.acceptedFare).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ride.paymentMethod.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// ================= HELPERS =================

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );
}
