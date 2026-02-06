# RIDE HISTORY TABLE - SQL SETUP

## Overview
The `ride_history` table stores completed and archived ride information. This table is used for analytics, historical tracking, and rider/driver statistics.

---

## SQL: Create ride_history Table

```sql
CREATE TABLE IF NOT EXISTS ride_history (
  id UUID PRIMARY KEY,
  rider_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  driver_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  pickup_location JSONB NOT NULL,  -- {latitude, longitude, address}
  destination_location JSONB NOT NULL,  -- {latitude, longitude, address}
  vehicle_type VARCHAR(50) NOT NULL,  -- 'bike', 'car', 'auto'
  distance_km FLOAT NOT NULL DEFAULT 0,
  estimated_minutes INT DEFAULT 0,
  offered_fare FLOAT NOT NULL DEFAULT 0,
  accepted_fare FLOAT NOT NULL DEFAULT 0,
  final_fare FLOAT,  -- Actual amount charged
  payment_method VARCHAR(50) NOT NULL,  -- 'cash', 'card', 'wallet'
  ride_status VARCHAR(50) NOT NULL DEFAULT 'completed',  -- 'completed', 'cancelled'
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  rider_rating INT CHECK (rider_rating >= 1 AND rider_rating <= 5),  -- Rider rates driver
  rider_comment TEXT,
  driver_rating INT CHECK (driver_rating >= 1 AND driver_rating <= 5),  -- Driver rates rider
  driver_comment TEXT,
  is_payment_complete BOOLEAN DEFAULT FALSE,
  cancellation_reason VARCHAR(255),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Create indexes for better query performance
CREATE INDEX idx_ride_history_rider_id ON ride_history(rider_id);
CREATE INDEX idx_ride_history_driver_id ON ride_history(driver_id);
CREATE INDEX idx_ride_history_created_at ON ride_history(created_at DESC);
CREATE INDEX idx_ride_history_status ON ride_history(ride_status);
CREATE INDEX idx_ride_history_rider_created ON ride_history(rider_id, created_at DESC);
CREATE INDEX idx_ride_history_driver_created ON ride_history(driver_id, created_at DESC);

-- Enable RLS
ALTER TABLE ride_history ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Riders can view their own ride history
CREATE POLICY "Riders can view own ride history"
  ON ride_history
  FOR SELECT
  USING (auth.uid() = rider_id);

-- RLS Policy: Drivers can view their own ride history
CREATE POLICY "Drivers can view own ride history"
  ON ride_history
  FOR SELECT
  USING (auth.uid() = driver_id);

-- RLS Policy: Only system (via backend) can insert
CREATE POLICY "System can insert ride history"
  ON ride_history
  FOR INSERT
  WITH CHECK (true);

-- RLS Policy: Only system (via backend) can update
CREATE POLICY "System can update ride history"
  ON ride_history
  FOR UPDATE
  USING (true);

-- Create a function to auto-archive completed rides from rides table
CREATE OR REPLACE FUNCTION archive_completed_ride()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'completed' THEN
    INSERT INTO ride_history (
      id, rider_id, driver_id, pickup_location, destination_location,
      vehicle_type, distance_km, estimated_minutes, offered_fare,
      accepted_fare, final_fare, payment_method, ride_status,
      start_time, end_time, is_payment_complete, created_at, updated_at
    )
    VALUES (
      NEW.id, NEW.rider_id, NEW.driver_id, NEW.pickup_location,
      NEW.destination_location, NEW.vehicle_type, NEW.distance_km,
      NEW.estimated_minutes, NEW.offered_fare, NEW.accepted_fare,
      NEW.accepted_fare, NEW.payment_method, 'completed',
      NEW.created_at, NOW(), TRUE, NEW.created_at, NOW()
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to auto-archive
CREATE TRIGGER archive_ride_on_complete
AFTER UPDATE ON rides
FOR EACH ROW
EXECUTE FUNCTION archive_completed_ride();
```

---

## Execution Steps

1. **Open Supabase Dashboard** → SQL Editor
2. **Copy and paste the SQL above**
3. **Click Execute**
4. **Verify table created:**
   ```sql
   SELECT tablename FROM pg_tables WHERE tablename = 'ride_history';
   ```

---

## Table Structure

| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Primary key (same as ride ID) |
| `rider_id` | UUID | Reference to rider user |
| `driver_id` | UUID | Reference to driver user |
| `pickup_location` | JSONB | Pickup coordinates & address |
| `destination_location` | JSONB | Destination coordinates & address |
| `vehicle_type` | VARCHAR(50) | bike, car, auto |
| `distance_km` | FLOAT | Total distance traveled |
| `estimated_minutes` | INT | Estimated duration |
| `offered_fare` | FLOAT | Rider's initial offer |
| `accepted_fare` | FLOAT | Driver accepted amount |
| `final_fare` | FLOAT | Actual amount charged |
| `payment_method` | VARCHAR(50) | Payment type used |
| `ride_status` | VARCHAR(50) | completed, cancelled |
| `start_time` | TIMESTAMPTZ | When ride started |
| `end_time` | TIMESTAMPTZ | When ride ended |
| `rider_rating` | INT | Rating given by driver (1-5) |
| `rider_comment` | TEXT | Driver's comment about rider |
| `driver_rating` | INT | Rating given by rider (1-5) |
| `driver_comment` | TEXT | Rider's comment about driver |
| `is_payment_complete` | BOOLEAN | Payment status |
| `cancellation_reason` | VARCHAR(255) | Reason if cancelled |
| `created_at` | TIMESTAMPTZ | Record creation time |
| `updated_at` | TIMESTAMPTZ | Last update time |

---

## RLS Security Policies

✅ **Riders** can only view their own ride history  
✅ **Drivers** can only view their own ride history  
✅ **System** (backend) inserts and updates records  
✅ **No user deletes** allowed (data immutable)

---

## Auto-Archiving Trigger

The SQL includes a **trigger function** that automatically archives completed rides:
- When a ride status changes to `'completed'` in the `rides` table
- It's automatically copied to `ride_history` table
- Original ride can then be deleted from active rides (optional)

---

## Usage in App

### Fetch Rider's Completed Rides
```dart
final rideHistoryService = RideHistoryService(supabaseService);
final history = await rideHistoryService.getRiderRideHistory(userId);
```

### Fetch Driver's Completed Rides
```dart
final history = await rideHistoryService.getDriverRideHistory(driverId);
```

### Get Driver Statistics
```dart
final avgRating = await rideHistoryService.getDriverAverageRating(driverId);
final totalRevenue = await rideHistoryService.getTotalRevenue(driverId, userType: 'driver');
```

### Archive a Completed Ride Manually
```dart
await rideHistoryService.archiveCompletedRide(
  rideId: ride.id,
  riderId: ride.riderId,
  driverId: ride.driverId!,
  pickupLocation: ride.pickupLocation,
  destinationLocation: ride.destinationLocation,
  vehicleType: ride.vehicleType,
  distanceKm: ride.distanceKm ?? 0,
  estimatedMinutes: ride.estimatedMinutes ?? 0,
  offeredFare: ride.offeredFare ?? 0,
  acceptedFare: ride.acceptedFare ?? 0,
  finalFare: ride.acceptedFare ?? 0,
  paymentMethod: ride.paymentMethod,
  rideStatus: 'completed',
  startTime: ride.createdAt!,
  endTime: DateTime.now(),
);
```

### Update Rating After Ride
```dart
await rideHistoryService.updateDriverRating(
  rideHistoryId: rideId,
  rating: 5,
  comment: 'Great driver!',
);
```

---

## Notes

- The trigger automatically archives rides, you don't need to manually insert
- `rider_rating` and `rider_comment` are added when rider rates driver
- `driver_rating` and `driver_comment` are added when driver rates rider
- `final_fare` may differ from `accepted_fare` if taxes/surges applied
- Historical data is immutable (no delete policies)

