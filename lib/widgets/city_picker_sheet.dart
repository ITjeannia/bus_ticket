import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Feuille du bas listant les villes. Utiliser [CityPickerSheet.show].
class CityPickerSheet extends StatelessWidget {
  const CityPickerSheet({super.key, required this.title, required this.cities, this.selected});

  final String title;
  final List<String> cities;
  final String? selected;

  /// Ouvre la feuille et renvoie la ville choisie (ou null si fermée).
  static Future<String?> show(
    BuildContext context, {
    required String title,
    required List<String> cities,
    String? selected,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (_) => CityPickerSheet(title: title, cities: cities, selected: selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(title, style: AppTextStyles.title),
          ),
          const SizedBox(height: AppSpacing.sm),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final city in cities)
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(city, style: AppTextStyles.body),
                    trailing: city == selected ? const Icon(Icons.check, color: AppColors.primary) : null,
                    onTap: () => Navigator.pop(context, city),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
