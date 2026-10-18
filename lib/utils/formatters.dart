/// Mise en forme des dates, heures, prix et libellés en français.
abstract final class Formatters {
  static const _days = ['lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche'];
  static const _months = [
    'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
    'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
  ];
  static const _shortMonths = [
    'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
    'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.',
  ];

  static String _two(int n) => n.toString().padLeft(2, '0');
  static String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  static String _shortDay(DateTime d) => '${_capitalize(_days[d.weekday - 1].substring(0, 3))}.';

  /// Jeu. 8
  static String dayChip(DateTime d) => '${_shortDay(d)} ${d.day}';

  /// Jeu. 8 oct.
  static String shortDate(DateTime d) => '${_shortDay(d)} ${d.day} ${_shortMonths[d.month - 1]}';

  /// 8 oct.
  static String dayMonth(DateTime d) => '${d.day} ${_shortMonths[d.month - 1]}';

  /// jeudi 8 octobre
  static String dayName(DateTime d) => '${_days[d.weekday - 1]} ${d.day} ${_months[d.month - 1]}';

  /// Jeudi 8 octobre 2026
  static String longDate(DateTime d) => '${_capitalize(dayName(d))} ${d.year}';

  /// 07:30
  static String time(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}';

  /// 5 h 15
  static String duration(Duration d) => '${d.inHours} h ${_two(d.inMinutes % 60)}';

  /// 8 500 FCFA (espaces insécables pour ne pas couper le prix)
  static String price(int amount) {
    final digits = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return '$buffer FCFA';
  }

  /// 1 adulte / 2 adultes
  static String adults(int n) => '$n adulte${n > 1 ? 's' : ''}';

  /// 1 passager / 2 passagers
  static String passengers(int n) => '$n passager${n > 1 ? 's' : ''}';

  /// Siège 12 / Sièges 3, 4
  static String seats(List<int> seats) =>
      '${seats.length > 1 ? 'Sièges' : 'Siège'} ${seats.join(', ')}';
}
