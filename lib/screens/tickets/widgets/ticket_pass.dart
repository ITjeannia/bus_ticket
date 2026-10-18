import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../models/booking.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/dashed_divider.dart';

/// Le billet lui-même : en-tête du trajet, informations, QR code.
/// Grisé (code désactivé) quand le billet a expiré.
class TicketPass extends StatelessWidget {
  const TicketPass({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final trip = booking.trip;
    final expired = booking.isExpired;
    final headerText = expired ? AppColors.textPrimary : AppColors.textOnPrimary;
    final qrColor = expired ? AppColors.disabled : AppColors.textPrimary;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: expired ? AppColors.disabled : AppColors.primary,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.route,
                  style: AppTextStyles.title.copyWith(color: headerText, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${Formatters.longDate(trip.departure)} · ${Formatters.time(trip.departure)} – '
                  '${Formatters.time(trip.arrival)}',
                  style: TextStyle(fontSize: 14, color: headerText),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Row(
                  children: [
                    _Field(label: 'Passager', value: booking.passengerName),
                    _Field(label: 'Compagnie', value: trip.company),
                  ],
                ),
                const SizedBox(height: AppSpacing.md - 4),
                Row(
                  children: [
                    _Field(label: booking.seats.length > 1 ? 'Sièges' : 'Siège', value: booking.seats.join(', ')),
                    _Field(label: 'Réservation', value: booking.reference),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const DashedDivider(),
                const SizedBox(height: AppSpacing.md),
                QrImageView(
                  data: booking.reference,
                  size: 170,
                  padding: EdgeInsets.zero,
                  eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: qrColor),
                  dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: qrColor),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  expired ? 'Code désactivé' : 'Présentez ce code au contrôleur',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 2),
          Text(value, style: AppTextStyles.subtitle),
        ],
      ),
    );
  }
}
