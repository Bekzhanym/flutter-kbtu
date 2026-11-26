import 'package:trip_planner/features/countries/models/country_model.dart';

class CountryPage {
  const CountryPage({
    required this.items,
    required this.total,
    required this.hasMore,
    this.fromCache = false,
  });

  final List<Country> items;
  final int total;
  final bool hasMore;
  final bool fromCache;
}
