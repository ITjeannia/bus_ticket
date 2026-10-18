import 'package:flutter/material.dart';

import '../../../models/booking.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/status_chip.dart';

/// Résumé d'un billet dans « Mes billets ».
class TicketListCard extends StatelessWidget {
  const TicketListCard({super.key, required this.booking, required this.onTap});

  final Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final trip = booking.trip;

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Icon(Icons.confirmation_number_outlined, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md - 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Formatters.shortDate(trip.departure)} · ${Formatters.time(trip.departure)}',
                      style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(child: Text(trip.route, style: AppTextStyles.subtitle)),
                        const SizedBox(width: AppSpacing.sm),
                        booking.isExpired ? const StatusChip.expired() : const StatusChip.valid(),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${Formatters.seats(booking.seats)} · ${trip.company}',
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
