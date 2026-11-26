import 'package:trip_planner/features/countries/models/country_model.dart';
import 'package:trip_planner/features/countries/models/country_page_model.dart';

abstract interface class CountryRepository {
  static const int pageSize = 25;

  Future<CountryPage> search({String query = '', int offset = 0});

  Future<Country> getByCode(String alpha3);
}
