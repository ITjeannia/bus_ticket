import 'package:flutter/material.dart';

import 'app_routes.dart';

/// Onglets de la barre du bas, pilotables depuis n'importe quel écran.
abstract final class MainTabs {
  static const search = 0;
  static const tickets = 1;
  static const profile = 2;

  static final current = ValueNotifier<int>(search);

  /// Revient à l'écran principal et affiche l'onglet [tab].
  static void open(BuildContext context, int tab) {
    current.value = tab;
    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.main));
  }
}
