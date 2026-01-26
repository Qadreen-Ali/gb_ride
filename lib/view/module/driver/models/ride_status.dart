enum RideStatus {
  searching, // Ride created, waiting for driver / offer phase
  onTheWay, // Driver accepted and moving to pickup
  arrived, // Driver reached pickup location
  waiting, // Waiting for rider (timer starts)
  ongoing, // Ride started
  completed, // Ride finished
  cancelled, // Ride cancelled by driver or rider
}
