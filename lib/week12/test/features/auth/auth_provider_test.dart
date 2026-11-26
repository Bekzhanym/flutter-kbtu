import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week12/core/storage/secure_store.dart';
import 'package:week12/features/auth/providers/auth_provider.dart';

void main() {
  late SecureStore store;
  late AuthProvider auth;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    store = SecureStore();
    auth = AuthProvider(store, delay: Duration.zero);
  });

  test('a short password is refused and nothing is stored', () async {
    await auth.login('a@b.kz', '1234567');
    expect(auth.signedIn, isFalse);
    expect(auth.error, isNotNull);
    expect(await store.readToken(), isNull);
  });

  test('8+ characters sign in and the token goes to secure storage', () async {
    await auth.login('a@b.kz', '12345678');
    expect(auth.signedIn, isTrue);
    expect(auth.token, startsWith('tok_'));
    expect(await store.readToken(), auth.token);
  });

  test('loading is true while the fake request is in flight', () async {
    final slow = AuthProvider(store, delay: const Duration(milliseconds: 10));
    final f = slow.login('a@b.kz', '12345678');
    expect(slow.loading, isTrue);
    await f;
    expect(slow.loading, isFalse);
  });

  test('logout deletes the token', () async {
    await auth.login('a@b.kz', '12345678');
    await auth.logout();
    expect(auth.signedIn, isFalse);
    expect(await store.readToken(), isNull);
  });

  test('a token read at startup means signed in', () {
    expect(AuthProvider(store, token: 'tok_1').signedIn, isTrue);
  });
}
