import 'package:flutter/material.dart';

import '../routes/main_tabs.dart';
import '../widgets/app_bottom_nav.dart';
import 'profile/profile_screen.dart';
import 'search/search_screen.dart';
import 'tickets/my_tickets_screen.dart';

/// Conteneur des 3 onglets avec la barre de navigation du bas.
/// L'onglet affiché est piloté par [MainTabs.current].
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const _pages = [SearchScreen(), MyTicketsScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: MainTabs.current,
      builder: (context, index, _) => Scaffold(
        body: IndexedStack(index: index, children: _pages),
        bottomNavigationBar: AppBottomNav(
          currentIndex: index,
          onTap: (i) => MainTabs.current.value = i,
        ),
      ),
    );
  }
}
