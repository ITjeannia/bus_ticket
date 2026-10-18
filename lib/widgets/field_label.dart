import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// État visuel d'un champ, qui détermine ses couleurs.
enum FieldState { normal, focused, error, disabled }

/// Libellé au-dessus d'un champ : bleu si actif, rouge si erreur, gris si désactivé.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.state = FieldState.normal});

  final String text;
  final FieldState state;

  static Color colorOf(FieldState state) => switch (state) {
        FieldState.normal => AppColors.textPrimary,
        FieldState.focused => AppColors.primary,
        FieldState.error => AppColors.error,
        FieldState.disabled => AppColors.textDisabled,
      };

  /// Bordure forcée en rouge quand le champ est en erreur (sinon celle du thème).
  static InputBorder? errorBorder(FieldState state) => state == FieldState.error
      ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        )
      : null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: AppTextStyles.label.copyWith(color: colorOf(state))),
    );
  }
}

/// Texte sous un champ : erreur (rouge) ou aide (gris), aligné sur le bord du champ.
class FieldMessage extends StatelessWidget {
  const FieldMessage({super.key, this.error, this.helper});

  final String? error;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final text = error ?? helper;
    if (text == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(color: error != null ? AppColors.error : null),
      ),
    );
  }
}
