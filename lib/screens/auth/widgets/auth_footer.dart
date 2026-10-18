import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';

/// Lien en bas des écrans d'authentification : « Pas encore de compte ? Créer un compte ».
class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key, required this.question, required this.action, required this.onTap});

  final String question;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(question, style: AppTextStyles.bodySecondary),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 6)),
            child: Text(action),
          ),
        ],
      ),
    );
  }
}
