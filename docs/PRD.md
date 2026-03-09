# GB Ride — Product Requirements Document (PRD)

## 1. Product Overview

**GB Ride** is a ride-hailing mobile application designed specifically for the Gilgit-Baltistan region of Pakistan. It follows an **InDrive-style bidding model** where riders (called "Locals") set a base fare and drivers compete by sending fare offers. The rider then selects the best offer. This model empowers both parties with fare negotiation — unlike Uber's fixed-price accept/reject model.

The app serves two user types with separate modules:
- **Local (Rider)** — Requests rides, sets a base fare, reviews driver offers, accepts the best one.
- **Driver** — Goes online, sees nearby ride requests, sends fare offers (bids), and completes rides.

> A **Student** module exists in the codebase but is **abandoned** and not under active development.

## 2. Problem Statement

Gilgit-Baltistan lacks a modern, localized ride-hailing solution. Existing options (informal cabs, word-of-mouth) suffer from:
- **No fare transparency** — Riders and drivers negotiate blindly.
- **No real-time tracking** — No way to track driver arrival or ride progress.
- **Safety concerns** — No driver verification, no ride history.
- **Inefficiency** — No centralized system to match riders with nearby drivers.

GB Ride solves this by digitizing the ride experience with an InDrive-style bidding system that respects the local culture of negotiation.

## 3. Target Users

| User Type | Description |
|-----------|-------------|
| **Locals (Riders)** | Residents and tourists in Gilgit-Baltistan who need transportation. They set a base fare and choose from driver offers. |
| **Drivers** | Local vehicle owners who register on the platform, go online to receive ride requests, and compete by offering fares. |

### User Demographics
- **Region**: Gilgit-Baltistan, Pakistan (initially Gilgit city)
- **Age**: 18–55
- **Tech comfort**: Intermediate smartphone users
- **Language**: Urdu / English

## 4. Core Features

### 4.1 Authentication
- [x] Email-based magic link login (Supabase Auth)
- [x] OTP verification screen
- [x] Role-based registration (Local or Driver form)
- [x] Profile management (name, CNIC, phone, gender, address)
- [x] Soft delete account (`is_deleted` flag)

### 4.2 Local (Rider) Module
- [x] Map-based home screen (Mapbox tiles via FlutterMap)
- [x] Pickup and destination selection (search + map pin)
- [x] Vehicle type selection (Car, Bike, etc.)
- [x] Base fare input via custom fare bottom sheet
- [x] "Find a Driver" — creates ride request in Supabase
- [x] Real-time incoming offer cards from drivers
- [x] Fare adjustment while waiting (±5 PKR buttons)
- [x] Accept a driver's offer (assigns driver, sets fare)
- [x] Real-time ride status tracking (accepted → onWay → waiting → ongoing → completed)
- [x] Cancel ride (expires all pending offers)
- [x] Driver contact via WhatsApp (url_launcher)
- [x] Settings: Profile, Safety, Help & Support, Payment Methods, Ride History
- [x] Notifications screen

### 4.3 Driver Module
- [x] Map-based home screen
- [x] Online/Offline toggle (updates Supabase `is_online`)
- [x] GPS location broadcasting every 10 seconds
- [x] Real-time stream of nearby ride requests (status = `requested`)
- [x] View ride details (pickup, destination, distance, base fare)
- [x] Send fare offer (bid) on a ride request
- [x] Duplicate offer prevention
- [x] Real-time offer status tracking (pending → accepted/expired)
- [x] Ride flow: On Way → Arrived (Waiting) → Start Trip (Ongoing) → End Trip (Completed)
- [x] Settings: Profile, Wallet, Trips
- [x] App drawer navigation

### 4.4 InDrive Bidding Flow (Core Differentiator)
1. Local sets pickup, destination, vehicle type, and base fare → creates `rides` row.
2. All online drivers see the request in real-time.
3. Drivers send fare offers → creates `ride_offers` rows.
4. Local sees offer cards (driver name, photo, rating, fare, ETA).
5. Local accepts one offer → assigns driver to ride, expires other offers.
6. Both parties enter the ride flow with real-time status updates.

## 5. Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| **Real-time latency** | Ride requests and offers appear within 2 seconds |
| **GPS accuracy** | High accuracy, 10-second broadcast interval |
| **Offline handling** | Graceful degradation with error snackbars |
| **Platform support** | Android (primary), iOS (secondary) |
| **Authentication** | Supabase Auth with magic link (email OTP) |
| **Data persistence** | All ride/offer data in Supabase PostgreSQL |
| **State management** | GetX reactive streams with proper cleanup |
| **Min SDK** | Dart ≥3.9.0, Flutter latest stable |

## 6. Success Metrics

| Metric | MVP Target |
|--------|-----------|
| Successful ride completions | 50+ in first month |
| Average offer response time | < 30 seconds |
| App crash rate | < 1% |
| Driver signup count | 20+ drivers registered |
| Local signup count | 100+ riders registered |
| Ride cancellation rate | < 20% |

## 7. MVP Scope

The MVP focuses on the **core ride-hailing loop**:

### In Scope (MVP)
- Authentication (magic link)
- Local: Request ride → Receive offers → Accept offer → Track ride → Complete
- Driver: Go online → See requests → Send offer → Get accepted → Complete ride
- Real-time updates via Supabase streams
- GPS location tracking
- Basic profile management
- Ride history
- PKR-based fare system

### Out of Scope (MVP)
- In-app payments (cash only for MVP)
- Driver ratings and reviews system
- Ride fare estimation algorithm
- Push notifications (FCM)
- Admin dashboard
- Analytics and reporting
- Multi-language support
- Student module

## 8. Future Roadmap

### Phase 2 — Enhanced Experience
- Push notifications (Firebase Cloud Messaging)
- Driver rating & review system
- Ride fare suggestions based on distance
- Ride receipt generation
- In-app chat between rider and driver
- Favorite drivers feature

### Phase 3 — Monetization & Scale
- In-app payment integration (JazzCash, EasyPaisa)
- Commission system for platform revenue
- Admin web dashboard (Supabase + Next.js or Flutter Web)
- Driver earnings analytics
- Surge pricing algorithm
- Multi-city expansion (Skardu, Hunza, etc.)

### Phase 4 — Platform Maturity
- Student module reactivation (campus rides)
- Scheduled rides (book in advance)
- Ride sharing / carpooling
- Driver document verification workflow
- SOS / Emergency button
- Accessibility features
