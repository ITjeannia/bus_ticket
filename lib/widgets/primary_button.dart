import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Bouton principal pleine largeur. Le style vient du thème.
/// - [onPressed] null → bouton grisé.
/// - [isLoading] → indicateur + [loadingLabel], le bouton reste bleu mais n'est plus cliquable.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.loadingLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? loadingLabel;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: ElevatedButton(
        onPressed: isLoading ? () {} : onPressed,
        child: isLoading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.textOnPrimary),
                  ),
                  const SizedBox(width: AppSpacing.md - 4),
                  Text(loadingLabel ?? label),
                ],
              )
            : Text(label),
      ),
    );
  }
}
