import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/booking.dart';
import '../models/payment_method.dart';
import '../models/trip.dart';
import 'app_exception.dart';
import 'mock_data.dart';

/// Billets de l'utilisateur et paiement (simulé).
/// Les écrans écoutent [bookings] pour se mettre à jour automatiquement.
class BookingRepository {
  BookingRepository._();

  static final instance = BookingRepository._();

  final bookings = ValueNotifier<List<Booking>>(MockData.initialBookings());

  List<Booking> get upcoming => bookings.value.where((b) => !b.isExpired).toList();
  List<Booking> get past => bookings.value.where((b) => b.isExpired).toList();

  /// Règle de démo : un numéro qui se termine par « 000 » est refusé.
  Future<Booking> pay({
    required Trip trip,
    required List<int> seats,
    required String passengerName,
    required PaymentMethod method,
    required String accountNumber,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (accountNumber.replaceAll(RegExp(r'\D'), '').endsWith('000')) {
      throw const AppException('Solde insuffisant ou paiement non validé');
    }
    final booking = Booking(
      reference: 'BT-${10000 + Random().nextInt(90000)}',
      trip: trip,
      seats: seats,
      passengerName: passengerName,
      paymentMethod: method,
      serviceFee: MockData.serviceFee,
    );
    bookings.value = [booking, ...bookings.value];
    return booking;
  }
}
