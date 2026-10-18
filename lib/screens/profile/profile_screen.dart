import 'package:flutter/material.dart';

import '../../constants/app_strings.dart';
import '../../data/auth_service.dart';
import '../../models/user.dart';
import '../../routes/app_routes.dart';
import '../../routes/main_tabs.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Onglet « Profil » — maquette 09.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _comingSoon(BuildContext context) => ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Fonctionnalité bientôt disponible')));

  void _logout(BuildContext context) {
    AuthService.instance.logout();
    MainTabs.current.value = MainTabs.search;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xl + AppSpacing.sm, AppSpacing.md, AppSpacing.md),
            child: Text('Profil', style: AppTextStyles.headline),
          ),
          ValueListenableBuilder<User?>(
            valueListenable: AuthService.instance.currentUser,
            builder: (context, user, _) => user == null ? const SizedBox.shrink() : _UserHeader(user: user),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              children: [
                _ProfileTile(icon: Icons.person_outline, label: 'Informations personnelles', onTap: () => _comingSoon(context)),
                _ProfileTile(icon: Icons.credit_card, label: 'Moyens de paiement', onTap: () => _comingSoon(context)),
                _ProfileTile(icon: Icons.dark_mode_outlined, label: 'Thème sombre', onTap: () => _comingSoon(context)),
                _ProfileTile(icon: Icons.language, label: 'Langue · Français', onTap: () => _comingSoon(context)),
                _ProfileTile(icon: Icons.info_outline, label: 'Aide et contact', onTap: () => _comingSoon(context)),
                _ProfileTile(
                  icon: Icons.logout,
                  label: 'Se déconnecter',
                  color: AppColors.error,
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Center(
              child: Text(AppStrings.footer, style: AppTextStyles.small, textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  const _UserHeader({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primarySoft,
            child: Text(
              user.initials,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.fullName, style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700)),
                Text(user.email, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.icon, required this.label, required this.onTap, this.color});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Couleur spéciale (ex. rouge pour la déconnexion) ; sans chevron dans ce cas.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 56,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: Text(label, style: AppTextStyles.body.copyWith(color: color)),
      trailing: color == null ? const Icon(Icons.chevron_right, color: AppColors.textSecondary) : null,
      onTap: onTap,
    );
  }
}
