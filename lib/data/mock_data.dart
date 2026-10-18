import '../models/booking.dart';
import '../models/payment_method.dart';
import '../models/trip.dart';
import '../models/user.dart';

/// Données fictives utilisées tant qu'il n'y a pas de serveur (API).
/// Pour brancher une vraie API, modifier les services de `lib/data/`
/// sans toucher aux écrans.
abstract final class MockData {
  /// Mettre à true pour voir l'écran « Connexion impossible ».
  static bool simulateNetworkError = false;

  static const serviceFee = 200;

  static const demoUser = User(
    fullName: 'Jean Dupont',
    email: 'jean.dupont@mail.com',
    phone: '+237 6 90 12 34 56',
  );

  static const cities = [
    'Douala',
    'Yaoundé',
    'Bafoussam',
    'Kribi',
    'Limbé',
    'Bamenda',
    'Garoua',
    'Ngaoundéré',
  ];

  // (compagnie, départ h, départ min, durée min, prix, arrêts, sièges occupés)
  static final _schedules = [
    ('Express Voyages', 7, 30, 315, 8500, 0, [1, 2, 5, 6, 7, 10, 13, 14, 17, 22, 25, 26]),
    ('Général Express', 9, 0, 310, 9000, 0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]),
    ('Touristique Express', 11, 30, 320, 8500, 0, [for (var i = 1; i <= 28; i++) i]),
    ('Buca Voyages', 14, 0, 320, 8000, 1, [3, 4, 9, 10, 15, 16, 27, 28]),
  ];

  /// Trajets d'une journée. Aucun départ le dimanche (pour l'état « vide »).
  static List<Trip> tripsFor(String from, String to, DateTime date) {
    if (date.weekday == DateTime.sunday) return [];
    final day = DateTime(date.year, date.month, date.day);
    return [
      for (final (company, h, m, minutes, price, stops, booked) in _schedules)
        Trip(
          id: '$from-$to-${day.toIso8601String()}-$company',
          company: company,
          from: from,
          to: to,
          departure: day.add(Duration(hours: h, minutes: m)),
          arrival: day.add(Duration(hours: h, minutes: m + minutes)),
          price: price,
          stops: stops,
          bookedSeats: booked,
        ),
    ];
  }

  /// Billets déjà achetés au démarrage : un à venir, un passé.
  static List<Booking> initialBookings() {
    final now = DateTime.now();
    final upcoming = tripsFor('Yaoundé', 'Douala', _nextWeekday(now.add(const Duration(days: 4))))[0];
    final past = tripsFor('Douala', 'Yaoundé', _nextWeekday(now.subtract(const Duration(days: 10))))[0];
    return [
      Booking(
        reference: 'BT-52904',
        trip: upcoming,
        seats: const [7],
        passengerName: demoUser.fullName,
        paymentMethod: PaymentMethod.mobileMoney,
        serviceFee: serviceFee,
      ),
      Booking(
        reference: 'BT-48271',
        trip: past,
        seats: const [12],
        passengerName: demoUser.fullName,
        paymentMethod: PaymentMethod.mobileMoney,
        serviceFee: serviceFee,
      ),
    ];
  }

  static DateTime _nextWeekday(DateTime d) =>
      d.weekday == DateTime.sunday ? d.add(const Duration(days: 1)) : d;
}
