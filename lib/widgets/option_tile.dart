import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Choix exclusif sous forme de carte avec bouton radio (ex. moyen de paiement).
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.description,
    this.enabled = true,
  });

  final String label;
  final String? description;
  final IconData icon;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = selected && enabled;
    final foreground = enabled ? AppColors.textPrimary : AppColors.textDisabled;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: !enabled
              ? AppColors.surfaceMuted
              : (isActive ? AppColors.primarySoft : AppColors.surface),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
            width: isActive ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? AppColors.primary : (enabled ? AppColors.textPrimary : AppColors.textDisabled)),
            const SizedBox(width: AppSpacing.md + 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.subtitle.copyWith(color: foreground)),
                  if (description != null)
                    Text(
                      description!,
                      style: AppTextStyles.caption.copyWith(color: enabled ? null : AppColors.textDisabled),
                    ),
                ],
              ),
            ),
            Icon(
              isActive ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isActive ? AppColors.primary : AppColors.textSecondary.withValues(alpha: enabled ? 1 : 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
