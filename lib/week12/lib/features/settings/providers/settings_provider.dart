import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week12/core/constants/storage_keys.dart';

/// Initial values come from main(), which reads them before runApp —
/// so the first frame already has the right theme.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._prefs, {required this._dark, this._city});

  final SharedPreferencesAsync _prefs;

  bool _dark;
  String? _city;

  bool get dark => _dark;
  String? get city => _city;

  Future<void> setDark(bool v) async {
    _dark = v;
    notifyListeners(); // the screen first, the disk after
    await _prefs.setBool(StorageKeys.darkMode, v);
  }

  Future<void> setCity(String? c) async {
    _city = c;
    notifyListeners();
    if (c == null) {
      await _prefs.remove(StorageKeys.cityFilter);
    } else {
      await _prefs.setString(StorageKeys.cityFilter, c);
    }
  }
}
