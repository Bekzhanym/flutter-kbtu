import 'package:trip_planner/core/json/json_read.dart';

class CountryName {
  const CountryName({required this.common, required this.official});

  factory CountryName.fromJson(Map<String, dynamic> json) => CountryName(
    common: json.req<String>('common'),
    official: json.req<String>('official'),
  );

  final String common;
  final String official;

  CountryName copyWith({String? common, String? official}) => CountryName(
    common: common ?? this.common,
    official: official ?? this.official,
  );

  Map<String, dynamic> toJson() => {'common': common, 'official': official};
}
