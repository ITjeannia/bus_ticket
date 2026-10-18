import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Ligne pointillée horizontale (séparation du billet).
class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key, this.color = AppColors.border, this.dashWidth = 6, this.gap = 4});

  final Color color;
  final double dashWidth;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / (dashWidth + gap)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => SizedBox(width: dashWidth, height: 1.5, child: ColoredBox(color: color)),
          ),
        );
      },
    );
  }
}
