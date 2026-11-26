import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:week12/core/errors/api_exception.dart';
import 'package:week12/core/network/api_client.dart';
import 'package:week12/core/storage/secure_store.dart';
import 'package:week12/features/users/repository/user_repository.dart';
import 'package:week12/features/users/users_cache.dart';

Map<String, dynamic> _user(int id) => {
  'id': id,
  'name': 'User $id',
  'username': 'u$id',
  'email': 'u$id@test.kz',
  'address': {
    'street': 'S',
    'suite': 'A',
    'city': 'Almaty',
    'zipcode': '0',
    'geo': {'lat': '0', 'lng': '0'},
  },
  'phone': '1',
  'website': null,
  'company': {'name': 'C', 'catchPhrase': 'P'},
};

void main() {
  late Directory dir;
  late UsersCache cache;
  var online = true;

  UserRepository repo() => UserRepository(
    ApiClient(
      MockClient((_) async {
        if (!online) throw const SocketException('airplane mode');
        return http.Response(jsonEncode([_user(1), _user(2)]), 200);
      }),
      SecureStore(),
    ),
    cache,
  );

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    dir = await Directory.systemTemp.createTemp('users_cache_');
    cache = UsersCache(directory: () async => dir);
    online = true;
  });

  tearDown(() => dir.delete(recursive: true));

  test('online: fresh data, saved to users.json', () async {
    final r = await repo().getAll();
    expect(r.fromCache, isFalse);
    expect(r.items, hasLength(2));
    expect(File('${dir.path}/users.json').existsSync(), isTrue);
  });

  test('offline after one good load: the saved list, fromCache', () async {
    await repo().getAll();
    online = false;
    final r = await repo().getAll();
    expect(r.fromCache, isTrue);
    expect(r.items.map((u) => u.id), [1, 2]);
  });

  test('offline with nothing saved: rethrow, not an empty list', () {
    online = false;
    expect(repo().getAll(), throwsA(isA<NoConnectionException>()));
  });

  test('a broken file counts as nothing saved', () async {
    await File('${dir.path}/users.json').writeAsString('{not json');
    online = false;
    expect(repo().getAll(), throwsA(isA<NoConnectionException>()));
  });
}
