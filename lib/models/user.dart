/// Utilisateur connecté.
class User {
  const User({required this.fullName, required this.email, required this.phone});

  final String fullName;
  final String email;
  final String phone;

  String get firstName => fullName.split(' ').first;

  /// « Jean Dupont » → « JD »
  String get initials => fullName
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();
}
