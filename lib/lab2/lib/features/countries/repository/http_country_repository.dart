import 'package:trip_planner/core/api/api_client.dart';
import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/core/json/json_path_exception.dart';
import 'package:trip_planner/core/json/json_read.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';
import 'package:trip_planner/features/countries/models/country_page_model.dart';
import 'package:trip_planner/features/countries/repository/country_repository.dart';

class HttpCountryRepository implements CountryRepository {
  HttpCountryRepository(this._api);

  final ApiClient _api;

  static const _fields = {
    'response_fields':
        'codes,names,flag,region,subregion,capitals,population,area,'
        'currencies,languages,borders,timezones,links',
    'response_fields_omit': 'names.native,names.translations,names.alternates',
  };

  @override
  Future<CountryPage> search({String query = '', int offset = 0}) async {
    final q = query.trim();
    final json = await _api.get(
      '',
      query: {
        ..._fields,
        'limit': '${CountryRepository.pageSize}',
        'offset': '$offset',
        if (q.isNotEmpty) 'names.common': q,
      },
    );
    return _parse(
      'countries',
      () => asObject(json).obj('data', (data) {
        final items = _countries(data);
        final meta = data.optObj('meta', (m) => m);
        return CountryPage(
          items: items,
          total: meta?.opt<num>('total')?.toInt() ?? items.length,
          hasMore: meta?.opt<bool>('more') ?? false,
        );
      }),
    );
  }

  @override
  Future<Country> getByCode(String alpha3) async {
    final json = await _api.get('/codes.alpha_3/$alpha3', query: _fields);
    final items = _parse(
      'countries/$alpha3',
      () => asObject(json).obj('data', _countries),
    );
    if (items.isEmpty) throw const NotFoundException();
    return items.first;
  }

  List<Country> _countries(Map<String, dynamic> data) =>
      data.list('objects', (e) => Country.fromJson(asObject(e)));

  T _parse<T>(String resource, T Function() parse) {
    try {
      return parse();
    } on JsonPathException catch (e) {
      throw BadResponseException('$resource: $e');
    }
  }
}
