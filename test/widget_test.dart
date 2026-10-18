import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bus_ticket/app.dart';
import 'package:bus_ticket/data/mock_data.dart';
import 'package:bus_ticket/screens/auth/login_screen.dart';
import 'package:bus_ticket/screens/booking/seat_selection_screen.dart';
import 'package:bus_ticket/screens/splash_screen.dart';
import 'package:bus_ticket/theme/app_theme.dart';
import 'package:bus_ticket/utils/formatters.dart';
import 'package:bus_ticket/utils/validators.dart';

void main() {
  setUp(() {
    // Écran de 360 × 800 comme la maquette.
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 3;
  });

  testWidgets('Le splash mène à la connexion', (tester) async {
    await tester.pumpWidget(const BusTicketApp());
    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(SplashScreen.duration);
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Bon retour !'), findsOneWidget);
  });

  testWidgets('Connexion refusée : bandeau d\'erreur et champ en rouge', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: const LoginScreen()));
    await tester.enterText(find.byType(TextField).at(0), 'jean.dupont@mail.com');
    await tester.enterText(find.byType(TextField).at(1), 'court');
    await tester.tap(find.text('Se connecter'));
    await tester.pump();
    expect(find.text('Connexion…'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.textContaining('Il vous reste 2 essais'), findsOneWidget);
    expect(find.text('Mot de passe incorrect'), findsOneWidget);
  });

  testWidgets('Choix du siège : « Continuer » s\'active après un choix', (tester) async {
    final trip = MockData.tripsFor('Douala', 'Yaoundé', DateTime(2026, 10, 8)).first;

    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light,
      home: SeatSelectionScreen(trip: trip, passengers: 1),
    ));
    final continueButton = find.widgetWithText(ElevatedButton, 'Continuer');
    expect(tester.widget<ElevatedButton>(continueButton).onPressed, isNull);

    await tester.tap(find.text('12'));
    await tester.pump();
    expect(find.text('Siège 12 · 1 passager'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(continueButton).onPressed, isNotNull);
  });

  test('Formatage', () {
    expect(Formatters.price(8700), '8 700 FCFA');
    expect(Formatters.shortDate(DateTime(2026, 10, 8)), 'Jeu. 8 oct.');
    expect(Formatters.longDate(DateTime(2026, 10, 8)), 'Jeudi 8 octobre 2026');
    expect(Formatters.duration(const Duration(hours: 5, minutes: 15)), '5 h 15');
    expect(Formatters.seats([3, 4]), 'Sièges 3, 4');
  });

  test('Validation du mot de passe', () {
    expect(Validators.password('abcdefgh'), isNotNull);
    expect(Validators.password('abcdefg1'), isNull);
  });
}
