import 'package:flutter/material.dart';

import '../../../data/search_history.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/empty_state.dart';

/// Section « Recherches récentes » (ou son état vide).
class RecentSearches extends StatelessWidget {
  const RecentSearches({super.key, required this.onSelected});

  final void Function(String from, String to) onSelected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<(String, String)>>(
      valueListenable: SearchHistory.instance.recent,
      builder: (context, recent, _) {
        if (recent.isEmpty) {
          return const EmptyState(
            icon: Icons.schedule,
            iconSize: 64,
            title: 'Aucune recherche récente',
            message: 'Vos derniers trajets apparaîtront ici pour les retrouver en un geste.',
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recherches récentes', style: AppTextStyles.title),
            const SizedBox(height: 4),
            for (final (from, to) in recent)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule, color: AppColors.textSecondary),
                title: Text('$from → $to', style: AppTextStyles.body),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                onTap: () => onSelected(from, to),
              ),
          ],
        );
      },
    );
  }
}
