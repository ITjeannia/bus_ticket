import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Styles de texte de l'application.
abstract final class AppTextStyles {
  /// Grand titre de page : « Bonjour Jean », « Mes billets », « Profil ».
  static const headline = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Titre de barre d'application et de section.
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const subtitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const bodySecondary = TextStyle(
    fontSize: 16,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  /// Libellé au-dessus des champs.
  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const caption = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  /// Mentions de bas de page.
  static const small = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
