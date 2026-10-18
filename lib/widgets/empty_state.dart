import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Icône dans un rond gris + titre + explication + action facultative.
/// Utilisé pour les listes vides et les erreurs de chargement.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.iconSize = 96,
  });

  final IconData icon;
  final String title;
  final String message;

  /// Bouton affiché sous le message (ex. « Réessayer »).
  final Widget? action;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: const BoxDecoration(color: AppColors.surfaceMuted, shape: BoxShape.circle),
            child: Icon(icon, size: iconSize * 0.4, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md + 4),
          Text(title, style: AppTextStyles.subtitle, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm + 4),
          Text(message, style: AppTextStyles.bodySecondary, textAlign: TextAlign.center),
          if (action != null) ...[
            const SizedBox(height: AppSpacing.md + 4),
            action!,
          ],
        ],
      ),
    );
  }
}
