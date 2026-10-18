import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../utils/validators.dart';
import 'app_exception.dart';
import 'mock_data.dart';

/// Connexion / inscription (simulées).
/// Règle de démo : tout mot de passe de 8 caractères avec un chiffre est accepté.
class AuthService {
  AuthService._();

  static final instance = AuthService._();
  static const maxAttempts = 3;

  final currentUser = ValueNotifier<User?>(null);
  int _remainingAttempts = maxAttempts;

  Future<void> login(String identifier, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (Validators.password(password) != null) {
      _remainingAttempts = (_remainingAttempts - 1).clamp(0, maxAttempts);
      throw AppException(
        'E-mail ou mot de passe incorrect. Il vous reste $_remainingAttempts essai${_remainingAttempts > 1 ? 's' : ''}.',
      );
    }
    _remainingAttempts = maxAttempts;
    currentUser.value = MockData.demoUser;
  }

  Future<void> register(User user, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    currentUser.value = user;
  }

  void logout() => currentUser.value = null;
}
