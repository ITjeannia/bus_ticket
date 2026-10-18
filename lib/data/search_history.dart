import 'package:flutter/foundation.dart';

/// Dernières recherches (départ, arrivée), la plus récente en premier.
class SearchHistory {
  SearchHistory._();

  static final instance = SearchHistory._();
  static const _maxItems = 5;

  final recent = ValueNotifier<List<(String, String)>>([]);

  void add(String from, String to) {
    final route = (from, to);
    recent.value = [route, ...recent.value.where((r) => r != route)].take(_maxItems).toList();
  }
}
