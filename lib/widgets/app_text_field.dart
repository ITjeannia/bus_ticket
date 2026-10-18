import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'field_label.dart';

/// Champ de saisie avec libellé au-dessus.
/// Gère seul ses couleurs : actif (bleu), erreur (rouge + icône), désactivé (gris).
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.prefixIcon,
    this.errorText,
    this.helperText,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final IconData? prefixIcon;

  /// Message d'erreur affiché sous le champ (null = pas d'erreur).
  final String? errorText;

  /// Aide affichée sous le champ quand il n'y a pas d'erreur.
  final String? helperText;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  FieldState get _state {
    if (!widget.enabled) return FieldState.disabled;
    if (widget.errorText != null) return FieldState.error;
    if (_focusNode.hasFocus) return FieldState.focused;
    return FieldState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final state = _state;
    final iconColor = switch (state) {
      FieldState.error => AppColors.error,
      FieldState.focused => AppColors.primary,
      _ => AppColors.textSecondary,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(widget.label, state: state),
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          style: TextStyle(
            fontSize: 16,
            color: widget.enabled ? AppColors.textPrimary : AppColors.textDisabled,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            fillColor: widget.enabled ? AppColors.surface : AppColors.surfaceMuted,
            prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon, color: iconColor),
            suffixIcon: state == FieldState.error
                ? const Icon(Icons.error_outline, color: AppColors.error)
                : null,
            enabledBorder: FieldLabel.errorBorder(state),
            focusedBorder: FieldLabel.errorBorder(state),
          ),
        ),
        FieldMessage(error: widget.errorText, helper: widget.helperText),
      ],
    );
  }
}
