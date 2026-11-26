enum TripStatus {
  upcoming('Upcoming'),
  ongoing('Now'),
  past('Past');

  const TripStatus(this.label);
  final String label;
}
