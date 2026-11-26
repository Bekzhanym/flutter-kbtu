import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:trip_planner/core/api/api_client.dart';
import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/features/trips/models/trip_model.dart';
import 'package:trip_planner/features/trips/repository/http_trip_repository.dart';

import '../models/trip_model_test.dart' show almaty;

HttpTripRepository _repo(Future<http.Response> Function(http.Request) h) =>
    HttpTripRepository(
      ApiClient(MockClient(h), host: 'x.mockapi.io', basePath: '/api/v1'),
    );

void main() {
  test('getAll reads the list', () async {
    final repo = _repo(
      (_) async =>
          http.Response(jsonEncode([almaty(), almaty()..['id'] = '2']), 200),
    );
    expect((await repo.getAll()).map((t) => t.id), ['1', '2']);
  });

  test('a bad item names its index and field', () {
    final repo = _repo(
      (_) async => http.Response(
        jsonEncode([almaty(), almaty()..['budget'] = 'lots']),
        200,
      ),
    );
    expect(
      repo.getAll(),
      throwsA(
        isA<BadResponseException>().having(
          (e) => e.detail,
          'detail',
          'trips: [1].budget: expected num, got String',
        ),
      ),
    );
  });

  test('create POSTs JSON without an id and reads the server answer', () async {
    late http.Request sent;
    final repo = _repo((r) async {
      sent = r;
      final body = jsonDecode(r.body) as Map<String, dynamic>;
      return http.Response(jsonEncode({...body, 'id': '7'}), 201);
    });

    final saved = await repo.create(
      Trip.draft(
        countryCode: 'KAZ',
        countryName: 'Kazakhstan',
        startDate: DateTime(2026, 12, 1),
        endDate: DateTime(2026, 12, 3),
        budget: 1000,
      ),
    );

    expect(sent.method, 'POST');
    expect(sent.url.path, '/api/v1/trips');
    expect(sent.headers['Content-Type'], startsWith('application/json'));
    expect((jsonDecode(sent.body) as Map).containsKey('id'), isFalse);
    expect(saved.id, '7');
  });

  test('update PUTs to /trips/{id}', () async {
    late http.Request sent;
    final repo = _repo((r) async {
      sent = r;
      return http.Response(r.body, 200);
    });
    final t = Trip.fromJson(almaty());
    final saved = await repo.update(t.copyWith(budget: 5));
    expect(sent.method, 'PUT');
    expect(sent.url.path, '/api/v1/trips/1');
    expect(saved.budget, 5);
  });

  test('delete accepts 200 and 204; 404 → NotFound', () async {
    await _repo((_) async => http.Response('', 204)).delete('1');
    await _repo((_) async => http.Response('{}', 200)).delete('1');
    expect(
      _repo((_) async => http.Response('"Not found"', 404)).delete('9'),
      throwsA(isA<NotFoundException>()),
    );
  });
}
