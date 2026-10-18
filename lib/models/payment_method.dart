import 'package:flutter/material.dart';

/// Moyens de paiement proposés, avec le champ à remplir pour chacun.
enum PaymentMethod {
  mobileMoney(
    label: 'Mobile Money',
    description: 'Orange Money, MTN MoMo',
    icon: Icons.smartphone,
    fieldLabel: 'Numéro Mobile Money',
    fieldIcon: Icons.phone_outlined,
    fieldHint: '+237 6 XX XX XX XX',
  ),
  card(
    label: 'Carte bancaire',
    description: 'Visa, Mastercard',
    icon: Icons.credit_card,
    fieldLabel: 'Numéro de carte',
    fieldIcon: Icons.credit_card,
    fieldHint: '1234 5678 9012 3456',
  );

  const PaymentMethod({
    required this.label,
    required this.description,
    required this.icon,
    required this.fieldLabel,
    required this.fieldIcon,
    required this.fieldHint,
  });

  final String label;
  final String description;
  final IconData icon;
  final String fieldLabel;
  final IconData fieldIcon;
  final String fieldHint;
}
