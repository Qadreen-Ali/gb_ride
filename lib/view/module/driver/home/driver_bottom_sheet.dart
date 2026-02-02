import 'package:flutter/material.dart';
import 'package:gb_ride/view/module/driver/home/widgets/offer_fare_card.dart';
import 'package:gb_ride/models/ride_ui_model.dart';
import 'package:gb_ride/services/supabase_service.dart';
import 'package:gb_ride/models/ride_adapter.dart';

class DriverBottomSheet extends StatefulWidget {
  final SupabaseService supabaseService;
  final VoidCallback? onOfferTap;
  final VoidCallback? onOfferClose;

  const DriverBottomSheet({
    super.key,
    required this.supabaseService,
    this.onOfferTap,
    this.onOfferClose,
  });

  @override
  State<DriverBottomSheet> createState() => _DriverBottomSheetState();
}

class _DriverBottomSheetState extends State<DriverBottomSheet> {
  late Future<List<RideUiModel>> _pendingRidesFuture;

  @override
  void initState() {
    super.initState();
    _loadPendingRides();
  }

  void _loadPendingRides() {
    setState(() {
      _pendingRidesFuture = _fetchAllRides();
    });
  }

  Future<List<RideUiModel>> _fetchAllRides() async {
    try {
      debugPrint('🔍 Fetching ALL pending rides from database...');
      
      // Fetch ALL pending rides regardless of vehicle type
      final rides = await widget.supabaseService.fetchAllRides();
      
      debugPrint('✅ Found ${rides.length}  rides in database');
      
      if (rides.isEmpty) {
        debugPrint('ℹ️ No pending rides in the database');
        return [];
      }

      // Convert to UI models
      final uiModels = rides.map((ride) {
        final uiModel = RideAdapter.toUiModel(ride);
        debugPrint('📍 Ride: ${uiModel.pickupLocation} → ${uiModel.destinationLocation} (${uiModel.formattedFare})');
        return uiModel;
      }).toList();
      
      debugPrint('🎉 Successfully loaded ${uiModels.length} rides');
      return uiModels;
      
    } catch (e, stackTrace) {
      debugPrint('❌ ERROR fetching rides: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Available Rides',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadPendingRides,
                  tooltip: 'Refresh',
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: FutureBuilder<List<RideUiModel>>(
              future: _pendingRidesFuture,
              builder: (context, snapshot) {
                // Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Error
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Error Loading Rides',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadPendingRides,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Empty
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No rides available',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Check back later',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // Success - Display rides
                final rides = snapshot.data!;
                return RefreshIndicator(
                  onRefresh: () async {
                    _loadPendingRides();
                    await _pendingRidesFuture;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: rides.length,
                    itemBuilder: (context, index) {
                      return OfferFareCard(
                        rideModel: rides[index],
                        onOfferTap: widget.onOfferTap,
                        onOfferClose: widget.onOfferClose,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}