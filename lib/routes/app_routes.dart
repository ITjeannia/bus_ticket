import 'package:flutter/material.dart';

import '../models/booking.dart';
import '../models/search_query.dart';
import '../models/trip.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/booking/payment_screen.dart';
import '../screens/booking/seat_selection_screen.dart';
import '../screens/main_screen.dart';
import '../screens/search/search_results_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/tickets/ticket_screen.dart';

/// Noms de routes et construction des écrans.
/// Pour ajouter un écran : une constante ici + un cas dans [onGenerateRoute].
abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const main = '/main';
  static const searchResults = '/search-results';
  static const seatSelection = '/seat-selection';
  static const payment = '/payment';
  static const ticket = '/ticket';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    final Widget page = switch (settings.name) {
      login => const LoginScreen(),
      register => const RegisterScreen(),
      main => const MainScreen(),
      searchResults => SearchResultsScreen(query: args! as SearchQuery),
      seatSelection => switch (args) {
          (trip: final Trip trip, passengers: final int passengers) =>
            SeatSelectionScreen(trip: trip, passengers: passengers),
          _ => throw ArgumentError('seatSelection attend (trip, passengers)'),
        },
      payment => switch (args) {
          (trip: final Trip trip, seats: final List<int> seats) => PaymentScreen(trip: trip, seats: seats),
          _ => throw ArgumentError('payment attend (trip, seats)'),
        },
      ticket => TicketScreen(booking: args! as Booking),
      _ => const SplashScreen(),
    };

    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
