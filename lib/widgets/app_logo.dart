import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Logo de l'application à taille réglable.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppAssets.logo, width: size, height: size);
  }
}

/// Logo suivi du nom « BusTicket » (en-tête de la connexion).
class AppBrand extends StatelessWidget {
  const AppBrand({super.key, this.logoSize = 48});

  final double logoSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogo(size: logoSize),
        const SizedBox(width: AppSpacing.md - 4),
        Text(
          AppStrings.appName,
          style: TextStyle(
            fontSize: logoSize * 0.38,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
