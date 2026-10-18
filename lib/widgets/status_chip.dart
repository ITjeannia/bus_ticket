import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Petite étiquette arrondie : « Valide », « Expiré », « Complet »…
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.foreground,
    required this.background,
    this.icon,
  });

  const StatusChip.valid({super.key})
      : label = 'Valide',
        icon = Icons.check_circle_outline,
        foreground = AppColors.success,
        background = AppColors.successSoft;

  const StatusChip.expired({super.key})
      : label = 'Expiré',
        icon = Icons.error_outline,
        foreground = AppColors.error,
        background = AppColors.errorSoft;

  const StatusChip.neutral(this.label, {super.key, this.icon})
      : foreground = AppColors.textSecondary,
        background = AppColors.surfaceMuted;

  final String label;
  final IconData? icon;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: foreground),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: foreground)),
        ],
      ),
    );
  }
}
