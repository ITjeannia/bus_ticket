import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Bandeau de message en haut d'écran.
/// - [AlertBanner.error] : rouge (identifiants incorrects, paiement refusé, billet expiré)
/// - [AlertBanner.info] : bleu (information)
/// - [AlertBanner.neutral] : gris (hors ligne)
class AlertBanner extends StatelessWidget {
  const AlertBanner.error(this.message, {super.key})
      : icon = Icons.error_outline,
        background = AppColors.errorSoft,
        iconColor = AppColors.error;

  const AlertBanner.info(this.message, {super.key})
      : icon = Icons.info_outline,
        background = AppColors.primarySoft,
        iconColor = AppColors.primary;

  const AlertBanner.neutral(this.message, {super.key, this.icon = Icons.download_outlined})
      : background = AppColors.surfaceMuted,
        iconColor = AppColors.textSecondary;

  final String message;
  final IconData icon;
  final Color background;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: AppSpacing.md - 4),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 14, height: 1.35, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
