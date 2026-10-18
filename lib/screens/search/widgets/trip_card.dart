import 'package:flutter/material.dart';

import '../../../models/trip.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/status_chip.dart';

/// Carte d'un départ dans les résultats. Grisée et non cliquable si le bus est complet.
class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip, required this.onTap});

  final Trip trip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final full = trip.isFull;
    final strong = full ? AppColors.textSecondary : AppColors.textPrimary;
    final timeStyle = AppTextStyles.title.copyWith(fontWeight: FontWeight.w700, color: strong);

    return Material(
      color: full ? AppColors.surfaceMuted : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: full ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(Formatters.time(trip.departure), style: timeStyle),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Icon(Icons.chevron_right, size: 20, color: AppColors.textSecondary),
                  ),
                  Text(Formatters.time(trip.arrival), style: timeStyle),
                  const Spacer(),
                  Text(
                    full ? '—' : Formatters.price(trip.price),
                    style: timeStyle.copyWith(color: full ? AppColors.textSecondary : AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${trip.route} · ${Formatters.duration(trip.duration)} · ${trip.stopsLabel}',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: AppSpacing.sm + 4),
              Row(
                children: [
                  const Icon(Icons.directions_bus_outlined, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(trip.company, style: AppTextStyles.caption)),
                  if (full)
                    const StatusChip(
                      label: 'Complet',
                      foreground: AppColors.textPrimary,
                      background: AppColors.disabled,
                    )
                  else ...[
                    const Icon(Icons.people_outline, size: 18, color: AppColors.success),
                    const SizedBox(width: AppSpacing.xs + 2),
                    Text(
                      '${trip.availableSeats} places',
                      style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
