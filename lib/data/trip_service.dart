import '../models/trip.dart';
import 'app_exception.dart';
import 'mock_data.dart';

/// Recherche des trajets (simulée).
class TripService {
  TripService._();

  static final instance = TripService._();

  Future<List<Trip>> search(String from, String to, DateTime date) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (MockData.simulateNetworkError) {
      throw const AppException('Connexion impossible');
    }
    return MockData.tripsFor(from, to, date);
  }
}
