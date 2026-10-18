import 'package:flutter/material.dart';

import '../../data/auth_service.dart';
import '../../models/user.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import 'widgets/auth_footer.dart';

/// Maquette 02. Le bouton reste grisé tant que tout n'est pas rempli et accepté.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _acceptedTerms = false;
  bool _isLoading = false;
  Map<String, String?> _errors = {};

  List<TextEditingController> get _controllers => [_name, _email, _phone, _password, _confirm];

  bool get _canSubmit => _acceptedTerms && _controllers.every((c) => c.text.trim().isNotEmpty);

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    final errors = {
      'name': Validators.required(_name.text),
      'email': Validators.email(_email.text),
      'phone': Validators.phone(_phone.text),
      'password': Validators.password(_password.text),
      'confirm': _confirm.text == _password.text ? null : 'Les mots de passe ne correspondent pas',
    };
    setState(() => _errors = errors);
    if (errors.values.any((e) => e != null)) return;

    setState(() => _isLoading = true);
    final user = User(fullName: _name.text.trim(), email: _email.text.trim(), phone: _phone.text.trim());
    await AuthService.instance.register(user, _password.text);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (_) => false);
  }

  /// Efface l'erreur d'un champ dès que l'utilisateur le corrige.
  void _onChanged(String key) => setState(() => _errors = {..._errors, key: null});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un compte')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            const Text('Quelques informations pour réserver vos billets.', style: AppTextStyles.bodySecondary),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Nom complet',
              hint: 'Jean Dupont',
              controller: _name,
              prefixIcon: Icons.person_outline,
              errorText: _errors['name'],
              onChanged: (_) => _onChanged('name'),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'E-mail',
              hint: 'jean.dupont@mail.com',
              controller: _email,
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              errorText: _errors['email'],
              onChanged: (_) => _onChanged('email'),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Téléphone',
              hint: '+237 6 XX XX XX XX',
              controller: _phone,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              errorText: _errors['phone'],
              onChanged: (_) => _onChanged('phone'),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Mot de passe',
              controller: _password,
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              helperText: '8 caractères minimum, dont 1 chiffre',
              errorText: _errors['password'],
              onChanged: (_) => _onChanged('password'),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Confirmer le mot de passe',
              hint: 'Ressaisir le mot de passe',
              controller: _confirm,
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              errorText: _errors['confirm'],
              onChanged: (_) => _onChanged('confirm'),
            ),
            const SizedBox(height: AppSpacing.sm),
            InkWell(
              onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
              child: Row(
                children: [
                  Checkbox(
                    value: _acceptedTerms,
                    onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Expanded(
                    child: Text("J'accepte les conditions d'utilisation", style: TextStyle(fontSize: 15)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Créer mon compte',
              loadingLabel: 'Création du compte…',
              isLoading: _isLoading,
              onPressed: _canSubmit ? _submit : null,
            ),
            if (!_canSubmit) ...[
              const SizedBox(height: AppSpacing.sm + 4),
              const Text(
                'Remplissez tous les champs et acceptez les conditions pour continuer.',
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            AuthFooter(
              question: 'Déjà inscrit ?',
              action: 'Se connecter',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
