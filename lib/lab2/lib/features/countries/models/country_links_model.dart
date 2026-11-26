import 'package:trip_planner/core/json/json_read.dart';

class CountryLinks {
  const CountryLinks({this.wikipedia, this.googleMaps, this.official});

  static const empty = CountryLinks();

  factory CountryLinks.fromJson(Map<String, dynamic> json) => CountryLinks(
    wikipedia: json.opt<String>('wikipedia'),
    googleMaps: json.opt<String>('google_maps'),
    official: json.opt<String>('official'),
  );

  final String? wikipedia;
  final String? googleMaps;
  final String? official;

  CountryLinks copyWith({
    String? wikipedia,
    String? googleMaps,
    String? official,
  }) => CountryLinks(
    wikipedia: wikipedia ?? this.wikipedia,
    googleMaps: googleMaps ?? this.googleMaps,
    official: official ?? this.official,
  );

  Map<String, dynamic> toJson() => {
    'wikipedia': wikipedia,
    'google_maps': googleMaps,
    'official': official,
  };
}
