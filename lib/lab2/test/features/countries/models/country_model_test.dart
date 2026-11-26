import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/core/json/json_path_exception.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';

Map<String, dynamic> canada() => {
  'codes': {'alpha_2': 'CA', 'alpha_3': 'CAN'},
  'names': {'common': 'Canada', 'official': 'Canada'},
  'flag': {
    'emoji': '🇨🇦',
    'url_png': 'https://flags.restcountries.com/v5/w640/ca.png',
  },
  'region': 'Americas',
  'subregion': 'North America',
  'capitals': [
    {'name': 'Ottawa'},
  ],
  'population': 41798407,
  'area': {'kilometers': 9984670},
  'currencies': [
    {'code': 'CAD', 'name': 'Canadian dollar', 'symbol': r'$'},
  ],
  'languages': [
    {'name': 'English'},
    {'name': 'French'},
  ],
  'borders': ['USA'],
  'timezones': ['UTC-08:00', 'UTC-03:30'],
  'links': {
    'wikipedia': 'https://en.wikipedia.org/wiki/Canada',
    'google_maps': 'https://goo.gl/maps/jmEVLugreeqiZXxbA',
    'official': 'https://www.canada.ca',
  },
};

Matcher _badAt(String path) => throwsA(
  isA<JsonPathException>().having((e) => e.path, 'path', path),
);

void main() {
  test('fromJson reads the nested objects', () {
    final c = Country.fromJson(canada());

    expect(c.alpha3, 'CAN');
    expect(c.name.common, 'Canada');
    expect(c.flag.emoji, '🇨🇦');
    expect(c.capitals, ['Ottawa']);
    expect(c.currencies.single.label, r'Canadian dollar ($)');
    expect(c.languages, ['English', 'French']);
    expect(c.links.wikipedia, endsWith('/Canada'));
    expect(c.areaKm2, 9984670.0);
  });

  test('toJson → fromJson round-trips', () {
    final c = Country.fromJson(canada());
    final again = Country.fromJson(
      jsonDecode(jsonEncode(c.toJson())) as Map<String, dynamic>,
    );
    expect(again, c);
    expect(again.toJson(), c.toJson());
  });

  test('missing subregion, links and symbol are fine', () {
    final json = canada()
      ..remove('subregion')
      ..remove('links');
    (json['currencies'] as List).first.remove('symbol');

    final c = Country.fromJson(json);
    expect(c.subregion, isNull);
    expect(c.links.wikipedia, isNull);
    expect(c.currencies.single.label, 'Canadian dollar');
  });

  test('a wrong type names its field', () {
    expect(
      () => Country.fromJson(canada()..['population'] = '41M'),
      _badAt('population'),
    );
  });

  test('a wrong type deep inside names the whole path', () {
    expect(
      () => Country.fromJson(
        canada()
          ..['capitals'] = [
            {'name': 42},
          ],
      ),
      _badAt('capitals[0].name'),
    );

    expect(
      () => Country.fromJson(canada()..['area'] = {'kilometers': 'big'}),
      _badAt('area.kilometers'),
    );
  });

  test('derived: capital and density', () {
    final c = Country.fromJson(canada());
    expect(c.capital, 'Ottawa');
    expect(c.density, closeTo(4.19, 0.01));

    final empty = c.copyWith(capitals: [], areaKm2: 0);
    expect(empty.capital, '—');
    expect(empty.density, isNull);
  });
}
