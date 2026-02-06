# SUPABASE DATABASE TABLES - REQUIRED SQL SETUP

## Overview
This document contains all SQL required for the local/rider module integration with Supabase. Execute these queries in your Supabase Dashboard → SQL Editor.

---

## TABLE 1: RIDER PROFILES

**Purpose**: Store rider-specific data (separate from users table)
**Status**: Required for local module

```sql
CREATE TABLE IF NOT EXISTS rider_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  total_rides INT DEFAULT 0,
  rating FLOAT DEFAULT 0.0,
  is_verified BOOLEAN DEFAULT FALSE,
  saved_addresses TEXT[] DEFAULT '{}',
  preferred_payment_method VARCHAR(100),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id)
);

-- Create index for faster queries
CREATE INDEX idx_rider_profiles_user_id ON rider_profiles(user_id);

-- Enable RLS
ALTER TABLE rider_profiles ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can view their own rider profile
CREATE POLICY "Users can view own rider profile"
  ON rider_profiles
  FOR SELECT
  USING (auth.uid() = user_id);

-- RLS Policy: Users can update their own rider profile
CREATE POLICY "Users can update own rider profile"
  ON rider_profiles
  FOR UPDATE
  USING (auth.uid() = user_id);

-- RLS Policy: Users can insert their own rider profile
CREATE POLICY "Users can insert own rider profile"
  ON rider_profiles
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);
```

---

## TABLE 2: SAVED ADDRESSES

**Purpose**: Store frequently used pickup/destination addresses for riders
**Status**: Required for local module

```sql
CREATE TABLE IF NOT EXISTS saved_addresses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,  -- 'Home', 'Work', 'Airport', 'Gym', etc.
  latitude FLOAT NOT NULL,
  longitude FLOAT NOT NULL,
  address VARCHAR(255) NOT NULL,  -- Full address string
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, name)  -- One 'Home', one 'Work', etc. per user
);

-- Create indexes for faster queries
CREATE INDEX idx_saved_addresses_user_id ON saved_addresses(user_id);
CREATE INDEX idx_saved_addresses_name ON saved_addresses(user_id, name);

-- Enable RLS
ALTER TABLE saved_addresses ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can view their own saved addresses
CREATE POLICY "Users can view own saved addresses"
  ON saved_addresses
  FOR SELECT
  USING (auth.uid() = user_id);

-- RLS Policy: Users can insert their own saved addresses
CREATE POLICY "Users can insert own saved addresses"
  ON saved_addresses
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- RLS Policy: Users can update their own saved addresses
CREATE POLICY "Users can update own saved addresses"
  ON saved_addresses
  FOR UPDATE
  USING (auth.uid() = user_id);

-- RLS Policy: Users can delete their own saved addresses
CREATE POLICY "Users can delete own saved addresses"
  ON saved_addresses
  FOR DELETE
  USING (auth.uid() = user_id);
```

---

## TABLE 3: PAYMENT METHODS

**Purpose**: Store saved payment methods for quick checkout
**Status**: Required for local module (payment integration)

```sql
CREATE TABLE IF NOT EXISTS payment_methods (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL,  -- 'card', 'wallet', 'bank_transfer', 'cash'
  card_last4 VARCHAR(4),      -- Only store last 4 digits for security
  card_brand VARCHAR(50),     -- 'visa', 'mastercard', 'amex'
  bank_name VARCHAR(100),     -- For bank transfers
  is_default BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Create indexes
CREATE INDEX idx_payment_methods_user_id ON payment_methods(user_id);
CREATE INDEX idx_payment_methods_default ON payment_methods(user_id, is_default);

-- Enable RLS
ALTER TABLE payment_methods ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can view their own payment methods
CREATE POLICY "Users can view own payment methods"
  ON payment_methods
  FOR SELECT
  USING (auth.uid() = user_id);

-- RLS Policy: Users can insert their own payment methods
CREATE POLICY "Users can insert own payment methods"
  ON payment_methods
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- RLS Policy: Users can update their own payment methods
CREATE POLICY "Users can update own payment methods"
  ON payment_methods
  FOR UPDATE
  USING (auth.uid() = user_id);

-- RLS Policy: Users can delete their own payment methods
CREATE POLICY "Users can delete own payment methods"
  ON payment_methods
  FOR DELETE
  USING (auth.uid() = user_id);
```

---

## TABLE 4: RIDES (ALREADY EXISTS - NO CHANGES)

**Purpose**: Store all ride data (used by both drivers and riders)
**Status**: ✅ Already created in previous session

```sql
-- This table already exists in your Supabase
-- It supports:
-- 1. Riders creating requests with status='pending'
-- 2. Drivers fetching pending rides by vehicle type
-- 3. Both tracking rides in real-time

-- Verify with:
SELECT * FROM rides LIMIT 1;

-- Key fields for local module:
-- - rider_id: UUID of rider requesting
-- - driver_id: UUID of driver accepting (initially NULL)
-- - status: 'pending' → 'driverAssigned' → 'driverArrived' → 'rideStarted' → 'completed'
-- - pickup_location: JSONB {latitude, longitude, address}
-- - destination_location: JSONB {latitude, longitude, address}
-- - vehicle_type: 'bike', 'car', 'auto'
-- - offered_fare: double (what rider is willing to pay)
-- - accepted_fare: double (what driver accepts or rider is charged)
-- - created_at: TIMESTAMPTZ
```

---

## TABLE 5: NOTIFICATIONS (ALREADY EXISTS - NO CHANGES)

**Purpose**: Notifications for both riders and drivers
**Status**: ✅ Already created in previous session

```sql
-- This table already exists in your Supabase
-- Used by local (rider) module for:
-- - Ride accepted: 'Driver accepted your ride'
-- - Driver arriving: 'Driver is 5 minutes away'
-- - Ride completed: 'Trip completed. Rate your driver?'
-- - Payment received: 'Payment of PKR X received'

-- Verify with:
SELECT * FROM notifications LIMIT 1;

-- Key fields:
-- - user_id: UUID of notification recipient
-- - type: 'ride_accepted', 'driver_arriving', 'ride_completed', 'payment_received', 'system'
-- - title: Short title
-- - message: Full message
-- - ride_id: FK to rides (NULL for system notifications)
-- - is_read: BOOLEAN
-- - created_at: TIMESTAMPTZ
```

---

## EXECUTION INSTRUCTIONS

### Step 1: Open Supabase Dashboard
1. Go to https://supabase.com
2. Login to your project
3. Navigate to **SQL Editor** (left sidebar)

### Step 2: Create Tables
1. Create new query
2. Copy and paste TABLE 1 SQL (RIDER PROFILES)
3. Click "Execute"
4. Repeat for TABLE 2 (SAVED ADDRESSES) and TABLE 3 (PAYMENT METHODS)

### Step 3: Verify Tables Created
```sql
-- Check all tables
SELECT tablename FROM pg_tables WHERE schemaname = 'public';

-- Should see:
-- rider_profiles
-- saved_addresses  
-- payment_methods
-- rides (already exists)
-- notifications (already exists)
```

### Step 4: Test Insert
```sql
-- Test rider_profiles insert (replace UUID)
INSERT INTO rider_profiles (user_id, total_rides, rating, is_verified)
VALUES ('12345678-1234-1234-1234-123456789012', 0, 0.0, false);

-- Test saved_addresses insert
INSERT INTO saved_addresses (user_id, name, latitude, longitude, address)
VALUES ('12345678-1234-1234-1234-123456789012', 'Home', 33.6844, 73.0479, '123 Main St, Lahore');

-- Test payment_methods insert
INSERT INTO payment_methods (user_id, type, is_default)
VALUES ('12345678-1234-1234-1234-123456789012', 'cash', true);
```

---

## SUMMARY OF NEW MODELS & SERVICES

### New Models (lib/models/)
1. **rider_profile_model.dart** - RiderProfileModel class
2. **saved_address_model.dart** - SavedAddressModel class
3. **payment_method_model.dart** - PaymentMethodModel class

### Enhanced Services (lib/services/)
1. **supabase_service.dart** - Added:
   - `createOrUpdateRiderProfile()`
   - `fetchSavedAddresses()`
   - `addSavedAddress()`, `deleteSavedAddress()`
   - `fetchPaymentMethods()`, `addPaymentMethod()`, `setDefaultPaymentMethod()`, `deletePaymentMethod()`

2. **rider_service.dart** (NEW) - High-level operations:
   - Ride creation, cancellation, history, tracking
   - Rider profile initialization & preferences
   - Saved addresses CRUD
   - Payment methods CRUD
   - Notifications

### Local Module Integration (Ready for Next Step)
1. **lib/view/module/local/auth/local_form.dart** - Will call `initializeRiderProfile()`
2. **lib/view/module/local/home/home_bottom_sheet.dart** - Will call `createRideRequest()`
3. **lib/view/module/local/notifications/** - Will use `fetchNotifications()`
4. **lib/view/module/local/setting/** - Will use saved addresses and payment methods

---

## VERIFICATION CHECKLIST

- [ ] Created `rider_profiles` table with RLS policies
- [ ] Created `saved_addresses` table with RLS policies
- [ ] Created `payment_methods` table with RLS policies
- [ ] All indexes created for performance
- [ ] Verified tables appear in "Tables" section
- [ ] Test inserts work without errors
- [ ] RLS policies allow auth.uid() access
- [ ] Models compile without errors
- [ ] Services have all required methods
- [ ] Ready for local module screen integration

---

## NEXT STEPS

1. Execute SQL in Supabase Dashboard
2. Verify all tables created with `SELECT * FROM pg_tables...`
3. Test insert/update/delete operations
4. Begin integrating RiderService into local module screens:
   - local_form.dart → initialize rider profile
   - home_bottom_sheet.dart → create ride request
   - notification_screen.dart → fetch & display notifications
   - setting_screen.dart → manage saved addresses & payment methods
