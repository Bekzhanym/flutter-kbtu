import 'package:trip_planner/core/json/json_read.dart';
import 'package:trip_planner/features/countries/models/country_flag_model.dart';
import 'package:trip_planner/features/countries/models/country_links_model.dart';
import 'package:trip_planner/features/countries/models/country_name_model.dart';
import 'package:trip_planner/features/countries/models/currency_model.dart';

class Country {
  const Country({
    required this.alpha3,
    required this.alpha2,
    required this.name,
    required this.flag,
    required this.region,
    this.subregion,
    required this.capitals,
    required this.population,
    required this.areaKm2,
    required this.currencies,
    required this.languages,
    required this.borders,
    required this.timezones,
    this.links = CountryLinks.empty,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    final codes = json.obj(
      'codes',
      (c) =>
          (alpha2: c.req<String>('alpha_2'), alpha3: c.req<String>('alpha_3')),
    );
    return Country(
      alpha3: codes.alpha3,
      alpha2: codes.alpha2,
      name: json.obj('names', CountryName.fromJson),
      flag: json.obj('flag', CountryFlag.fromJson),
      region: json.req<String>('region'),
      subregion: json.opt<String>('subregion'),
      capitals: json.list('capitals', (e) => asObject(e).req<String>('name')),
      population: json.integer('population'),
      areaKm2: json.obj('area', (a) => a.dbl('kilometers')),
      currencies: json.list(
        'currencies',
        (e) => Currency.fromJson(asObject(e)),
      ),
      languages: json.list('languages', (e) => asObject(e).req<String>('name')),
      borders: json.strings('borders'),
      timezones: json.strings('timezones'),
      links: json.optObj('links', CountryLinks.fromJson) ?? CountryLinks.empty,
    );
  }

  final String alpha3;
  final String alpha2;
  final CountryName name;
  final CountryFlag flag;
  final String region;
  final String? subregion;
  final List<String> capitals;
  final int population;
  final double areaKm2;
  final List<Currency> currencies;
  final List<String> languages;
  final List<String> borders;
  final List<String> timezones;
  final CountryLinks links;

  String get capital => capitals.isEmpty ? '—' : capitals.first;

  double? get density => areaKm2 == 0 ? null : population / areaKm2;

  Country copyWith({
    String? alpha3,
    String? alpha2,
    CountryName? name,
    CountryFlag? flag,
    String? region,
    String? subregion,
    List<String>? capitals,
    int? population,
    double? areaKm2,
    List<Currency>? currencies,
    List<String>? languages,
    List<String>? borders,
    List<String>? timezones,
    CountryLinks? links,
  }) => Country(
    alpha3: alpha3 ?? this.alpha3,
    alpha2: alpha2 ?? this.alpha2,
    name: name ?? this.name,
    flag: flag ?? this.flag,
    region: region ?? this.region,
    subregion: subregion ?? this.subregion,
    capitals: capitals ?? this.capitals,
    population: population ?? this.population,
    areaKm2: areaKm2 ?? this.areaKm2,
    currencies: currencies ?? this.currencies,
    languages: languages ?? this.languages,
    borders: borders ?? this.borders,
    timezones: timezones ?? this.timezones,
    links: links ?? this.links,
  );

  Map<String, dynamic> toJson() => {
    'codes': {'alpha_2': alpha2, 'alpha_3': alpha3},
    'names': name.toJson(),
    'flag': flag.toJson(),
    'region': region,
    'subregion': subregion,
    'capitals': [
      for (final c in capitals) {'name': c},
    ],
    'population': population,
    'area': {'kilometers': areaKm2},
    'currencies': [for (final c in currencies) c.toJson()],
    'languages': [
      for (final l in languages) {'name': l},
    ],
    'borders': borders,
    'timezones': timezones,
    'links': links.toJson(),
  };

  @override
  bool operator ==(Object other) => other is Country && other.alpha3 == alpha3;

  @override
  int get hashCode => alpha3.hashCode;

  @override
  String toString() => 'Country($alpha3, ${name.common})';
}
