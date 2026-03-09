# GB Ride — Project Context

> This file is designed for AI assistants (Copilot, Claude, GPT) to quickly understand the project without needing previous conversation history.

## 1. Project Summary

**GB Ride** is an InDrive-style ride-hailing app for Gilgit-Baltistan, Pakistan. Built with Flutter + GetX + Supabase.

**Core flow**: Local (rider) requests a ride with a base fare → Drivers send fare offers (bids) → Local accepts the best offer → Both enter a real-time ride flow until completion.

**NOT Uber-style**: Drivers do NOT accept or reject rides. They can only send fare offers. The local (rider) has full control over which offer to accept.

**Two active modules**: `local` (rider) and `driver`. A `student` module exists but is **abandoned**.

## 2. Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Framework** | Flutter (Dart ≥3.9.0) | Cross-platform mobile app |
| **State Management** | GetX | Reactive state (`Obx`, `RxBool`, `RxList`, `Rx<T?>`), DI (`Get.put`, `Get.find`), navigation, snackbars |
| **Backend / Database** | Supabase | PostgreSQL tables, Auth (magic link), real-time streams |
| **Maps** | FlutterMap + Mapbox tiles | Map widget and tile rendering |
| **GPS** | Geolocator | Device location, high accuracy |
| **Coordinates** | latlong2 | `LatLng` type for coordinates |
| **Distance** | Haversine formula | Custom implementation in `RideService` (5km radius for nearby drivers) |
| **Env Variables** | flutter_dotenv | `.env` file with `SUPABASE_URL` and `SUPABASE_ANONKEY` |
| **UI Panels** | sliding_up_panel | Bottom sheet overlays on map |
| **External Links** | url_launcher | WhatsApp contact for drivers |
| **Forms** | mask_text_input_formatter | Input formatting |
| **Fonts** | google_fonts + Poppins | Custom typography |

## 3. Coding Standards

### General
- **Language**: Dart (Flutter)
- **Null safety**: Enabled (Dart 3.9+)
- **File naming**: `snake_case.dart`
- **Class naming**: `PascalCase`
- **Variable naming**: `camelCase`
- **Private members**: Prefixed with `_`
- **Constants file**: `lib/utils/constants/` (colors, text strings, sizing, buttons)

### State Management (GetX)
- Controllers extend `GetxController`
- Observable state uses `Rx<T>`, `RxBool`, `RxList`, `RxString`
- UI wraps reactive widgets in `Obx(() => ...)`
- Controllers registered with `Get.put()` in widget `initState()` or `main.dart`
- `AuthController` is registered permanently in `main.dart`
- `RideController` is registered in `LocalHomeScreen.initState()`
- `DriverController` should be registered in `DriverHomeScreen.initState()`
- Always clean up `StreamSubscription` objects in `onClose()`

### Services (Singleton Pattern)
- All service classes use private constructor + static instance:
  ```dart
  class RideService {
    RideService._();
    static final RideService instance = RideService._();
  }
  ```
- Services are stateless — they interact with Supabase and return data
- Controllers call services; UI never calls services directly

### Supabase Conventions
- Tables: `snake_case` (e.g., `ride_offers`, `rides`, `drivers`, `locals`)
- Columns: `snake_case` (e.g., `driver_id`, `pickup_lat`, `created_at`)
- Primary keys: `id` (UUID, auto-generated)
- Auth linkage: `auth_id` column stores Supabase Auth user UUID
- Real-time: Use `.stream(primaryKey: ['id'])` for live updates
- Soft deletion: `is_deleted` boolean flag (not hard delete)
- Timestamps: ISO 8601 strings (`DateTime.now().toIso8601String()`)

### Models
- All models have `toMap()`, `fromMap()`, and `copyWith()` methods
- `toMap()` excludes `id` (Supabase auto-generates)
- `fromMap()` reads `id` from the `map['id']` key
- Enums stored as `.name` string in database, parsed with switch statements

## 4. Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| Files | `snake_case.dart` | `ride_service.dart`, `driver_controller.dart` |
| Classes | `PascalCase` | `RideModel`, `DriverController` |
| Widgets | `PascalCase` | `HomeBottomSheet`, `FareBottomSheet` |
| Variables | `camelCase` | `currentRide`, `isOnline`, `driverDbId` |
| Observables | `camelCase` with Rx type | `RxBool isOnline`, `RxList<RideOfferModel> incomingOffers` |
| Private | `_camelCase` | `_authId`, `_rideSubscription`, `_loadDriverProfile()` |
| Constants | `camelCase` in dedicated files | `AppSizes.padding16`, `ColorString.primary` |
| Routes | `'/lowercase'` | `'/localhome'`, `'/driverhome'`, `'/login'` |
| Supabase tables | `snake_case` | `rides`, `ride_offers`, `drivers`, `locals` |
| Supabase columns | `snake_case` | `pickup_lat`, `driver_name`, `created_at` |

## 5. Folder Structure

```
lib/
├── main.dart                           # App entry, Supabase init, GetMaterialApp, routes
├── common/                             # Shared UI widgets
│   ├── bottom_navbar.dart
│   ├── form_button.dart
│   └── text_field.dart                 # TTextField — reusable text input
├── enum/
│   └── ride_status.dart                # (Legacy — enum now lives in ride_model.dart)
├── models/
│   ├── ride_model.dart                 # RideModel + RideStatus enum (7 statuses)
│   ├── ride_offer_model.dart           # RideOfferModel (driver's fare bid)
│   ├── driver_model/
│   │   └── driver_model.dart           # DriverModel (profile, vehicle, auth linkage)
│   ├── local_model/
│   │   └── local_model.dart            # LocalModel (profile, auth linkage)
│   └── gb_location_data/
│       └── gb_poi.dart                 # Gilgit POI data model
├── services/
│   ├── ride_services/
│   │   └── ride_service.dart           # All ride + offer Supabase operations (singleton)
│   ├── map_services/
│   │   └── location_service.dart       # GPS broadcasting, driver location tracking (singleton)
│   ├── driver_services/
│   │   └── driver_service.dart         # Driver profile CRUD
│   └── local_service/
│       └── local_service.dart          # Local profile CRUD
├── utils/
│   ├── logger.dart
│   ├── constants/                      # App-wide constants
│   │   ├── app_sizes.dart
│   │   ├── color_string.dart
│   │   ├── text_string.dart
│   │   ├── image_string.dart
│   │   ├── app_snackbar_string.dart
│   │   ├── primary_button.dart
│   │   ├── secondary_button.dart
│   │   ├── social_button.dart
│   │   ├── custom_app_bar.dart
│   │   └── bottom_bar.dart
│   └── formatters/                     # Input formatters
└── view/
    ├── auth/
    │   ├── login_screen.dart           # Email magic link login
    │   ├── form_screen.dart            # Driver/Local registration form
    │   ├── otp_verification_screen.dart
    │   ├── controller/
    │   │   └── auth_controller.dart    # Auth state, sign in/out, delete account
    │   └── common/                     # Shared auth widgets
    ├── splash/
    │   └── splash_screen.dart          # Role detection, route to correct home
    ├── module/
    │   ├── local/                      # === RIDER MODULE ===
    │   │   ├── controller/
    │   │   │   └── ride_controller.dart    # Ride state, offers, fare, cleanup
    │   │   ├── home/
    │   │   │   ├── home_screen.dart         # Map screen, registers RideController
    │   │   │   ├── home_bottom_sheet.dart   # Pickup/dest/fare/vehicle → "Find Driver"
    │   │   │   ├── bottom_sheet/
    │   │   │   │   ├── find_driver_bottom_sheet.dart  # Offers list, fare ±5, accept offer
    │   │   │   │   └── ride_flow/
    │   │   │   │       └── ride_flow_bottom_sheet.dart # Real-time ride status display
    │   │   │   ├── widgets/
    │   │   │   │   ├── fare_bottom_sheet.dart          # Custom fare input modal
    │   │   │   │   ├── location_input_field.dart
    │   │   │   │   ├── location_search_screen.dart
    │   │   │   │   ├── map_markers.dart
    │   │   │   │   ├── map_selection_overlay.dart
    │   │   │   │   ├── payment_method_bottom_sheet.dart
    │   │   │   │   ├── top_bar.dart
    │   │   │   │   ├── vehicle_option.dart
    │   │   │   │   └── vehicle_selector.dart
    │   │   │   ├── app_drawer/
    │   │   │   └── rating/
    │   │   ├── notifications/
    │   │   └── setting/                # Profile, Safety, Help, Payment, History
    │   ├── driver/                     # === DRIVER MODULE ===
    │   │   ├── controller/
    │   │   │   └── driver_controller.dart  # Online/offline, offers, ride flow
    │   │   ├── home/
    │   │   │   ├── driver_home_screen.dart  # Map screen for driver
    │   │   │   ├── driver_bottom_sheet.dart # Shows incoming ride requests
    │   │   │   ├── app_drawer/
    │   │   │   ├── common/
    │   │   │   └── widgets/
    │   │   ├── bottom_sheet/
    │   │   │   ├── offer_fare_screen.dart       # Driver customizes + sends offer
    │   │   │   └── ride_flow/
    │   │   │       ├── ride_flow_screen.dart     # onWay→waiting→ongoing→completed
    │   │   │       └── widget/                   # Ride flow sub-widgets
    │   │   ├── auth/
    │   │   ├── common/
    │   │   ├── notifications/
    │   │   ├── payment/
    │   │   └── settings/               # Profile, Wallet, Trips
    │   └── student/                    # ❌ ABANDONED — not active
```

## 6. Key Development Rules

### Critical Architecture Rules
1. **InDrive model, NOT Uber** — Drivers send fare offers. They CANNOT accept or reject rides. Only Locals (riders) accept offers.
2. **Two active modules only** — `local` and `driver`. Student module is abandoned.
3. **Supabase is the single source of truth** — All ride/offer data lives in PostgreSQL. No local persistence.
4. **Real-time via Supabase streams** — Use `.stream(primaryKey: ['id'])` for live updates.
5. **GetX for state** — No Provider mixing (Provider is in pubspec but not used for ride logic).

### Ride Status Flow
```
requested → accepted → onWay → waiting → ongoing → completed
                                                └→ cancelled (at any point)
```

- `requested` — Local created the ride, waiting for offers.
- `accepted` — Local accepted a driver's offer.
- `onWay` — Driver heading to pickup.
- `waiting` — Driver arrived at pickup, waiting for passenger.
- `ongoing` — Trip in progress.
- `completed` — Driver ended the trip.
- `cancelled` — Either party cancelled.

### Offer Status Flow
```
pending → accepted (one offer)
        → expired  (all other offers when one is accepted, or ride cancelled)
```

### Stream Cleanup
- Every `StreamSubscription` MUST be cancelled in the controller's `onClose()` method.
- Every `Timer` MUST be cancelled in `onClose()`.
- `_cleanup()` methods should reset all `Rx` state to defaults.

### Controller Registration
- `AuthController` — `Get.put()` in `main.dart` with `permanent: true`
- `RideController` — `Get.put()` in `LocalHomeScreen.initState()`
- `DriverController` — `Get.put()` in `DriverHomeScreen.initState()`

### Currency
- All fares are in **PKR (Pakistani Rupees)**
- Display format: `"350 PKR"` (no decimals for display — `.toStringAsFixed(0)`)
- Stored as `double` in database

### Tables
- `drivers` table uses `auth_id` (not `id`) to match current Supabase Auth user
- `locals` table uses `auth_id` (not `id`) to match current Supabase Auth user
- `rides.local_id` references the **`locals` table `id`** (UUID), not `auth_id`
- `ride_offers.driver_id` references the **`drivers` table `id`** (UUID), not `auth_id`

## 7. How AI Assistants Should Help

### Before making changes:
1. **Read this file first** to understand the architecture.
2. **Check `PRD.md`** for product requirements.
3. **Check `DATABASE_SCHEMA.md`** for table structures.
4. **Check `ARCHITECTURE.md`** for system design patterns.
5. **Read the actual file** before editing — files may have changed since these docs.

### When writing code:
- Follow the existing GetX reactive pattern (`Obx`, `Rx<T>`)
- Use the singleton service pattern for any new services
- All models need `toMap()`, `fromMap()`, `copyWith()`
- Use `snake_case` for Supabase column names in maps
- Always handle stream cleanup in `onClose()`
- Use `Get.snackbar()` for user-facing messages, not `print()`
- Fare display: `PKR ${fare.toStringAsFixed(0)}`

### Common pitfalls to avoid:
- **Do NOT use Uber-style accept/reject** — This is InDrive-style with offers.
- **Do NOT remove the `waiting` status** — It's actively used in ride flow widgets.
- **Do NOT hardcode Supabase credentials** — Use `.env` file via `flutter_dotenv`.
- **Do NOT call services directly from UI** — Always go through controllers.
- **Do NOT forget stream cleanup** — Memory leaks and ghost listeners will occur.
- **`drivers` table lookup by current user** — Use `.eq('auth_id', authId)`, not `.eq('id', authId)`.
- **`ride_offers` table** — `driver_id` is the drivers table UUID, not the auth UUID.

### When debugging:
- Check Supabase dashboard for actual table data
- Check real-time subscriptions are being created/cancelled properly
- Verify `is_online` flag is toggled when driver goes online/offline
- Check `status` column values match the `RideStatus` enum names exactly
