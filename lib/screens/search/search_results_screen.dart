import 'package:flutter/material.dart';

import '../../data/trip_service.dart';
import '../../models/search_query.dart';
import '../../models/trip.dart';
import '../../routes/app_routes.dart';
import '../../routes/main_tabs.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/formatters.dart';
import '../../widgets/alert_banner.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/segmented_tabs.dart';
import '../../widgets/skeleton_card.dart';
import 'widgets/trip_card.dart';

/// Maquettes 04 (liste), 04b (chargement), 04c (aucun trajet), 04d (erreur réseau).
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key, required this.query});

  final SearchQuery query;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late SearchQuery _query = widget.query;
  late Future<List<Trip>> _trips = _load();

  Future<List<Trip>> _load() => TripService.instance.search(_query.from, _query.to, _query.date);

  void _selectDate(DateTime date) => setState(() {
        _query = _query.copyWith(date: date);
        _trips = _load();
      });

  void _retry() => setState(() => _trips = _load());

  /// Trois jours affichés : la veille, le jour choisi et le lendemain (jamais avant aujourd'hui).
  List<DateTime> get _days {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(_query.date.year, _query.date.month, _query.date.day);
    final previous = selected.subtract(const Duration(days: 1));
    final start = previous.isBefore(today) ? today : previous;
    return [for (var i = 0; i < 3; i++) start.add(Duration(days: i))];
  }

  @override
  Widget build(BuildContext context) {
    final days = _days;
    final selectedIndex = days.indexWhere((d) => d.day == _query.date.day && d.month == _query.date.month);

    return Scaffold(
      appBar: AppBar(title: Text(_query.route)),
      bottomNavigationBar: AppBottomNav(
        currentIndex: MainTabs.search,
        onTap: (tab) => MainTabs.open(context, tab),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            SegmentedTabs(
              labels: [for (final d in days) Formatters.dayChip(d)],
              selectedIndex: selectedIndex,
              onChanged: (i) => _selectDate(days[i]),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: FutureBuilder<List<Trip>>(
                future: _trips,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) return const _LoadingView();
                  if (snapshot.hasError) return _ErrorView(onRetry: _retry);
                  final trips = snapshot.data!;
                  if (trips.isEmpty) return _buildEmpty();
                  return _buildList(trips);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Trip> trips) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      itemCount: trips.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md - 4),
      itemBuilder: (context, i) {
        if (i == 0) {
          return Text(
            '${trips.length} départs · ${Formatters.passengers(_query.passengers)}',
            style: AppTextStyles.caption,
          );
        }
        final trip = trips[i - 1];
        return TripCard(
          trip: trip,
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.seatSelection,
            arguments: (trip: trip, passengers: _query.passengers),
          ),
        );
      },
    );
  }

  Widget _buildEmpty() {
    final nextDay = _query.date.add(const Duration(days: 1));
    return Center(
      child: SingleChildScrollView(
        child: EmptyState(
          icon: Icons.directions_bus_outlined,
          title: 'Aucun départ ce jour',
          message: 'Aucun bus ne circule entre ${_query.from} et ${_query.to} le '
              '${Formatters.dayName(_query.date)}. Essayez une autre date.',
          action: OutlinedButton(
            onPressed: () => _selectDate(nextDay),
            child: Text('Voir le ${Formatters.dayName(nextDay)}'),
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const Text('Recherche des départs disponibles…', style: AppTextStyles.caption),
        for (var i = 0; i < 4; i++) ...[
          const SizedBox(height: AppSpacing.md - 4),
          const SkeletonCard(),
        ],
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AlertBanner.neutral('Vous êtes hors ligne. Les données affichées peuvent ne pas être à jour.'),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: EmptyState(
                icon: Icons.download_outlined,
                title: 'Connexion impossible',
                message: "Nous n'avons pas pu charger les horaires. Vérifiez votre connexion puis réessayez.",
                action: PrimaryButton(label: 'Réessayer', onPressed: onRetry),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
