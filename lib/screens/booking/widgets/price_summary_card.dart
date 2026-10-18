import 'package:flutter/material.dart';

import '../../../models/trip.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/info_row.dart';

/// Récapitulatif du trajet et détail du prix (écran de paiement).
class PriceSummaryCard extends StatelessWidget {
  const PriceSummaryCard({super.key, required this.trip, required this.seats, required this.serviceFee});

  final Trip trip;
  final List<int> seats;
  final int serviceFee;

  int get total => trip.price * seats.length + serviceFee;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(trip.route, style: AppTextStyles.subtitle),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${Formatters.shortDate(trip.departure)} · ${Formatters.time(trip.departure)} – '
            '${Formatters.time(trip.arrival)} · ${Formatters.seats(seats)}',
            style: AppTextStyles.caption,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm + 4),
            child: Divider(color: AppColors.disabled),
          ),
          InfoRow(
            label: 'Billet (${Formatters.adults(seats.length)})',
            value: Formatters.price(trip.price * seats.length),
          ),
          InfoRow(label: 'Frais de service', value: Formatters.price(serviceFee)),
          InfoRow(
            label: 'Total',
            value: Formatters.price(total),
            valueStyle: AppTextStyles.title.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
