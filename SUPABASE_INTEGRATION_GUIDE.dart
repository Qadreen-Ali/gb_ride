// SUPABASE INTEGRATION GUIDE FOR GB RIDE APP
// This document outlines the complete Supabase integration for Driver and Local (Rider) modules

/*
================================================================================
1. CORE MODELS (lib/models/)
================================================================================

✅ UserModel
   - id (UUID from auth)
   - email
   - phone_number
   - full_name
   - profile_image_url
   - role ('rider' | 'driver' | 'both')
   - gender (new)
   - cnic (CNIC/B-Form number) (new)
   - age (new)
   - address (new)
   - rating
   - total_rides
   - is_verified
   - timestamps

✅ DriverModel
   - id (UUID)
   - user_id (FK to users)
   - license_number
   - license_image_url
   - vehicle_type ('Car' | 'Bike') (new)
   - vehicle_number (new)
   - current_latitude / current_longitude
   - is_online
   - status ('available' | 'onRide' | 'offline')
   - rating
   - total_trips
   - timestamps

✅ RideModel (Canonical DB model)
   - id (UUID)
   - rider_id (FK to users)
   - driver_id (FK to drivers, nullable)
   - pickup_location (JSONB: {lat, lng, name, address})
   - destination_location (JSONB: {lat, lng, name, address})
   - vehicle_type
   - offered_fare
   - accepted_fare
   - payment_method
   - status (RideStatus enum)
   - distance_km
   - estimated_minutes
   - pickup_time
   - start_time
   - end_time
   - cancelled_by / cancellation_reason
   - auto_accept
   - message_for_driver
   - timestamps

✅ RideStatus Enum (Global)
   - pending (searching for driver)
   - driverAssigned (driver assigned, heading to pickup)
   - driverArriving (driver on the way)
   - driverArrived (driver at pickup, waiting)
   - waiting (driver arrived, awaiting passenger)
   - inProgress (ride in progress to destination)
   - completed
   - cancelled

✅ RideUiModel (Lightweight UI model)
   - For driver module display
   - Contains formatted strings (distance, ETA, fare)
   - Used in home screen and ride cards

✅ RideAdapter
   - Converts RideModel → RideUiModel
   - Extracts location names from JSONB
   - Can batch convert multiple rides

✅ NotificationModel
   - For push notifications and in-app messages

✅ RatingModel
   - Driver ratings (after ride completion)
   - Tags, tips, comments

================================================================================
2. SERVICES (lib/services/)
================================================================================

✅ SupabaseService (Core service)
   Public Methods:
   - getCurrentUserId() → String?
   - getUserByPhone(phone) → UserModel?
   - fetchUserById(userId) → UserModel?
   - createOrUpdateUser(...) → UserModel
   - getDriverByUserId(userId) → DriverModel?
   - createDriver(...) → DriverModel
   - updateDriver(driverId, {...}) → void
   - fetchRidesByDriver(driverId) → List<RideModel>
   - updateDriverLocation(driverId, lat, lng) → void
   - updateDriverStatus(driverId, status) → void
   - fetchRidesByRider(riderId) → List<RideModel>
   - fetchRideById(rideId) → RideModel?
   - createRide(...) → RideModel
   - updateRideStatus(rideId, status) → void
   - fetchPendingRidesByVehicleType(type) → List<RideModel>
   - acceptRideAsDriver(rideId, driverId) → void
   - completeRide(rideId, finalFare, distance) → void
   - fetchAvailableDrivers() → List<DriverModel>
   - fetchNotifications(userId) → List<NotificationModel>
   - markNotificationAsRead(notificationId) → void
   - createRating(...) → void

✅ AuthService (High-level auth wrapper)
   - completeUserProfile(...) → UserModel
   - completeDriverProfile(...) → DriverModel
   - getCurrentUserProfile() → (UserModel, DriverModel?)
   - isDriver() → bool
   - isRider() → bool

✅ RideService (High-level ride operations)
   - createRideRequest(...) → RideModel
   - acceptRide(rideId, driverId, acceptedFare) → void
   - getAvailableRidesForDriver(driver) → List<RideUiModel>
   - getActiveRidesForRider(riderId) → List<RideModel>
   - getRideHistoryForRider(riderId) → List<RideModel>
   - updateRideStatus(rideId, newStatus) → void
   - completeRide(rideId, finalFare, distance) → void
   - cancelRide(rideId, cancelledBy, reason) → void
   - getRideDetails(rideId) → RideModel?

================================================================================
3. DRIVER MODULE INTEGRATION
================================================================================

Flow: Registration → Home Screen → Accept Ride → Ride Flow → Complete Ride

DriverForm (Updated)
   Fields collected:
   - Full Name
   - CNIC/B-Form
   - Gender
   - Age
   - Address
   - Vehicle Type
   - Vehicle Number
   - License Number
   
   Usage:
   formData = DriverForm.getFormData(context);
   // Use formData['fullName'], formData['vehicleType'], etc.

Registration Flow (Pseudo-code):
   1. OTP verification (existing AuthController)
   2. Collect DriverForm data
   3. Call AuthService.completeUserProfile() with role='driver'
   4. Call AuthService.completeDriverProfile() with license details
   5. Redirect to DriverHomeScreen

DriverHomeScreen Integration:
   1. Fetch available rides: await RideService.getAvailableRidesForDriver(driver)
   2. Display rides as cards (use RideUiModel for UI)
   3. When driver taps "Accept": await RideService.acceptRide(...)
   4. Show driver bottom sheet with ride details
   5. Open RideFlowScreen for ride progression

RideFlowScreen Integration:
   - Already updated with RideStatus enum
   - States: driverArriving → driverArrived → waiting → inProgress
   - Call RideService.updateRideStatus() on state changes
   - Call RideService.completeRide() when ride ends

Location Tracking:
   - In DriverHomeScreen, update location periodically:
     await SupabaseService.updateDriverLocation(driverId, lat, lng)
   - This enables rider to see driver location on map

Notifications:
   - Fetch notifications: await SupabaseService.fetchNotifications(userId)
   - Mark as read: await SupabaseService.markNotificationAsRead(notifId)

================================================================================
4. LOCAL (RIDER) MODULE INTEGRATION
================================================================================

Flow: Registration → Home Screen → Create Ride → Wait for Driver → Rate Ride

LocalForm (Updated)
   Fields collected:
   - Full Name
   - CNIC/B-Form
   - Gender
   - Address
   
   Usage:
   formData = LocalForm.getFormData(context);

Registration Flow (Pseudo-code):
   1. OTP verification (existing AuthController)
   2. Collect LocalForm data
   3. Call AuthService.completeUserProfile() with role='rider'
   4. Redirect to LocalHomeScreen

LocalHomeScreen Integration:
   1. User selects pickup and destination on map
   2. Select vehicle type (Bike, Car, City)
   3. Enter offered fare
   4. Create ride: await RideService.createRideRequest(...)
   5. Show ride request with "Waiting for driver..." message
   6. Poll for driver assignment (or use realtime subscription)
   7. When driver assigned, show driver profile and track on map
   8. When ride completed, show rating screen

Rating Flow:
   - After ride completion, collect rating and comments
   - Call SupabaseService.createRating(...)
   - This updates driver's average rating

Notifications:
   - Same as driver module: fetch and mark as read

================================================================================
5. KEY IMPLEMENTATION NOTES
================================================================================

Authentication:
   - Use Supabase auth (email/phone)
   - Phone numbers stored in users table
   - After OTP verification, complete profile

Real-time Features (To implement):
   - Driver location broadcast (Supabase realtime)
   - Ride status updates (realtime subscription)
   - New ride notifications

Error Handling:
   - All services throw Exception with descriptive messages
   - Wrap service calls in try-catch in UI
   - Show snackbars for user feedback

Data Validation:
   - Phone number: normalized to +92xxxxxxxxxx format
   - Location: JSONB with {lat, lng, name, address}
   - Status: Use RideStatus enum, never strings

State Management:
   - Use setState for simple screens
   - Consider Provider/GetX for complex state sharing between modules

Location Permissions:
   - Request in DriverHomeScreen and LocalHomeScreen
   - Use geolocator package (already imported)
   - Update driver location on interval

================================================================================
6. FIREBASE/PUSH NOTIFICATIONS (Future)
================================================================================

   - Notifications table in Supabase
   - FCM integration for push to native apps
   - In-app notification badges

================================================================================
7. TESTING CHECKLIST
================================================================================

Driver Module:
   ☐ Register driver (form → profile creation)
   ☐ Accept ride from available list
   ☐ Progress through ride states
   ☐ Complete ride with final fare
   ☐ Location updates during ride
   ☐ View ride history
   ☐ Ratings received

Rider Module:
   ☐ Register rider (form → profile creation)
   ☐ Create ride request
   ☐ Receive driver assignment
   ☐ Track driver on map
   ☐ Rate driver after completion
   ☐ View ride history
   ☐ Notifications received

Cross-module:
   ☐ Logout and re-login
   ☐ Different user roles (driver vs rider)
   ☐ Handle network errors gracefully
   ☐ Realtime updates (if implemented)

================================================================================
*/
