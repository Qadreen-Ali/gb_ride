# GB Ride — Architecture Document

## 1. High-Level System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        FLUTTER APP                              │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────────────┐  │
│  │  Local Module │  │ Driver Module │  │    Auth Module        │  │
│  │  (Rider UI)   │  │  (Driver UI)  │  │  (Login/Register)    │  │
│  └──────┬───────┘  └──────┬───────┘  └──────────┬────────────┘  │
│         │                  │                      │              │
│  ┌──────┴──────────────────┴──────────────────────┴──────────┐  │
│  │                    GetX Controllers                        │  │
│  │  RideController  │  DriverController  │  AuthController    │  │
│  └──────┬──────────────────┬──────────────────────┬──────────┘  │
│         │                  │                      │              │
│  ┌──────┴──────────────────┴──────────────────────┴──────────┐  │
│  │                    Service Layer (Singletons)              │  │
│  │  RideService  │  LocationService  │  DriverService  │ ...  │  │
│  └──────┬──────────────────┬──────────────────────┬──────────┘  │
│         │                  │                      │              │
│  ┌──────┴──────────────────┴──────────────────────┴──────────┐  │
│  │                 Supabase Flutter SDK                        │  │
│  │            (REST API + Realtime WebSocket)                  │  │
│  └──────────────────────────┬────────────────────────────────┘  │
└─────────────────────────────┼────────────────────────────────────┘
                              │
                    ┌─────────▼──────────┐
                    │   SUPABASE CLOUD    │
                    │                     │
                    │  ┌───────────────┐  │
                    │  │  PostgreSQL   │  │
                    │  │  • rides      │  │
                    │  │  • ride_offers│  │
                    │  │  • drivers    │  │
                    │  │  • locals     │  │
                    │  └───────────────┘  │
                    │                     │
                    │  ┌───────────────┐  │
                    │  │  Auth (GoTrue)│  │
                    │  │  Magic Link   │  │
                    │  └───────────────┘  │
                    │                     │
                    │  ┌───────────────┐  │
                    │  │  Realtime     │  │
                    │  │  (WebSocket)  │  │
                    │  └───────────────┘  │
                    │                     │
                    │  ┌───────────────┐  │
                    │  │  Edge Funcs   │  │
                    │  │  (future)     │  │
                    │  └───────────────┘  │
                    └─────────────────────┘
```

## 2. Technology Stack

### Frontend
| Technology | Version | Purpose |
|-----------|---------|---------|
| Flutter | Latest stable | Cross-platform UI framework |
| Dart | ≥3.9.0 | Programming language |
| GetX | ^4.7.3 | State management, DI, routing, snackbars |
| FlutterMap | ^8.2.2 | Map widget (OpenStreetMap-compatible) |
| Mapbox (tiles) | — | Tile server for map rendering |
| Geolocator | ^14.0.2 | GPS location access |
| latlong2 | ^0.9.1 | Geographic coordinate types |
| sliding_up_panel | ^2.0.0+1 | Sliding bottom sheets over map |
| url_launcher | ^6.3.2 | Open WhatsApp, external links |
| flutter_dotenv | ^6.0.0 | Environment variable management |

### Backend
| Technology | Purpose |
|-----------|---------|
| Supabase (hosted) | BaaS — PostgreSQL, Auth, Realtime, Edge Functions |
| PostgreSQL | Primary database (managed by Supabase) |
| Supabase Auth (GoTrue) | Magic link email authentication |
| Supabase Realtime | WebSocket-based table change streams |
| Supabase RLS | Row Level Security (auth_id-based policies) |

### Dev Tools
| Tool | Purpose |
|------|---------|
| Android Studio | Primary IDE |
| VS Code + Copilot | Secondary IDE / AI-assisted development |
| ADB (wireless) | On-device testing (`adb connect <ip>:<port>`) |
| Supabase CLI | Local development, config management |

## 3. Component Breakdown

### 3.1 Controllers (GetX)

| Controller | Module | Responsibilities |
|-----------|--------|-----------------|
| `AuthController` | Auth | Sign in (magic link), sign out, delete account, session persistence. Registered permanently in `main.dart`. |
| `RideController` | Local | Request ride, listen to offers, accept offer, fare adjustment, ride lifecycle, countdown timer, cleanup. |
| `DriverController` | Driver | Go online/offline, listen to requests, send offers, watch offer status, ride lifecycle, GPS broadcasting. |

### 3.2 Services (Singletons)

| Service | File | Responsibilities |
|---------|------|-----------------|
| `RideService` | `services/ride_services/ride_service.dart` | All ride + offer CRUD. Create ride, cancel ride, update fare, send offer, accept offer, watch offers/ride/requests, update status. Haversine distance calc. |
| `LocationService` | `services/map_services/location_service.dart` | GPS broadcasting every 10s, start/stop tracking, get driver location from DB. |
| `DriverService` | `services/driver_services/driver_service.dart` | Driver profile CRUD. |
| `LocalService` | `services/local_service/local_service.dart` | Local profile CRUD. |

### 3.3 Models

| Model | File | Key Fields |
|-------|------|-----------|
| `RideModel` | `models/ride_model.dart` | rideId, localId, driverId?, pickup/dest locations + coords, distanceKm, etaMinutes, fare, status (enum), driver info, timestamps |
| `RideOfferModel` | `models/ride_offer_model.dart` | offerId, rideId, driverId, driverName/Phone/Image, driverRating, driverTotalRides, offeredFare, etaMinutes, status (string: pending/accepted/expired) |
| `DriverModel` | `models/driver_model/driver_model.dart` | id, authId, phone, fullName, gender, cnic, age, address, licenseNumber, vehicleType, vehicleNumber |
| `LocalModel` | `models/local_model/local_model.dart` | id, authId, phone, fullName, cnic, gender, address |
| `RideStatus` (enum) | `models/ride_model.dart` | requested, accepted, onWay, waiting, ongoing, completed, cancelled |

### 3.4 Key UI Screens

| Screen | Path | Purpose |
|--------|------|---------|
| `SplashScreen` | `view/splash/` | Role detection, route to correct home |
| `LoginScreen` | `view/auth/` | Email input, send magic link |
| `FormScreen` | `view/auth/` | Driver or Local registration |
| `LocalHomeScreen` | `view/module/local/home/` | Map + bottom sheet (rider) |
| `HomeBottomSheet` | `view/module/local/home/` | Pickup/dest/fare input |
| `FindDriverBottomSheet` | `view/module/local/home/bottom_sheet/` | Offer cards, fare ±5 |
| `RideFlowBottomSheet` | `view/module/local/home/bottom_sheet/ride_flow/` | Ride status tracking (rider) |
| `DriverHomeScreen` | `view/module/driver/home/` | Map + bottom sheet (driver) |
| `DriverBottomSheet` | `view/module/driver/home/` | Incoming ride requests |
| `OfferFareScreen` | `view/module/driver/bottom_sheet/` | Send fare offer |
| `RideFlowScreen` | `view/module/driver/bottom_sheet/ride_flow/` | Ride flow (driver) |

## 4. Backend Architecture

### Supabase as Backend-as-a-Service
GB Ride uses **Supabase** as a complete backend with no custom server:

```
Client App ──REST──▶ Supabase PostgREST ──▶ PostgreSQL
Client App ──WS────▶ Supabase Realtime  ──▶ PostgreSQL (change streams)
Client App ──REST──▶ Supabase GoTrue    ──▶ Auth (magic link, sessions)
```

### Data Flow: Ride Request → Offer → Accept → Ride Flow

```
Local (Rider)                     Supabase                      Driver
─────────────                     ────────                      ──────
1. Creates ride           ──INSERT──▶ rides (status='requested')
                                      │
                           ◀──STREAM── rides.stream()     ──▶  2. Sees request
                                                                3. Sends offer
                          ◀──INSERT── ride_offers (status='pending')
4. Sees offer card  ◀──STREAM── ride_offers.stream()
5. Accepts offer    ──UPDATE──▶ rides (status='accepted', driver assigned)
                    ──UPDATE──▶ ride_offers (accepted + others expired)
                                      │
                           ◀──STREAM── ride_offers.stream() ──▶  6. Offer accepted!
                                                                  7. Updates: onWay
                          ◀──UPDATE── rides (status='onWay')
8. Sees "On Way"    ◀──STREAM── rides.stream()
                                                                  9. Updates: waiting
                                                                  10. Updates: ongoing
                                                                  11. Updates: completed
12. Ride done       ◀──STREAM── rides.stream()
```

### Real-Time Streams Used
| Stream | Source | Consumer | Purpose |
|--------|--------|----------|---------|
| `watchRideRequests()` | `rides` table, `status='requested'` | DriverController | Show available rides to driver |
| `watchOffers(rideId)` | `ride_offers` table, `ride_id=X` | RideController | Show incoming driver bids to rider |
| `watchMyOffer(offerId)` | `ride_offers` table, `id=X` | DriverController | Know if offer was accepted/expired |
| `watchRide(rideId)` | `rides` table, `id=X` | Both controllers | Track ride status changes |

### GPS Broadcasting Architecture
```
DriverController.goOnline()
  └─▶ LocationService.startLocationBroadcast()
        └─▶ Timer.periodic(10 seconds)
              └─▶ Geolocator.getCurrentPosition()
                    └─▶ Supabase UPDATE drivers SET current_lat, current_lng
```

## 5. Frontend Architecture

### Navigation Pattern
- **GetMaterialApp** with named routes defined in `main.dart`
- Route names: `'/localhome'`, `'/driverhome'`, `'/login'`, etc.
- Modal bottom sheets presented with `showModalBottomSheet()` or `Navigator.push()`
- `Get.offAllNamed()` for auth redirects (clears stack)
- `Get.back()` / `Navigator.pop()` for dismissing sheets

### Widget Architecture
```
HomeScreen (StatefulWidget)
  ├── FlutterMap (full screen)
  └── SlidingUpPanel
        └── HomeBottomSheet (StatefulWidget)
              ├── Location inputs
              ├── Vehicle selector
              ├── Fare input
              └── "Find Driver" button
                    └── Opens FindDriverBottomSheet
                          ├── Offer cards (Obx reactive)
                          ├── Fare ±5 buttons
                          └── Accept → Opens RideFlowBottomSheet
```

### State Flow
```
UI Widget ──reads──▶ GetX Controller (Obx) ──calls──▶ Service (singleton) ──queries──▶ Supabase
         ◀─reacts─             ◀──stream──                         ◀──realtime──
```

## 6. Database Design Overview

### Entity Relationship Diagram (Simplified)
```
┌──────────┐       ┌──────────────┐       ┌──────────────┐
│  locals  │       │    rides     │       │   drivers    │
│──────────│  1:N  │──────────────│  N:1  │──────────────│
│ id (PK)  │◄──────│ local_id(FK) │       │ id (PK)      │
│ auth_id  │       │ driver_id(FK)│──────►│ auth_id      │
│ full_name│       │ status       │       │ full_name    │
│ phone    │       │ fare         │       │ phone        │
│ ...      │       │ pickup_*     │       │ vehicle_*    │
└──────────┘       │ dest_*       │       │ is_online    │
                   │ created_at   │       │ current_lat  │
                   └──────┬───────┘       │ current_lng  │
                          │               └──────────────┘
                          │ 1:N                    │
                   ┌──────▼───────┐                │
                   │ ride_offers  │        N:1     │
                   │──────────────│────────────────┘
                   │ id (PK)      │
                   │ ride_id (FK) │
                   │ driver_id(FK)│
                   │ offered_fare │
                   │ status       │
                   └──────────────┘
```

### Core Tables
- **`locals`** — Rider profiles
- **`drivers`** — Driver profiles + vehicle info + GPS coords + online status
- **`rides`** — Ride requests with full lifecycle
- **`ride_offers`** — Driver fare bids on rides (InDrive bidding)

> See `DATABASE_SCHEMA.md` for complete table definitions.

## 7. Security Considerations

### Authentication
- **Supabase Auth (GoTrue)** handles all authentication
- **Magic link** (email OTP) — no password storage
- Session tokens managed by Supabase Flutter SDK
- Deep link callback: `gbride://login-callback`

### Row Level Security (RLS)
- Tables should have RLS policies based on `auth_id`
- Drivers can only update their own profile (`auth_id = auth.uid()`)
- Locals can only see/cancel their own rides
- Ride offers visible to the ride's local and the offering driver
- **Note**: RLS policies may not be fully configured yet — needs review

### Data Protection
- No passwords stored (magic link auth)
- CNIC data stored in Supabase (should be encrypted at rest — Supabase default)
- `.env` file for secrets (not committed to git)
- Soft delete pattern — accounts marked `is_deleted`, not purged

### API Security
- All Supabase calls use the `anon` key with RLS enforcement
- No direct database access from client — all through PostgREST
- Rate limiting handled by Supabase infrastructure

## 8. Deployment Architecture

### Current Setup
```
Developer Machine (Windows)
  ├── Android Studio / VS Code
  ├── Flutter SDK (Dart ≥3.9.0)
  ├── ADB wireless debugging (192.168.x.x)
  └── .env (SUPABASE_URL, SUPABASE_ANONKEY)

Supabase Cloud (Hosted)
  ├── PostgreSQL database
  ├── Auth service (GoTrue)
  ├── Realtime (WebSocket)
  ├── PostgREST (Auto-generated REST API)
  └── Edge Functions (future)

App Distribution
  ├── Android: APK / Play Store (future)
  └── iOS: TestFlight / App Store (future)
```

### Environment Variables
```env
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANONKEY=eyJhbGciOi...
```

### Build Commands
```bash
# Development
flutter run

# Release APK
flutter build apk --release

# iOS
flutter build ios --release
```

### Future Deployment Additions
- CI/CD pipeline (GitHub Actions)
- Supabase Edge Functions for server-side logic
- Firebase Cloud Messaging for push notifications
- App Store / Play Store deployment
- Supabase database migrations via CLI
