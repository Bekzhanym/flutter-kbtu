import 'package:flutter/foundation.dart';
import 'package:week12/core/storage/secure_store.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(
    this._store, {
    this._token,
    this.delay = const Duration(seconds: 1),
  });

  static const int minPasswordLength = 8;

  final SecureStore _store;
  final Duration delay;

  String? _token;
  bool loading = false;
  String? error;

  bool get signedIn => _token != null;

  String? get token => _token;

  Future<void> login(String email, String password) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await Future<void>.delayed(delay);
      if (password.length < minPasswordLength) {
        error = 'Wrong email or password.';
        return;
      }
      final token = 'tok_${email.trim().toLowerCase().hashCode}';
      await _store.saveToken(token);
      _token = token;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _store.clear();
    _token = null;
    notifyListeners();
  }
}
