import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

enum SeatStatus { available, selected, booked }

/// Un siège dans le plan du bus. Occupé = gris avec une croix.
class SeatTile extends StatelessWidget {
  const SeatTile({super.key, required this.number, required this.status, this.onTap, this.size = 44});

  final int number;
  final SeatStatus status;
  final VoidCallback? onTap;
  final double size;

  /// Couleurs (fond, bordure) d'un siège selon son état — partagées avec la légende.
  static (Color, Color) colorsOf(SeatStatus status) => switch (status) {
        SeatStatus.available => (AppColors.surface, AppColors.border),
        SeatStatus.selected => (AppColors.primary, AppColors.primary),
        SeatStatus.booked => (AppColors.disabled, AppColors.disabled),
      };

  @override
  Widget build(BuildContext context) {
    final (background, border) = colorsOf(status);

    return Semantics(
      button: status != SeatStatus.booked,
      label: 'Siège $number${status == SeatStatus.booked ? ', occupé' : ''}',
      child: InkWell(
        onTap: status == SeatStatus.booked ? null : onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: border),
          ),
          child: status == SeatStatus.booked
              ? Icon(Icons.close, size: size * 0.4, color: AppColors.textSecondary)
              : Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: status == SeatStatus.selected ? AppColors.textOnPrimary : AppColors.textPrimary,
                  ),
                ),
        ),
      ),
    );
  }
}
