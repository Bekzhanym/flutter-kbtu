import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:trip_planner/core/api/api_client.dart';
import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/features/countries/repository/http_country_repository.dart';

import '../models/country_model_test.dart' show canada;

HttpCountryRepository _repo(Future<http.Response> Function(http.Request) h) =>
    HttpCountryRepository(
      ApiClient(
        MockClient(h),
        host: 'api.restcountries.com',
        basePath: '/countries/v5',
        fixedQuery: {'api-key': 'test-key'},
      ),
    );

String _page(List<Map<String, dynamic>> objects, {bool more = false}) =>
    jsonEncode({
      'data': {
        'objects': objects,
        'meta': {'total': 249, 'count': objects.length, 'more': more},
      },
    });

http.Response _ok(String body) => http.Response.bytes(utf8.encode(body), 200);

void main() {
  test(
    'search sends the name filter, paging and the key; reads objects and meta',
    () async {
      late Uri sent;
      final repo = _repo((r) async {
        sent = r.url;
        return _ok(_page([canada()], more: true));
      });

      final page = await repo.search(query: ' can ', offset: 25);

      expect(sent.path, '/countries/v5');
      expect(sent.queryParameters['names.common'], 'can');
      expect(sent.queryParameters['offset'], '25');
      expect(sent.queryParameters['limit'], '25');
      expect(sent.queryParameters['api-key'], 'test-key');
      expect(page.items.single.alpha3, 'CAN');
      expect(page.total, 249);
      expect(page.hasMore, isTrue);
    },
  );

  test('an empty query sends no name filter', () async {
    late Uri sent;
    final repo = _repo((r) async {
      sent = r.url;
      return _ok(_page([]));
    });
    await repo.search();
    expect(sent.queryParameters.containsKey('names.common'), isFalse);
  });

  test('getByCode reads one country from data.objects', () async {
    late Uri sent;
    final repo = _repo((r) async {
      sent = r.url;
      return _ok(_page([canada()]));
    });
    final c = await repo.getByCode('CAN');
    expect(sent.path, '/countries/v5/codes.alpha_3/CAN');
    expect(c.name.common, 'Canada');
  });

  test('getByCode: 404 and an empty list both mean NotFound', () async {
    expect(
      _repo((_) async => http.Response('', 404)).getByCode('XXX'),
      throwsA(isA<NotFoundException>()),
    );
    expect(
      _repo((_) async => _ok(_page([]))).getByCode('XXX'),
      throwsA(isA<NotFoundException>()),
    );
  });

  test('500 → ServerException, SocketException → NoConnection', () {
    expect(
      _repo((_) async => http.Response('', 500)).search(),
      throwsA(isA<ServerException>()),
    );
    expect(
      _repo((_) async => throw const SocketException('down')).search(),
      throwsA(isA<NoConnectionException>()),
    );
  });

  test('a wrong type → BadResponse naming the resource and the field', () {
    final broken = canada()..['population'] = 'many';
    expect(
      _repo((_) async => _ok(_page([broken]))).search(),
      throwsA(
        isA<BadResponseException>().having(
          (e) => e.detail,
          'detail',
          'countries: data.objects[0].population: expected num, got String',
        ),
      ),
    );
  });
}
