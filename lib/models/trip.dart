/// Un trajet proposé par une compagnie.
class Trip {
  const Trip({
    required this.id,
    required this.company,
    required this.from,
    required this.to,
    required this.departure,
    required this.arrival,
    required this.price,
    this.stops = 0,
    this.totalSeats = 28,
    this.bookedSeats = const [],
  });

  final String id;
  final String company;
  final String from;
  final String to;
  final DateTime departure;
  final DateTime arrival;

  /// Prix d'une place, en FCFA.
  final int price;

  /// Nombre d'arrêts intermédiaires (0 = direct).
  final int stops;
  final int totalSeats;

  /// Numéros des sièges déjà réservés (commencent à 1).
  final List<int> bookedSeats;

  Duration get duration => arrival.difference(departure);
  int get availableSeats => totalSeats - bookedSeats.length;
  bool get isFull => availableSeats <= 0;
  String get route => '$from → $to';
  String get stopsLabel => switch (stops) {
        0 => 'Direct',
        1 => '1 arrêt',
        _ => '$stops arrêts',
      };
}
