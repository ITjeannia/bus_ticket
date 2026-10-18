import 'package:flutter/material.dart';

import '../../models/trip.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/formatters.dart';
import '../../widgets/primary_button.dart';
import 'widgets/seat_map.dart';
import 'widgets/seat_tile.dart';
import 'widgets/trip_info_chip.dart';

/// Maquette 05 — un siège par passager.
class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key, required this.trip, required this.passengers});

  final Trip trip;
  final int passengers;

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final _selected = <int>[];

  bool get _isComplete => _selected.length == widget.passengers;

  SeatStatus _statusOf(int seat) {
    if (widget.trip.bookedSeats.contains(seat)) return SeatStatus.booked;
    if (_selected.contains(seat)) return SeatStatus.selected;
    return SeatStatus.available;
  }

  void _toggle(int seat) {
    setState(() {
      if (_selected.remove(seat)) return;
      // Avec un seul passager, toucher un autre siège remplace le choix.
      if (widget.passengers == 1) _selected.clear();
      if (_selected.length == widget.passengers) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('Vous avez déjà choisi ${widget.passengers} sièges. Touchez un siège pour le libérer.'),
          ));
        return;
      }
      _selected.add(seat);
    });
  }

  void _continue() {
    Navigator.pushNamed(
      context,
      AppRoutes.payment,
      arguments: (trip: widget.trip, seats: List<int>.of(_selected)..sort()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedSeats = List<int>.of(_selected)..sort();
    final summary = _selected.isEmpty
        ? 'Choisissez ${widget.passengers > 1 ? '${widget.passengers} sièges' : 'un siège'}'
        : '${Formatters.seats(sortedSeats)} · ${Formatters.passengers(widget.passengers)}';

    return Scaffold(
      appBar: AppBar(title: const Text('Choisir un siège')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          TripInfoChip(trip: widget.trip),
          const SizedBox(height: AppSpacing.md),
          const SeatLegend(),
          const SizedBox(height: AppSpacing.md),
          SeatMap(
            totalSeats: widget.trip.totalSeats,
            statusOf: _statusOf,
            onSeatTap: _toggle,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(summary, style: AppTextStyles.caption),
                      Text(
                        Formatters.price(widget.trip.price * widget.passengers),
                        style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700, fontSize: 22),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 156,
                  child: PrimaryButton(label: 'Continuer', onPressed: _isComplete ? _continue : null),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
