import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import 'seat_tile.dart';

/// Plan du bus : rangées de 2 sièges + allée + 2 sièges.
class SeatMap extends StatelessWidget {
  const SeatMap({
    super.key,
    required this.totalSeats,
    required this.statusOf,
    required this.onSeatTap,
  });

  static const seatsPerRow = 4;

  final int totalSeats;
  final SeatStatus Function(int seat) statusOf;
  final ValueChanged<int> onSeatTap;

  @override
  Widget build(BuildContext context) {
    final rows = (totalSeats / seatsPerRow).ceil();

    Widget seat(int number) => number > totalSeats
        ? const SizedBox(width: 44)
        : SeatTile(number: number, status: statusOf(number), onTap: () => onSeatTap(number));

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(child: Text('Avant du bus', style: AppTextStyles.caption)),
              Icon(Icons.directions_bus_outlined, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (var r = 0; r < rows; r++)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  seat(r * seatsPerRow + 1),
                  const SizedBox(width: AppSpacing.sm),
                  seat(r * seatsPerRow + 2),
                  const SizedBox(width: 40), // allée
                  seat(r * seatsPerRow + 3),
                  const SizedBox(width: AppSpacing.sm),
                  seat(r * seatsPerRow + 4),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Légende : Libre · Votre siège · Occupé.
class SeatLegend extends StatelessWidget {
  const SeatLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        for (final (status, label) in const [
          (SeatStatus.available, 'Libre'),
          (SeatStatus.selected, 'Votre siège'),
          (SeatStatus.booked, 'Occupé'),
        ])
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LegendBox(status: status),
              const SizedBox(width: AppSpacing.sm),
              Text(label, style: AppTextStyles.caption),
            ],
          ),
      ],
    );
  }
}

class _LegendBox extends StatelessWidget {
  const _LegendBox({required this.status});

  final SeatStatus status;

  @override
  Widget build(BuildContext context) {
    final (background, border) = SeatTile.colorsOf(status);
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: border),
      ),
      child: status == SeatStatus.booked
          ? const Icon(Icons.close, size: 12, color: AppColors.textSecondary)
          : null,
    );
  }
}
