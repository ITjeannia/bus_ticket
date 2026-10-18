/// Critères saisis sur l'écran de recherche.
class SearchQuery {
  const SearchQuery({
    required this.from,
    required this.to,
    required this.date,
    required this.passengers,
  });

  final String from;
  final String to;
  final DateTime date;
  final int passengers;

  String get route => '$from → $to';

  SearchQuery copyWith({DateTime? date}) =>
      SearchQuery(from: from, to: to, date: date ?? this.date, passengers: passengers);
}
