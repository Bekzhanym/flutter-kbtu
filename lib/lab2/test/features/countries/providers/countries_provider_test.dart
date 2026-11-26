import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';
import 'package:trip_planner/features/countries/models/country_name_model.dart';
import 'package:trip_planner/features/countries/models/country_page_model.dart';
import 'package:trip_planner/features/countries/providers/countries_provider.dart';
import 'package:trip_planner/features/countries/repository/country_repository.dart';
import 'package:trip_planner/features/countries/repository/fake_country_repository.dart';

class _ManualRepo implements CountryRepository {
  final calls = <String, Completer<CountryPage>>{};

  @override
  Future<CountryPage> search({String query = '', int offset = 0}) =>
      (calls[query] = Completer<CountryPage>()).future;

  @override
  Future<Country> getByCode(String alpha3) => throw UnimplementedError();
}

CountryPage _pageOf(String name) => CountryPage(
  items: [
    fakeCountries.first.copyWith(
      name: CountryName(common: name, official: name),
    ),
  ],
  total: 1,
  hasMore: false,
);

void main() {
  test('load → data', () async {
    final p = CountriesProvider(FakeCountryRepository());
    await p.load();
    expect(p.items, hasLength(6));
    expect(p.error, isNull);
    expect(p.loading, isFalse);
  });

  test('load → NoConnection is kept as the error', () async {
    final p = CountriesProvider(
      FakeCountryRepository(failWith: const NoConnectionException()),
    );
    await p.load();
    expect(p.error, isA<NoConnectionException>());
    expect(p.items, isEmpty);
  });

  test('search narrows through the repository', () async {
    final p = CountriesProvider(FakeCountryRepository());
    await p.search('kaz');
    expect(p.items.map((c) => c.alpha3), ['KAZ']);
  });

  test('a slow old answer cannot overwrite a newer search', () async {
    final repo = _ManualRepo();
    final p = CountriesProvider(repo);

    final first = p.search('ka');
    final second = p.search('kaz');
    repo.calls['kaz']!.complete(_pageOf('Kazakhstan'));
    await second;
    repo.calls['ka']!.complete(_pageOf('Kenya'));
    await first;

    expect(p.items.single.name.common, 'Kazakhstan');
    expect(p.loading, isFalse);
  });

  test('loadMore appends the next page', () async {
    final many = [
      for (var i = 0; i < 30; i++)
        fakeCountries.first.copyWith(
          alpha3: 'C$i',
          name: CountryName(common: 'Country $i', official: 'Country $i'),
        ),
    ];
    final p = CountriesProvider(FakeCountryRepository(countries: many));

    await p.load();
    expect(p.items, hasLength(25));
    expect(p.hasMore, isTrue);

    await p.loadMore();
    expect(p.items, hasLength(30));
    expect(p.hasMore, isFalse);
  });

  test('no notify after dispose — leaving mid-load is silent', () async {
    final p = CountriesProvider(
      FakeCountryRepository(delay: const Duration(milliseconds: 10)),
    );
    final f = p.load();
    p.dispose();
    await f;
  });
}
