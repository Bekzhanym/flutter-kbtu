import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:trip_planner/core/api/api_client.dart';
import 'package:trip_planner/core/api/api_exception.dart';

ApiClient _api(
  Future<http.Response> Function(http.Request) handler, {
  Map<String, String> fixedQuery = const {},
  Duration timeout = ApiClient.defaultTimeout,
}) => ApiClient(
  MockClient(handler),
  host: 'example.test',
  basePath: '/v1',
  fixedQuery: fixedQuery,
  timeout: timeout,
);

Future<http.Response> Function(http.Request) _status(int s, [String b = '']) =>
    (_) async => http.Response(b, s);

void main() {
  group('the wire', () {
    test('GET builds https + basePath + fixed and own query', () async {
      late Uri sent;
      final api = _api((r) async {
        sent = r.url;
        return http.Response('[]', 200);
      }, fixedQuery: {'api-key': 'k'});

      await api.get('/countries', query: {'q': 'kaz'});

      expect(sent.scheme, 'https');
      expect(sent.path, '/v1/countries');
      expect(sent.queryParameters, {'api-key': 'k', 'q': 'kaz'});
    });

    test('POST sends JSON with Content-Type and expects 201', () async {
      late http.Request sent;
      final api = _api((r) async {
        sent = r;
        return http.Response('{"id":"1"}', 201);
      });

      final json = await api.post('/trips', {'country': 'KAZ'});

      expect(sent.method, 'POST');
      expect(sent.headers['Content-Type'], startsWith('application/json'));
      expect(jsonDecode(sent.body), {'country': 'KAZ'});
      expect(json, {'id': '1'});
    });

    test('JSON is read as UTF-8 even without a charset header', () async {
      final api = _api(
        (_) async => http.Response.bytes(utf8.encode('{"s":"₸ 🇰🇿"}'), 200),
      );
      expect(await api.get('/x'), {'s': '₸ 🇰🇿'});
    });

    test('DELETE accepts 204 with an empty body and 200', () async {
      await _api(_status(204)).delete('/trips/1');
      await _api(_status(200, '{"id":"1"}')).delete('/trips/1');
    });
  });

  group('status → ApiException', () {
    test('401 → Unauthorized', () {
      expect(
        _api(_status(401)).get('/x'),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test('404 → NotFound', () {
      expect(_api(_status(404)).get('/x'), throwsA(isA<NotFoundException>()));
    });

    test('other 4xx → ClientError with the server message', () {
      const body = '{"errors":[{"message":"Limit too big","code":"x"}]}';
      expect(
        _api(_status(400, body)).get('/x'),
        throwsA(
          isA<ClientErrorException>()
              .having((e) => e.status, 'status', 400)
              .having((e) => e.detail, 'detail', 'Limit too big'),
        ),
      );
    });

    test('500 → ServerException(500)', () {
      expect(
        _api(_status(500)).get('/x'),
        throwsA(isA<ServerException>().having((e) => e.status, 's', 500)),
      );
    });

    test('200 on a POST that expects 201 → BadResponse', () {
      expect(
        _api(_status(200, '{}')).post('/x', {}),
        throwsA(isA<BadResponseException>()),
      );
    });

    test('200 with HTML instead of JSON → BadResponse', () {
      expect(
        _api(_status(200, '<html>')).get('/x'),
        throwsA(isA<BadResponseException>()),
      );
    });
  });

  group('no answer → NoConnection', () {
    test('SocketException', () {
      final api = _api((_) async => throw const SocketException('offline'));
      expect(api.get('/x'), throwsA(isA<NoConnectionException>()));
    });

    test('a server that never answers hits the timeout', () {
      final never = Completer<http.Response>();
      final api = _api(
        (_) => never.future,
        timeout: const Duration(milliseconds: 50),
      );
      expect(api.get('/x'), throwsA(isA<NoConnectionException>()));
    });
  });
}
