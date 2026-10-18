import 'payment_method.dart';
import 'trip.dart';

/// Une réservation payée : c'est ce qui est affiché comme billet.
class Booking {
  const Booking({
    required this.reference,
    required this.trip,
    required this.seats,
    required this.passengerName,
    required this.paymentMethod,
    required this.serviceFee,
  });

  final String reference;
  final Trip trip;
  final List<int> seats;
  final String passengerName;
  final PaymentMethod paymentMethod;
  final int serviceFee;

  int get total => trip.price * seats.length + serviceFee;

  /// Un billet expire à l'arrivée du bus.
  bool get isExpired => trip.arrival.isBefore(DateTime.now());
}
