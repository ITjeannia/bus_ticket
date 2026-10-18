import 'package:flutter/material.dart';

import '../../data/auth_service.dart';
import '../../data/mock_data.dart';
import '../../data/search_history.dart';
import '../../models/search_query.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_select_field.dart';
import '../../widgets/city_picker_sheet.dart';
import '../../widgets/primary_button.dart';
import 'widgets/passengers_sheet.dart';
import 'widgets/recent_searches.dart';

/// Onglet « Rechercher » — maquettes 03 et 03b.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _from;
  String? _to;
  DateTime _date = DateTime.now();
  int _passengers = 1;

  bool get _sameCity => _from != null && _from == _to;
  bool get _canSearch => _from != null && _to != null && !_sameCity;

  Future<void> _pickCity({required bool isFrom}) async {
    final city = await CityPickerSheet.show(
      context,
      title: isFrom ? 'Ville de départ' : "Ville d'arrivée",
      cities: MockData.cities,
      selected: isFrom ? _from : _to,
    );
    if (city == null) return;
    setState(() => isFrom ? _from = city : _to = city);
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: today,
      lastDate: today.add(const Duration(days: 90)),
    );
    if (date != null) setState(() => _date = date);
  }

  Future<void> _pickPassengers() async {
    final count = await PassengersSheet.show(context, initialValue: _passengers);
    if (count != null) setState(() => _passengers = count);
  }

  void _swapCities() => setState(() {
        final from = _from;
        _from = _to;
        _to = from;
      });

  void _search() {
    SearchHistory.instance.add(_from!, _to!);
    Navigator.pushNamed(
      context,
      AppRoutes.searchResults,
      arguments: SearchQuery(from: _from!, to: _to!, date: _date, passengers: _passengers),
    );
  }

  void _searchRecent(String from, String to) {
    setState(() {
      _from = from;
      _to = to;
    });
    _search();
  }

  @override
  Widget build(BuildContext context) {
    final firstName = AuthService.instance.currentUser.value?.firstName ?? '';

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text('Bonjour $firstName', style: AppTextStyles.headline),
          const SizedBox(height: AppSpacing.sm),
          const Text("Où allez-vous aujourd'hui ?", style: AppTextStyles.bodySecondary),
          const SizedBox(height: AppSpacing.lg),
          _buildForm(),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(label: 'Rechercher', onPressed: _canSearch ? _search : null),
          const SizedBox(height: AppSpacing.lg + 8),
          RecentSearches(onSelected: _searchRecent),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  AppSelectField(
                    label: 'Départ',
                    icon: Icons.location_on_outlined,
                    hint: 'Ville de départ',
                    value: _from,
                    onTap: () => _pickCity(isFrom: true),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppSelectField(
                    label: 'Arrivée',
                    icon: Icons.location_on_outlined,
                    hint: "Ville d'arrivée",
                    value: _to,
                    errorText: _sameCity ? 'Choisissez une ville différente du départ' : null,
                    onTap: () => _pickCity(isFrom: false),
                  ),
                ],
              ),
              Positioned(
                right: AppSpacing.md,
                top: 54,
                child: _SwapButton(onPressed: _swapCities),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppSelectField(
                  label: 'Date',
                  icon: Icons.calendar_today_outlined,
                  value: Formatters.shortDate(_date),
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(width: AppSpacing.sm + 4),
              Expanded(
                child: AppSelectField(
                  label: 'Passagers',
                  icon: Icons.people_outline,
                  value: Formatters.adults(_passengers),
                  onTap: _pickPassengers,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bouton rond qui inverse départ et arrivée.
class _SwapButton extends StatelessWidget {
  const _SwapButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
      child: IconButton(
        tooltip: 'Inverser départ et arrivée',
        onPressed: onPressed,
        icon: const Icon(Icons.swap_vert, color: AppColors.primary),
      ),
    );
  }
}
