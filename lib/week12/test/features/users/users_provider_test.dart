import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:week12/core/network/api_client.dart';
import 'package:week12/core/storage/secure_store.dart';
import 'package:week12/features/users/providers/users_provider.dart';
import 'package:week12/features/users/repository/user_repository.dart';
import 'package:week12/features/users/users_cache.dart';

Map<String, dynamic> _user(int id, String city) => {
  'id': id,
  'name': 'User $id',
  'username': 'u$id',
  'email': 'u$id@test.kz',
  'address': {
    'street': 'S',
    'suite': 'A',
    'city': city,
    'zipcode': '0',
    'geo': {'lat': '0', 'lng': '0'},
  },
  'phone': '1',
  'website': null,
  'company': {'name': 'C', 'catchPhrase': 'P'},
};

void main() {
  late UsersProvider p;

  setUp(() async {
    final users = [_user(1, 'Almaty'), _user(2, 'Astana'), _user(3, 'Almaty')];
    FlutterSecureStorage.setMockInitialValues({});
    final api = ApiClient(
      MockClient((_) async => http.Response(jsonEncode(users), 200)),
      SecureStore(),
    );
    final cache = UsersCache(
      directory: () async => Directory.systemTemp.createTemp(),
    );
    p = UsersProvider(UserRepository(api, cache));
    await p.load();
  });

  test('cities are sorted and unique', () {
    expect(p.cities, ['Almaty', 'Astana']);
  });

  test('inCity(null) is everyone, inCity(city) filters', () {
    expect(p.inCity(null), hasLength(3));
    expect(p.inCity('Almaty').map((u) => u.id), [1, 3]);
    expect(p.inCity('Shymkent'), isEmpty);
  });
}
