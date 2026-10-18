import 'package:flutter/material.dart';

import '../../data/booking_repository.dart';
import '../../models/booking.dart';
import '../../routes/app_routes.dart';
import '../../routes/main_tabs.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/alert_banner.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/segmented_tabs.dart';
import 'widgets/ticket_list_card.dart';

/// Onglet « Mes billets » — maquettes 07 et 07b.
class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  int _tab = 0; // 0 = à venir, 1 = passés

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg + AppSpacing.md),
            const Text('Mes billets', style: AppTextStyles.headline),
            const SizedBox(height: AppSpacing.md + 4),
            SegmentedTabs(
              labels: const ['À venir', 'Passés'],
              selectedIndex: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ValueListenableBuilder<List<Booking>>(
                valueListenable: BookingRepository.instance.bookings,
                builder: (context, _, _) {
                  final repo = BookingRepository.instance;
                  final bookings = _tab == 0 ? repo.upcoming : repo.past;
                  return bookings.isEmpty ? _buildEmpty() : _buildList(bookings);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Booking> bookings) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      children: [
        if (_tab == 0) ...[
          const AlertBanner.info('Les billets restent consultables sans connexion internet.'),
          const SizedBox(height: AppSpacing.md),
        ],
        for (final booking in bookings) ...[
          TicketListCard(
            booking: booking,
            onTap: () => Navigator.pushNamed(context, AppRoutes.ticket, arguments: booking),
          ),
          const SizedBox(height: AppSpacing.md - 4),
        ],
      ],
    );
  }

  Widget _buildEmpty() {
    final upcoming = _tab == 0;
    return Center(
      child: SingleChildScrollView(
        child: EmptyState(
          icon: Icons.confirmation_number_outlined,
          title: upcoming ? 'Aucun billet à venir' : 'Aucun billet passé',
          message: upcoming
              ? 'Réservez votre prochain trajet en quelques étapes. Vos billets apparaîtront ici, même hors connexion.'
              : 'Vos trajets effectués apparaîtront ici.',
          action: upcoming
              ? PrimaryButton(
                  label: 'Rechercher un trajet',
                  onPressed: () => MainTabs.current.value = MainTabs.search,
                )
              : null,
        ),
      ),
    );
  }
}
