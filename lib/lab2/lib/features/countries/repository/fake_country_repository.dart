import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/features/countries/models/country_flag_model.dart';
import 'package:trip_planner/features/countries/models/country_links_model.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';
import 'package:trip_planner/features/countries/models/country_name_model.dart';
import 'package:trip_planner/features/countries/models/country_page_model.dart';
import 'package:trip_planner/features/countries/models/currency_model.dart';
import 'package:trip_planner/features/countries/repository/country_repository.dart';

class FakeCountryRepository implements CountryRepository {
  FakeCountryRepository({
    this.delay = Duration.zero,
    this.failWith,
    List<Country>? countries,
  }) : _countries = countries ?? fakeCountries;

  final Duration delay;
  ApiException? failWith;
  final List<Country> _countries;
  int calls = 0;

  @override
  Future<CountryPage> search({String query = '', int offset = 0}) async {
    await _tick();
    final q = query.trim().toLowerCase();
    final matched = [
      for (final c in _countries)
        if (q.isEmpty ||
            c.name.common.toLowerCase().contains(q) ||
            c.capital.toLowerCase().contains(q))
          c,
    ];
    final page = matched.skip(offset).take(CountryRepository.pageSize).toList();
    return CountryPage(
      items: page,
      total: matched.length,
      hasMore: offset + page.length < matched.length,
    );
  }

  @override
  Future<Country> getByCode(String alpha3) async {
    await _tick();
    for (final c in _countries) {
      if (c.alpha3 == alpha3) return c;
    }
    throw const NotFoundException();
  }

  Future<void> _tick() async {
    calls++;
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (failWith case final e?) throw e;
  }
}

Country _country({
  required String a3,
  required String a2,
  required String name,
  required String official,
  required String emoji,
  required String region,
  required String subregion,
  required String capital,
  required int population,
  required double area,
  required Currency currency,
  required List<String> languages,
  required List<String> borders,
  required String timezone,
}) => Country(
  alpha3: a3,
  alpha2: a2,
  name: CountryName(common: name, official: official),
  flag: CountryFlag(
    emoji: emoji,
    pngUrl: 'https://flags.restcountries.com/v5/w640/${a2.toLowerCase()}.png',
  ),
  region: region,
  subregion: subregion,
  capitals: [capital],
  population: population,
  areaKm2: area,
  currencies: [currency],
  languages: languages,
  borders: borders,
  timezones: [timezone],
  links: CountryLinks(
    wikipedia: 'https://en.wikipedia.org/wiki/${name.replaceAll(' ', '_')}',
  ),
);

final fakeCountries = [
  _country(
    a3: 'CAN',
    a2: 'CA',
    name: 'Canada',
    official: 'Canada',
    emoji: '🇨🇦',
    region: 'Americas',
    subregion: 'North America',
    capital: 'Ottawa',
    population: 41798407,
    area: 9984670,
    currency: const Currency(
      code: 'CAD',
      name: 'Canadian dollar',
      symbol: r'$',
    ),
    languages: ['English', 'French'],
    borders: ['USA'],
    timezone: 'UTC-05:00',
  ),
  _country(
    a3: 'FRA',
    a2: 'FR',
    name: 'France',
    official: 'French Republic',
    emoji: '🇫🇷',
    region: 'Europe',
    subregion: 'Western Europe',
    capital: 'Paris',
    population: 68400000,
    area: 551695,
    currency: const Currency(code: 'EUR', name: 'Euro', symbol: '€'),
    languages: ['French'],
    borders: ['BEL', 'DEU', 'ESP', 'ITA'],
    timezone: 'UTC+01:00',
  ),
  _country(
    a3: 'GEO',
    a2: 'GE',
    name: 'Georgia',
    official: 'Georgia',
    emoji: '🇬🇪',
    region: 'Asia',
    subregion: 'Western Asia',
    capital: 'Tbilisi',
    population: 3700000,
    area: 69700,
    currency: const Currency(code: 'GEL', name: 'Georgian lari', symbol: '₾'),
    languages: ['Georgian'],
    borders: ['ARM', 'AZE', 'RUS', 'TUR'],
    timezone: 'UTC+04:00',
  ),
  _country(
    a3: 'JPN',
    a2: 'JP',
    name: 'Japan',
    official: 'Japan',
    emoji: '🇯🇵',
    region: 'Asia',
    subregion: 'Eastern Asia',
    capital: 'Tokyo',
    population: 123800000,
    area: 377930,
    currency: const Currency(code: 'JPY', name: 'Japanese yen', symbol: '¥'),
    languages: ['Japanese'],
    borders: [],
    timezone: 'UTC+09:00',
  ),
  _country(
    a3: 'KAZ',
    a2: 'KZ',
    name: 'Kazakhstan',
    official: 'Republic of Kazakhstan',
    emoji: '🇰🇿',
    region: 'Asia',
    subregion: 'Central Asia',
    capital: 'Astana',
    population: 20300000,
    area: 2724900,
    currency: const Currency(
      code: 'KZT',
      name: 'Kazakhstani tenge',
      symbol: '₸',
    ),
    languages: ['Kazakh', 'Russian'],
    borders: ['CHN', 'KGZ', 'RUS', 'TKM', 'UZB'],
    timezone: 'UTC+05:00',
  ),
  _country(
    a3: 'TUR',
    a2: 'TR',
    name: 'Turkey',
    official: 'Republic of Türkiye',
    emoji: '🇹🇷',
    region: 'Asia',
    subregion: 'Western Asia',
    capital: 'Ankara',
    population: 85300000,
    area: 783562,
    currency: const Currency(code: 'TRY', name: 'Turkish lira', symbol: '₺'),
    languages: ['Turkish'],
    borders: ['ARM', 'AZE', 'BGR', 'GEO', 'GRC', 'IRN', 'IRQ', 'SYR'],
    timezone: 'UTC+03:00',
  ),
];
