enum RideStatus {
  // Offer phase - ride created, waiting for driver acceptance
  pending('pending', 'Searching'),

  // Driver assigned to ride (accepted offer)
  driverAssigned('driverAssigned', 'Driver Assigned'),

  // Driver moving to pickup location
  driverArriving('driverArriving', 'On The Way'),

  // Driver reached pickup location, waiting for passenger
  driverArrived('driverArrived', 'Arrived'),

  // Waiting for passenger to board (same as arrived, UI state)
  waiting('driverArrived', 'Waiting'),

  // Ride in progress - passenger picked up, en route to destination
  inProgress('inProgress', 'In Progress'),

  // Ride completed
  completed('completed', 'Completed'),

  // Ride cancelled
  cancelled('cancelled', 'Cancelled');

  /// DB value for Supabase
  final String dbValue;

  /// UI-friendly display name
  final String displayName;

  const RideStatus(this.dbValue, this.displayName);

  @override
  String toString() => dbValue;

  /// Convert DB string value to RideStatus enum
  static RideStatus fromString(String? value) {
    if (value == null) return RideStatus.pending;
    return RideStatus.values.firstWhere(
      (e) => e.dbValue == value,
      orElse: () => RideStatus.pending,
    );
  }

  /// Alias for UI workflow (for backwards compatibility)
  static RideStatus fromDbValue(String? value) => RideStatus.fromString(value);

  /// Check if status allows driver to start ride
  bool get canStartRide =>
      this == RideStatus.driverArrived || this == RideStatus.waiting;

  /// Check if ride is active
  bool get isActive =>
      this == RideStatus.inProgress ||
      this == RideStatus.driverArriving ||
      this == RideStatus.driverArrived ||
      this == RideStatus.waiting;

  /// Check if ride is completed or cancelled
  bool get isFinal =>
      this == RideStatus.completed || this == RideStatus.cancelled;
}
