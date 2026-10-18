/// Règles de validation des formulaires, partagées entre écrans.
/// Chaque fonction renvoie le message d'erreur, ou null si la valeur est valide.
abstract final class Validators {
  static final _emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String _digits(String value) => value.replaceAll(RegExp(r'\D'), '');

  static String? required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'Ce champ est obligatoire' : null;

  static String? email(String? value) =>
      _emailRegExp.hasMatch((value ?? '').trim()) ? null : 'Adresse e-mail invalide';

  static String? phone(String? value) =>
      _digits(value ?? '').length >= 9 ? null : 'Numéro de téléphone invalide';

  /// E-mail ou téléphone (écran de connexion).
  static String? emailOrPhone(String? value) =>
      email(value) == null || phone(value) == null ? null : 'Saisissez un e-mail ou un numéro valide';

  static String? password(String? value) {
    final v = value ?? '';
    return v.length >= 8 && v.contains(RegExp(r'\d')) ? null : '8 caractères minimum, dont 1 chiffre';
  }

  static String? cardNumber(String? value) =>
      _digits(value ?? '').length >= 16 ? null : 'Numéro de carte invalide';
}
