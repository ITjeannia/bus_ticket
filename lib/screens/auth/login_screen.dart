import 'package:flutter/material.dart';

import '../../data/app_exception.dart';
import '../../data/auth_service.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/alert_banner.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import 'widgets/auth_footer.dart';

/// Maquettes 01 (normal), 01b (erreur), 01c (chargement).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _bannerError;
  String? _identifierError;
  String? _passwordError;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final identifierError = Validators.emailOrPhone(_identifierController.text);
    final passwordError = Validators.required(_passwordController.text);
    setState(() {
      _identifierError = identifierError;
      _passwordError = passwordError;
      _bannerError = null;
    });
    if (identifierError != null || passwordError != null) return;

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.login(_identifierController.text.trim(), _passwordController.text);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (_) => false);
    } on AppException catch (e) {
      setState(() {
        _bannerError = e.message;
        _passwordError = 'Mot de passe incorrect';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showComingSoon() => ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Fonctionnalité bientôt disponible')));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                children: [
                  const SizedBox(height: AppSpacing.lg + 4),
                  const Align(alignment: Alignment.centerLeft, child: AppBrand()),
                  const SizedBox(height: AppSpacing.xl),
                  const Text('Bon retour !', style: AppTextStyles.headline),
                  const SizedBox(height: AppSpacing.sm + 4),
                  const Text(
                    'Connectez-vous pour réserver et retrouver vos billets.',
                    style: AppTextStyles.bodySecondary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (_bannerError != null) ...[
                    AlertBanner.error(_bannerError!),
                    const SizedBox(height: AppSpacing.md + 4),
                  ],
                  AppTextField(
                    label: 'E-mail ou téléphone',
                    hint: 'jean.dupont@mail.com',
                    controller: _identifierController,
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !_isLoading,
                    errorText: _identifierError,
                  ),
                  const SizedBox(height: AppSpacing.md + 4),
                  AppTextField(
                    label: 'Mot de passe',
                    controller: _passwordController,
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    enabled: !_isLoading,
                    errorText: _passwordError,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(onPressed: _showComingSoon, child: const Text('Mot de passe oublié ?')),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  PrimaryButton(
                    label: 'Se connecter',
                    loadingLabel: 'Connexion…',
                    isLoading: _isLoading,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
            AuthFooter(
              question: 'Pas encore de compte ?',
              action: 'Créer un compte',
              onTap: () => Navigator.pushNamed(context, AppRoutes.register),
            ),
          ],
        ),
      ),
    );
  }
}
