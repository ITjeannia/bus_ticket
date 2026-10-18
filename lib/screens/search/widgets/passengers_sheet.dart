import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/quantity_selector.dart';

/// Feuille du bas pour choisir le nombre de passagers. Utiliser [PassengersSheet.show].
class PassengersSheet extends StatefulWidget {
  const PassengersSheet({super.key, required this.initialValue});

  final int initialValue;

  static Future<int?> show(BuildContext context, {required int initialValue}) {
    return showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (_) => PassengersSheet(initialValue: initialValue),
    );
  }

  @override
  State<PassengersSheet> createState() => _PassengersSheetState();
}

class _PassengersSheetState extends State<PassengersSheet> {
  late int _value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Passagers', style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Expanded(child: Text('Adultes', style: AppTextStyles.body)),
                QuantitySelector(value: _value, onChanged: (v) => setState(() => _value = v)),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(label: 'Valider', onPressed: () => Navigator.pop(context, _value)),
          ],
        ),
      ),
    );
  }
}
