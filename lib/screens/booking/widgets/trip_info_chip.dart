import 'package:flutter/material.dart';

import '../../../models/trip.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../utils/formatters.dart';

/// Rappel du trajet : « Jeu. 8 oct. · 07:30 → 12:45 · Express Voyages ».
class TripInfoChip extends StatelessWidget {
  const TripInfoChip({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md - 4, vertical: AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_bus_outlined, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              '${Formatters.shortDate(trip.departure)} · ${Formatters.time(trip.departure)} → '
              '${Formatters.time(trip.arrival)} · ${trip.company}',
              style: AppTextStyles.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
