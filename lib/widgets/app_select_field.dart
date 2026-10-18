import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'field_label.dart';

/// Champ non éditable qui ouvre un sélecteur au toucher (ville, date, passagers…).
class AppSelectField extends StatelessWidget {
  const AppSelectField({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.value,
    this.hint = 'Choisir',
    this.errorText,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final String? value;
  final String hint;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final state = errorText != null ? FieldState.error : FieldState.normal;
    final iconColor = state == FieldState.error ? AppColors.error : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, state: state),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: InputDecorator(
            isEmpty: value == null,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(4, 13, 8, 13),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Icon(icon, color: iconColor),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 0),
              suffixIcon: state == FieldState.error
                  ? const Icon(Icons.error_outline, color: AppColors.error)
                  : null,
              enabledBorder: FieldLabel.errorBorder(state),
            ),
            // Réduit légèrement le texte s'il ne tient pas (ex. « Dim. 18 oct. » dans un champ étroit).
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value ?? hint,
                maxLines: 1,
                style: value == null
                    ? AppTextStyles.body.copyWith(color: AppColors.textSecondary)
                    : AppTextStyles.body,
              ),
            ),
          ),
        ),
        FieldMessage(error: errorText),
      ],
    );
  }
}
