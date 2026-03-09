# GB Ride — Development Tasks & Roadmap

> Last updated: March 2026

## Phase 1 — MVP (Core Ride Loop)

### 1.1 Authentication
- [x] Supabase project setup with Auth enabled
- [x] Magic link (email OTP) sign-in flow
- [x] `AuthController` with session persistence
- [x] Login screen UI
- [x] OTP verification screen UI
- [x] Role-based registration form (Driver / Local)
- [x] Deep link callback (`gbride://login-callback`)
- [x] Soft delete account (`is_deleted` flag)
- [x] Auth state listener (auto-redirect on sign-in/out)

### 1.2 Database & Models
- [x] `locals` table in Supabase
- [x] `drivers` table in Supabase
- [x] `rides` table in Supabase
- [x] `ride_offers` table in Supabase
- [x] `LocalModel` with toMap/fromMap/copyWith
- [x] `DriverModel` with toMap/fromMap/copyWith
- [x] `RideModel` with toMap/fromMap/copyWith + RideStatus enum
- [x] `RideOfferModel` with toMap/fromMap/copyWith
- [ ] Verify all Supabase tables have correct columns matching models
- [ ] Set up Row Level Security (RLS) policies on all tables
- [ ] Create database indexes for frequently queried columns (`status`, `ride_id`, `driver_id`)

### 1.3 Services (Backend Logic)
- [x] `RideService` — singleton, all ride + offer CRUD
- [x] `LocationService` — GPS broadcasting every 10s
- [x] `DriverService` — driver profile CRUD
- [x] `LocalService` — local profile CRUD
- [x] Haversine distance calculation for nearby drivers
- [x] Real-time streams for rides, offers, requests

### 1.4 Local (Rider) Module — Backend
- [x] `RideController` — GetX controller
- [x] `requestRide()` — create ride in Supabase
- [x] `_listenToOffers()` — real-time incoming offers
- [x] `acceptOffer()` — assign driver + expire others
- [x] `adjustFare()` — ±5 PKR fare changes
- [x] `cancelRide()` — cancel + expire offers
- [x] `_listenToRide()` — real-time status updates
- [x] `_cleanup()` — reset all state + cancel streams
- [x] `startAcceptCountdown()` — 12-second timer

### 1.5 Driver Module — Backend
- [x] `DriverController` — GetX controller
- [x] `goOnline()` / `goOffline()` — toggle with GPS + request stream
- [x] `_loadDriverProfile()` — fetch from `drivers` table by `auth_id`
- [x] `_listenToIncomingRequests()` — real-time ride requests
- [x] `sendOffer()` — create offer with duplicate check
- [x] `_watchMyOffer()` — detect accepted/expired
- [x] `_startWatchingRide()` — track ride lifecycle
- [x] `updateRideStatus()` — onWay → waiting → ongoing → completed
- [x] `completeRide()` — set completed + cleanup

### 1.6 Local (Rider) Module — UI Wiring
- [x] `home_screen.dart` — register `RideController`, pass coordinates
- [x] `home_bottom_sheet.dart` — pickup/dest/fare input → create ride
- [x] `fare_bottom_sheet.dart` — custom fare input, return value
- [x] `find_driver_bottom_sheet.dart` — show offers, fare ±5, accept
- [x] `ride_flow_bottom_sheet.dart` — real-time ride status display
- [ ] Verify `home_screen.dart` passes correct lat/lng from map
- [ ] Test fare input validation (no 0 or negative fares)
- [ ] Handle edge case: all offers expired and no new ones coming
- [ ] Add loading indicators during ride creation

### 1.7 Driver Module — UI Wiring
- [x] `driver_bottom_sheet.dart` — show incoming requests via Obx
- [x] `offer_fare_screen.dart` — send offer to Supabase
- [x] `ride_flow_screen.dart` — status transitions (onWay → completed)
- [ ] Register `DriverController` in `driver_home_screen.dart` initState
- [ ] Verify online/offline toggle updates Supabase correctly
- [ ] Test GPS broadcasting starts/stops with toggle
- [ ] Handle edge case: offer expired while driver on offer screen

### 1.8 Map & Location
- [x] FlutterMap with Mapbox tiles
- [x] GPS location access (Geolocator)
- [x] Location search / autocomplete
- [x] Map pin selection for pickup/destination
- [ ] Show driver location on rider's map in real-time
- [ ] Show route polyline (pickup to destination)
- [ ] Center map on user's current location on load
- [ ] Handle GPS permission denial gracefully

### 1.9 Critical Bug Fixes & QA
- [ ] Run `flutter analyze` — fix all lint errors
- [ ] Compile and run on physical device
- [ ] Test complete flow: Local requests → Driver offers → Local accepts → Ride completes
- [ ] Test cancellation flows (before/after offer accepted)
- [ ] Test GPS broadcasting accuracy
- [ ] Test real-time stream reconnection after network loss
- [ ] Verify stream cleanup (no ghost listeners after navigation)
- [ ] Test with 2 devices simultaneously (1 local + 1 driver)

---

## Phase 2 — Enhanced Experience

### 2.1 Push Notifications
- [ ] Integrate Firebase Cloud Messaging (FCM)
- [ ] Notification when driver sends offer
- [ ] Notification when local accepts offer
- [ ] Notification for ride status changes
- [ ] Notification screen shows history
- [ ] Background notification handling

### 2.2 Driver Rating & Reviews
- [ ] Design `ratings` table (ride_id, local_id, driver_id, stars, comment)
- [ ] Rating screen after ride completion (rider side)
- [ ] Calculate and display average driver rating
- [ ] Show rating on offer cards
- [ ] Update `driverRating` and `driverTotalRides` fields

### 2.3 Ride History
- [ ] Fetch completed rides from Supabase
- [ ] History screen with ride cards (date, route, fare, driver)
- [ ] Ride detail view
- [ ] Filter by date range

### 2.4 UX Improvements
- [ ] Fare estimation algorithm (based on distance × rate)
- [ ] Ride receipt generation (shareable)
- [ ] Animated transitions between ride states
- [ ] Map zoom to fit pickup → destination
- [ ] "Driver approaching" animation on map
- [ ] Splash screen role detection loading indicator
- [ ] Empty state illustrations for lists

### 2.5 Safety Features
- [ ] SOS / Emergency button during ride
- [ ] Share ride details via WhatsApp/SMS
- [ ] Safety tips screen content
- [ ] Report driver functionality

### 2.6 Profile Enhancements
- [ ] Profile image upload (Supabase Storage)
- [ ] Edit profile screen
- [ ] Vehicle details display for driver
- [ ] Document upload (CNIC, license)

---

## Phase 3 — Monetization & Scale

### 3.1 Payments
- [ ] JazzCash / EasyPaisa integration
- [ ] In-app wallet for drivers
- [ ] Commission model (platform takes X% per ride)
- [ ] Payment method selection on ride request
- [ ] Driver earnings dashboard
- [ ] Withdrawal to bank account

### 3.2 Admin Dashboard
- [ ] Web dashboard (Flutter Web or Next.js)
- [ ] User management (drivers, locals)
- [ ] Ride monitoring (active, completed, cancelled)
- [ ] Revenue analytics
- [ ] Driver verification workflow (approve/reject registrations)
- [ ] Support ticket system

### 3.3 Advanced Features
- [ ] Surge pricing during peak hours
- [ ] Scheduled rides (book for later)
- [ ] Favorite drivers list
- [ ] In-app chat (rider ↔ driver)
- [ ] Multi-language support (Urdu, English)
- [ ] Ride sharing / carpooling mode

### 3.4 Infrastructure
- [ ] CI/CD pipeline (GitHub Actions)
- [ ] Supabase database migrations via CLI
- [ ] Automated testing (unit + integration)
- [ ] Error tracking (Sentry or Crashlytics)
- [ ] Performance monitoring
- [ ] App Store / Play Store submission
- [ ] Multi-city expansion (Skardu, Hunza, Chilas)

### 3.5 Student Module (Re-activation)
- [ ] Campus-specific ride requests
- [ ] Student verification
- [ ] Discounted fare model
- [ ] University POI integration

---

## Known Issues & Tech Debt

| Issue | Priority | Status |
|-------|----------|--------|
| `DriverController` not registered in `driver_home_screen.dart` | High | Open |
| RLS policies not configured on Supabase tables | High | Open |
| No `flutter analyze` / compilation check done | High | Open |
| `rides` table existence not confirmed by developer | Medium | Open |
| `LocationService` uses `auth_id` for driver GPS but `id` for updates | Medium | Needs review |
| `provider` package in pubspec but not used for ride logic | Low | Cleanup |
| `enum/ride_status.dart` is legacy (enum now in `ride_model.dart`) | Low | Cleanup |
| `LocalModel.toMap()` uses `'authId'` instead of `'auth_id'` | Medium | Bug |
| No input validation on fare (can submit 0 or negative) | Medium | Open |
| No network connectivity check before Supabase calls | Medium | Open |
