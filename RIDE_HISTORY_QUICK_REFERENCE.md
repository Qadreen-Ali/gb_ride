# RIDE HISTORY SERVICE - QUICK REFERENCE

## Quick Setup

```dart
import 'package:gb_ride/services/ride_history_service.dart';
import 'package:gb_ride/services/supabase_service.dart';

// Initialize
final supabaseService = SupabaseService();
final rideHistoryService = RideHistoryService(supabaseService);
final userId = supabaseService.getCurrentUserId() ?? '';
```

---

## Common Operations

### Get All Rides (Rider)
```dart
final rides = await rideHistoryService.getRiderRideHistory(userId);
for (var ride in rides) {
  print('${ride.rideStatus} - PKR ${ride.finalFare}');
}
```

### Get All Rides (Driver)
```dart
final rides = await rideHistoryService.getDriverRideHistory(driverId);
```

### Get Single Ride
```dart
final ride = await rideHistoryService.getRideHistoryById(rideId);
print(ride?.pickupLocation['address']);
```

### Filter by Date
```dart
final lastMonth = DateTime.now().subtract(Duration(days: 30));
final rides = await rideHistoryService.getRideHistoryFiltered(
  userId: userId,
  userType: 'rider',
  startDate: lastMonth,
);
```

### Filter by Status
```dart
final rides = await rideHistoryService.getRideHistoryFiltered(
  userId: userId,
  userType: 'rider',
  rideStatus: 'completed',
  limit: 20,
);
```

---

## Ratings

### Driver Rates Rider
```dart
await rideHistoryService.updateRiderRating(
  rideHistoryId: rideId,
  rating: 5,
  comment: 'Great passenger!',
);
```

### Rider Rates Driver
```dart
await rideHistoryService.updateDriverRating(
  rideHistoryId: rideId,
  rating: 4,
  comment: 'Good ride',
);
```

### Get Ratings
```dart
final driverAvgRating = await rideHistoryService.getDriverAverageRating(driverId);
final riderAvgRating = await rideHistoryService.getRiderAverageRating(riderId);

print('Driver: $driverAvgRating ⭐');
print('Rider: $riderAvgRating ⭐');
```

---

## Payment

### Mark Payment Complete
```dart
await rideHistoryService.updatePaymentStatus(
  rideHistoryId: rideId,
  isComplete: true,
  finalFare: 350.00,
);
```

### Get Total Revenue (Driver)
```dart
final earned = await rideHistoryService.getTotalRevenue(
  driverId,
  userType: 'driver',
);
print('Total earned: PKR $earned');
```

### Get Total Spent (Rider)
```dart
final spent = await rideHistoryService.getTotalRevenue(
  userId,
  userType: 'rider',
);
print('Total spent: PKR $spent');
```

---

## Statistics

### Driver Stats
```dart
final count = await rideHistoryService.getTotalRidesCount(driverId, userType: 'driver');
final rating = await rideHistoryService.getDriverAverageRating(driverId);
final revenue = await rideHistoryService.getTotalRevenue(driverId, userType: 'driver');

print('Rides: $count');
print('Rating: $rating ⭐');
print('Revenue: PKR $revenue');
```

### Rider Stats
```dart
final count = await rideHistoryService.getTotalRidesCount(userId, userType: 'rider');
final rating = await rideHistoryService.getRiderAverageRating(userId);
final spent = await rideHistoryService.getTotalRevenue(userId, userType: 'rider');

print('Rides: $count');
print('Rating: $rating ⭐');
print('Spent: PKR $spent');
```

---

## In Widgets

### FutureBuilder (History List)
```dart
FutureBuilder<List<RideHistoryModel>>(
  future: rideHistoryService.getRiderRideHistory(userId),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    final rides = snapshot.data ?? [];
    return ListView.builder(
      itemCount: rides.length,
      itemBuilder: (context, index) {
        final ride = rides[index];
        return ListTile(
          title: Text('${ride.pickupLocation['address']}'),
          subtitle: Text('PKR ${ride.finalFare}'),
        );
      },
    );
  },
)
```

### Error Handling
```dart
try {
  final rides = await rideHistoryService.getRiderRideHistory(userId);
  setState(() {
    _rides = rides;
  });
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}
```

---

## Data Model Fields

```dart
RideHistoryModel {
  id,                          // UUID
  riderId,                     // UUID
  driverId,                    // UUID
  pickupLocation,              // {lat, lng, address}
  destinationLocation,         // {lat, lng, address}
  vehicleType,                 // 'bike', 'car', 'auto'
  distanceKm,                  // double
  estimatedMinutes,            // int
  offeredFare,                 // double
  acceptedFare,                // double
  finalFare,                   // double
  paymentMethod,               // 'cash', 'card', 'wallet'
  rideStatus,                  // 'completed', 'cancelled'
  startTime,                   // DateTime
  endTime,                     // DateTime
  riderRating,                 // int (1-5)
  riderComment,                // String
  driverRating,                // int (1-5)
  driverComment,               // String
  isPaymentComplete,           // bool
  cancellationReason,          // String
  createdAt,                   // DateTime
  updatedAt,                   // DateTime
}
```

---

## Complete Example (History Screen)

```dart
class HistoryScreen extends StatefulWidget {
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late RideHistoryService _service;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _service = RideHistoryService(SupabaseService());
    _userId = SupabaseService().getCurrentUserId() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ride History')),
      body: FutureBuilder<List<RideHistoryModel>>(
        future: _service.getRiderRideHistory(_userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final rides = snapshot.data ?? [];
          if (rides.isEmpty) {
            return Center(child: Text('No rides yet'));
          }
          return ListView.builder(
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              return RideHistoryTile(
                ride: ride,
                onTap: () => _showRideDetails(ride),
              );
            },
          );
        },
      ),
    );
  }

  void _showRideDetails(RideHistoryModel ride) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ride Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('From: ${ride.pickupLocation['address']}'),
            Text('To: ${ride.destinationLocation['address']}'),
            Text('Distance: ${ride.distanceKm} km'),
            Text('Fare: PKR ${ride.finalFare}'),
            Text('Status: ${ride.rideStatus}'),
            if (ride.driverRating != null)
              Text('Driver Rating: ${ride.driverRating}/5'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
```

---

## Tips & Best Practices

1. **Cache Results**: Store rides in state to avoid repeated queries
2. **Pagination**: Use `limit` parameter for large datasets
3. **Error Handling**: Always wrap with try-catch
4. **Loading States**: Show spinner during `FutureBuilder`
5. **Filter Early**: Use `getRideHistoryFiltered()` for specific needs
6. **Async/Await**: Use async methods properly in async functions

---

## Method Reference

| Method | Parameters | Returns | Use Case |
|--------|-----------|---------|----------|
| `getRiderRideHistory(userId)` | riderId | `List<RideHistoryModel>` | Rider's all rides |
| `getDriverRideHistory(driverId)` | driverId | `List<RideHistoryModel>` | Driver's all rides |
| `getRideHistoryById(rideId)` | rideId | `RideHistoryModel?` | Single ride |
| `getRideHistoryFiltered(...)` | userId, userType, status, dates | `List<RideHistoryModel>` | Custom queries |
| `updateRiderRating(...)` | rideId, rating, comment | `void` | Driver rates rider |
| `updateDriverRating(...)` | rideId, rating, comment | `void` | Rider rates driver |
| `updatePaymentStatus(...)` | rideId, isComplete, fare | `void` | Payment tracking |
| `getTotalRidesCount(userId)` | userId, userType | `int` | Ride count |
| `getDriverAverageRating(driverId)` | driverId | `double` | Driver rating |
| `getRiderAverageRating(riderId)` | riderId | `double` | Rider rating |
| `getTotalRevenue(userId)` | userId, userType | `double` | Revenue/spending |

---

**Quick Start**: Copy the "Complete Example" above and customize!
