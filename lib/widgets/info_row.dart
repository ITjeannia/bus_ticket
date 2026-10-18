import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Ligne « libellé ........ valeur » (ex. détail du prix).
class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value, this.valueStyle});

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs + 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodySecondary)),
          Text(value, style: valueStyle ?? AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
