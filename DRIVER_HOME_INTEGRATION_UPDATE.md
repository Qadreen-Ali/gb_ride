# Driver Home Module - Supabase Integration Update

## Overview
Updated all files in `lib/view/module/driver/home/` to integrate with Supabase for real-time data fetching and updates. The flow is now properly connected to the backend.

---

## Files Updated

### 1. **driver_home_screen.dart**
**Purpose:** Main driver home screen with map and real-time location tracking

**Changes:**
- ✅ Added `SupabaseService` instance for database operations
- ✅ Added live location tracking that updates driver position in Supabase
- ✅ Pass `supabaseService` to `DriverBottomSheet` for data fetching
- ✅ Added `_updateDriverLocation()` method that syncs GPS coordinates to Supabase
- ✅ Live location stream now calls `_updateDriverLocation()` to keep driver position current

**Data Flow:**
```
GPS Updates → _startLiveLocation() → _updateDriverLocation() → Supabase
```

---

### 2. **driver_bottom_sheet.dart**
**Purpose:** Display available ride requests for driver to accept

**Changes:**
- ✅ Replaced mock ride data with real Supabase queries
- ✅ Added `SupabaseService` parameter to constructor
- ✅ Added `FutureBuilder` to load pending rides from Supabase
- ✅ Rides are fetched by vehicle type (currently 'bike')
- ✅ Converted `RideModel` to `RideUiModel` using `RideAdapter`

**Data Flow:**
```
DriverBottomSheet loads → _fetchPendingRides() → Supabase query → 
Convert with RideAdapter → Display in ListView
```

**Pending Ride Query:**
```dart
await supabaseService.fetchPendingRidesByVehicleType('bike')
```

---

### 3. **offer_fare_screen.dart**
**Purpose:** Driver customizes and sends fare offer for a ride

**Changes:**
- ✅ Added `SupabaseService` parameter (optional, creates new instance if not provided)
- ✅ Added `_isSubmitting` flag to prevent duplicate submissions
- ✅ `_sendOffer()` now async and updates ride in Supabase
- ✅ Calls `acceptRideAsDriver()` to update ride status to 'driverAssigned'
- ✅ Passes `acceptedFare` to database
- ✅ Button shows loading state while submitting
- ✅ Navigates to RideFlowScreen after successful acceptance

**Data Flow:**
```
Driver sets fare → _sendOffer() → acceptRideAsDriver() → 
Ride status updated in Supabase → Navigate to ride flow
```

**Ride Accept Query:**
```dart
await supabaseService.acceptRideAsDriver(
  rideId: widget.rideModel.rideId,
  driverId: driverId,
  acceptedFare: fare,
)
```

---

### 4. **app_drawer.dart**
**Purpose:** Navigation drawer with driver profile

**Changes:**
- ✅ Added `SupabaseService` for fetching driver profile
- ✅ Profile info now loaded from Supabase on init
- ✅ Displays actual driver name and phone number from database
- ✅ Uses `FutureBuilder` for async profile loading
- ✅ Graceful fallback to default values if data not available

**Data Flow:**
```
App drawer loads → Fetch current user ID → fetchUserById() → 
Display driver name & phone from Supabase
```

---

### 5. **driver_trips.dart**
**Purpose:** Show driver's ride history (completed, canceled, upcoming)

**Changes:**
- ✅ Converted from StatelessWidget to StatefulWidget
- ✅ Added `SupabaseService` to fetch driver's rides
- ✅ Replaced mock data with real ride data from Supabase
- ✅ Added tab selection (All, Completed, Canceled) - structure ready for filtering
- ✅ Dynamic status coloring based on ride status
- ✅ Shows actual ride pickup/destination locations from database
- ✅ Displays actual accepted fare from database

**Data Flow:**
```
DriverTripsScreen loads → Fetch driver ID → fetchRidesByDriver() → 
Map ride data to UI → Display in ListView
```

---

## Authentication Flow

All screens use:
```dart
final driverId = _supabaseService.getCurrentUserId();
```

This retrieves the authenticated driver ID from Supabase auth, ensuring all operations are scoped to the logged-in driver.

---

## Ride Status Flow in Driver Home

```
1. Driver Home loads
   ↓
2. DriverBottomSheet fetches pending rides (status='pending')
   ↓
3. Driver views ride offer card
   ↓
4. Driver opens OfferFareScreen and customizes fare
   ↓
5. Driver submits fare → acceptRideAsDriver() called
   ↓
6. Ride status → 'driverAssigned' in Supabase
   ↓
7. Navigate to RideFlowScreen to pick up rider
   ↓
8. After completion → Ride status → 'completed'
```

---

## Key Services Used

### SupabaseService Methods:
- `getCurrentUserId()` - Get authenticated driver ID
- `fetchPendingRidesByVehicleType(type)` - Get available rides
- `acceptRideAsDriver(rideId, driverId, acceptedFare)` - Accept and offer fare
- `updateDriverLocation(driverId, lat, lng)` - Update driver position
- `fetchUserById(userId)` - Get driver profile
- `fetchRidesByDriver(driverId)` - Get driver's trip history

### RideAdapter:
- `toUiModel(rideModel)` - Convert database model to UI model

---

## Data Models Used

- **RideModel** - Canonical model from Supabase (has rideId, pickupLocation, destinationLocation, etc.)
- **RideUiModel** - Display model with formatted strings
- **UserModel** - Driver profile with fullName, phoneNumber, etc.

---

## Error Handling

All async operations wrapped in try-catch:
- ✅ Location update errors logged but don't crash app
- ✅ Ride fetching errors show "No rides available"
- ✅ Offer submission errors shown in SnackBar
- ✅ Profile loading errors gracefully fallback to defaults

---

## Next Steps

To fully test this integration:

1. Ensure driver is authenticated in Supabase
2. Create test rides in Supabase with status='pending'
3. Verify pending rides appear in bottom sheet
4. Test accepting ride and submitting fare offer
5. Check Supabase that ride status updates to 'driverAssigned'
6. Verify driver location updates in real-time in database

---

## Compilation Status

✅ All files compile without errors
- driver_home_screen.dart - No errors
- driver_bottom_sheet.dart - No errors
- offer_fare_screen.dart - No errors
- app_drawer.dart - No errors
- driver_trips.dart - No errors
