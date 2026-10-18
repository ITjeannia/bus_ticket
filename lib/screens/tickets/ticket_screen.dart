import 'package:flutter/material.dart';

import '../../models/booking.dart';
import '../../theme/app_spacing.dart';
import '../../utils/formatters.dart';
import '../../widgets/alert_banner.dart';
import '../../widgets/status_chip.dart';
import 'widgets/ticket_pass.dart';

/// Maquettes 08 (billet valide avec QR code) et 08b (billet expiré).
class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final arrival = booking.trip.arrival;

    return Scaffold(
      appBar: AppBar(title: const Text('Mon billet')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          if (booking.isExpired) ...[
            AlertBanner.error(
              'Ce billet a expiré le ${Formatters.dayMonth(arrival)} à ${Formatters.time(arrival)}. '
              'Il ne peut plus être présenté au contrôle.',
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          TicketPass(booking: booking),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.md - 4,
            runSpacing: AppSpacing.sm,
            children: booking.isExpired
                ? const [StatusChip.expired()]
                : const [
                    StatusChip.valid(),
                    StatusChip.neutral('Disponible hors ligne', icon: Icons.download_outlined),
                  ],
          ),
        ],
      ),
    );
  }
}
