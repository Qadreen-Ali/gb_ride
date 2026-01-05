import 'package:flutter/material.dart';
// TODO: Add these imports based on your data source:
// import 'package:http/http.dart' as http;  // For API calls
// import 'dart:convert';  // For JSON parsing

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); 
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ============================================================================
  // DATA FETCHING METHODS - Replace these with your actual API/Database calls
  // ============================================================================

  /// Fetch ongoing bookings from your backend
  Future<List<Map<String, dynamic>>> _fetchOngoingBookings() async {
    // TODO: Replace with your actual API call
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    return [
      {
        'id': '1',
        'pickup': 'Nasr Plaza Jutial Gilgit',
        'destination': 'KIU Road',
        'date': 'Today 07:30 AM',
        'driver': 'Hassan',
        'vehicle': 'Blue Alto, Skz4u',
        'driverImage': null, // Add actual image URL/asset
        'fare': 'PKR 80',
        'status': 'Ongoing',
        'hasMap': true,
        'isArriving': true,
      },
    ];
  }

  /// Fetch completed bookings from your backend
  Future<List<Map<String, dynamic>>> _fetchCompletedBookings() async {
    // TODO: Replace with your actual API call
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      {
        'id': '2',
        'pickup': 'Noori Plaza Jutial Gilgit',
        'destination': 'KIU Road123',
        'date': 'Yesterday 10:30 AM',
        'driver': 'Hassan',
        'vehicle': 'Blue Alto, Skz4u',
        'driverImage': null,
        'fare': 'PKR 80',
        'status': 'Completed',
        'hasMap': false,
        'isArriving': false,
      },
    ];
  }

  /// Fetch cancelled bookings from your backend
  Future<List<Map<String, dynamic>>> _fetchCancelledBookings() async {
    // TODO: Replace with your actual API call
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      {
        'id': '3',
        'pickup': 'Emaen, Noori Plaza Jutial Gilgit',
        'destination': '',
        'date': 'Yesterday 10:30 AM',
        'driver': '',
        'vehicle': '',
        'driverImage': null,
        'fare': 'PKR 80',
        'status': 'Cancelled',
        'hasMap': false,
        'isArriving': false,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bookings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Status Filter Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(child: _buildTab('Ongoing', 0)),
                const SizedBox(width: 8),
                Expanded(child: _buildTab('Completed', 1)),
                const SizedBox(width: 8),
                Expanded(child: _buildTab('Cancelled', 2)),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList(_fetchOngoingBookings(), 'ongoing'),
                _buildBookingList(_fetchCompletedBookings(), 'completed'),
                _buildBookingList(_fetchCancelledBookings(), 'cancelled'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _tabController.index == index;
    
    Color backgroundColor;
    Color textColor;
    
    if (isSelected) {
      switch (title) {
        case 'Ongoing':
          backgroundColor = const Color(0xFF00C853).withOpacity(0.1);
          textColor = const Color(0xFF00C853);
          break;
        case 'Completed':
          backgroundColor = Colors.grey[200]!;
          textColor = Colors.black87;
          break;
        case 'Cancelled':
          backgroundColor = const Color(0xFFE53935).withOpacity(0.1);
          textColor = const Color(0xFFE53935);
          break;
        default:
          backgroundColor = Colors.grey[200]!;
          textColor = Colors.black87;
      }
    } else {
      backgroundColor = Colors.grey[100]!;
      textColor = Colors.grey[600]!;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _tabController.animateTo(index);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(
                  color: textColor.withOpacity(0.3),
                  width: 1,
                )
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingList(Future<List<Map<String, dynamic>>> future, String type) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: future,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading bookings',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty state
        final bookings = snapshot.data ?? [];
        if (bookings.isEmpty) {
          return _buildEmptyState('No $type bookings');
        }

        // Success - Show bookings
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            return _buildBookingCard(bookings[index]);
          },
        );
      },
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = booking['status'] as String;
    final isOngoing = status == 'Ongoing';
    final isCompleted = status == 'Completed';
    final isCancelled = status == 'Cancelled';
    final hasDriver = (booking['driver'] as String).isNotEmpty;
    
    Color statusColor;
    if (isOngoing) {
      statusColor = const Color(0xFF00C853);
    } else if (isCompleted) {
      statusColor = const Color(0xFF00C853);
    } else {
      statusColor = const Color(0xFFE53935);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map preview (for ongoing bookings)
          if (booking['hasMap'] == true) _buildMapPreview(booking['fare']),

          // Booking details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status and date row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusBadge(status, statusColor),
                    if (booking['isArriving'] == true)
                      _buildArrivingBadge()
                    else
                      Text(
                        booking['fare'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  booking['date'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),

                // Route information
                _buildRouteInfo(booking),

                // Driver information (not for cancelled bookings)
                if (hasDriver) ...[
                  const SizedBox(height: 16),
                  _buildDriverInfo(booking),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview(String fare) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          // Placeholder - Replace with actual map widget
          Center(
            child: Text(
              '300 x 80',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
            ),
          ),
          // Price badge
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                fare,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrivingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.directions_car, size: 14, color: Colors.orange),
          SizedBox(width: 4),
          Text(
            'Arriving',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo(Map<String, dynamic> booking) {
    final hasDestination = (booking['destination'] as String).isNotEmpty;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            if (hasDestination) ...[
              Container(
                width: 2,
                height: 30,
                color: Colors.grey[300],
              ),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking['pickup'],
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (hasDestination) ...[
                const SizedBox(height: 28),
                Text(
                  booking['destination'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfo(Map<String, dynamic> booking) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Driver image
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: Colors.grey[600],
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          
          // Driver details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking['driver'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  booking['vehicle'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // View details button
          InkWell(
            onTap: () => _viewBookingDetails(booking),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.visibility_outlined, size: 16, color: Colors.black87),
                  SizedBox(width: 4),
                  Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your ${message.toLowerCase()} will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  void _viewBookingDetails(Map<String, dynamic> booking) {
    // TODO: Navigate to booking details screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('ID', booking['id']),
              _buildDetailRow('Status', booking['status']),
              _buildDetailRow('Date', booking['date']),
              _buildDetailRow('From', booking['pickup']),
              if ((booking['destination'] as String).isNotEmpty)
                _buildDetailRow('To', booking['destination']),
              if ((booking['driver'] as String).isNotEmpty)
                _buildDetailRow('Driver', booking['driver']),
              if ((booking['vehicle'] as String).isNotEmpty)
                _buildDetailRow('Vehicle', booking['vehicle']),
              _buildDetailRow('Fare', booking['fare']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}