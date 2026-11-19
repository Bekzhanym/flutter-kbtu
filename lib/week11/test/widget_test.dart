import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:week11/core/errors/api_exception.dart';
import 'package:week11/core/network/api_client.dart';
import 'package:week11/features/users/models/user_model.dart';
import 'package:week11/features/users/repository/user_repository.dart';

const _user = {
  'id': 1,
  'name': 'Leanne Graham',
  'username': 'Bret',
  'email': 'Sincere@april.biz',
  'address': {
    'street': 'Kulas Light',
    'suite': 'Apt. 556',
    'city': 'Gwenborough',
    'zipcode': '92998-3874',
    'geo': {'lat': '-37.3159', 'lng': '81.1496'},
  },
  'phone': '1-770-736-8031 x56442',
  'website': 'hildegard.org',
  'company': {'name': 'Romaguera-Crona', 'catchPhrase': 'Multi-layered'},
};

UserRepository _repo(http.Response Function(http.Request) handler) =>
    UserRepository(ApiClient(MockClient((r) async => handler(r))));

void main() {
  group('User', () {
    test('fromJson parses nested objects and lat/lng strings', () {
      final u = User.fromJson(_user);
      expect(u.address.geo.lat, -37.3159);
      expect(u.company.name, 'Romaguera-Crona');
      expect(u.phoneDigits, '1770736803156442');
    });

    test('toJson round-trips', () {
      final u = User.fromJson(_user);
      final again = User.fromJson(
        jsonDecode(jsonEncode(u.toJson())) as Map<String, dynamic>,
      );
      expect(again, u);
      expect(again.toJson(), u.toJson());
    });

    test('website may be null', () {
      expect(User.fromJson({..._user, 'website': null}).website, isNull);
    });
  });

  group('UserRepository', () {
    test('getAll returns users', () async {
      final repo = _repo((_) => http.Response(jsonEncode([_user]), 200));
      expect(await repo.getAll(), hasLength(1));
    });

    test('404 → NotFoundException', () {
      final repo = _repo((_) => http.Response('{}', 404));
      expect(repo.getById(999), throwsA(isA<NotFoundException>()));
    });

    test('401 → UnauthorizedException', () {
      final repo = _repo((_) => http.Response('{}', 401));
      expect(repo.getAll(), throwsA(isA<UnauthorizedException>()));
    });

    test('503 → ServerException(503)', () {
      final repo = _repo((_) => http.Response('', 503));
      expect(
        repo.getAll(),
        throwsA(isA<ServerException>().having((e) => e.status, 's', 503)),
      );
    });

    test('not JSON → BadResponseException', () {
      final repo = _repo((_) => http.Response('<html>', 200));
      expect(repo.getAll(), throwsA(isA<BadResponseException>()));
    });

    test('id as a string → BadResponseException', () {
      final repo = _repo(
        (_) => http.Response(jsonEncode({..._user, 'id': '1'}), 200),
      );
      expect(repo.getById(1), throwsA(isA<BadResponseException>()));
    });

    test('create POSTs JSON and expects 201', () async {
      late http.Request sent;
      final repo = _repo((r) {
        sent = r;
        final body = jsonDecode(r.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({...body, 'id': 11}), 201);
      });
      final u = await repo.create(
        const User.draft(name: 'A B', username: 'ab', email: 'a@b.kz'),
      );
      expect(sent.method, 'POST');
      expect(sent.headers['Content-Type'], startsWith('application/json'));
      expect(u.id, 11);
    });
  });
}
