import 'package:flutter/material.dart';

/// Palette de l'application, relevée sur la maquette Figma.
/// Toute couleur utilisée dans l'UI doit venir d'ici (jamais de Color(0x...) dans un écran).
abstract final class AppColors {
  // Marque
  static const primary = Color(0xFF1565C0);
  static const primarySoft = Color(0xFFE3F2FD); // fond des éléments sélectionnés / infos

  // Fonds
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF1F2F6); // récapitulatif, onglets, champs désactivés
  static const border = Color(0xFFD6D5DF);
  static const disabled = Color(0xFFBDBDBD); // siège occupé, billet expiré

  // Textes
  static const textPrimary = Color(0xFF1C1B1F);
  static const textSecondary = Color(0xFF5F6368);
  static const textDisabled = Color(0xFF9E9E9E);
  static const textOnPrimary = Color(0xFFFFFFFF);

  // États
  static const error = Color(0xFFB3261E);
  static const errorSoft = Color(0xFFFCE8E6);
  static const success = Color(0xFF2E7D32);
  static const successSoft = Color(0xFFE8F5E9);
}
