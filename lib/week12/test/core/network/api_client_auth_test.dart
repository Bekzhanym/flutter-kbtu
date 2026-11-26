import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:week12/core/network/api_client.dart';
import 'package:week12/core/storage/secure_store.dart';

Future<Map<String, String>> _headersSent() async {
  late Map<String, String> headers;
  final api = ApiClient(
    MockClient((r) async {
      headers = r.headers;
      return http.Response('[]', 200);
    }),
    SecureStore(),
  );
  await api.get('/users');
  return headers;
}

void main() {
  test('no token → no Authorization header', () async {
    FlutterSecureStorage.setMockInitialValues({});
    expect((await _headersSent()).containsKey('Authorization'), isFalse);
  });

  test('a stored token → Authorization: Bearer …', () async {
    FlutterSecureStorage.setMockInitialValues({'token': 'tok_42'});
    expect((await _headersSent())['Authorization'], 'Bearer tok_42');
  });
}
