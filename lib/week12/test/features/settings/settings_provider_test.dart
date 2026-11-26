import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:week12/core/constants/storage_keys.dart';
import 'package:week12/features/settings/providers/settings_provider.dart';

void main() {
  late SharedPreferencesAsync prefs;

  setUp(() {
    // A fake "disk" in memory — no plugin, no device.
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    prefs = SharedPreferencesAsync();
  });

  test('setDark notifies before the disk write finishes', () async {
    final s = SettingsProvider(prefs, dark: false);
    var notified = 0;
    s.addListener(() => notified++);

    final write = s.setDark(true); // not awaited yet
    expect(s.dark, isTrue);
    expect(notified, 1); // the screen already knows

    await write;
    expect(await prefs.getBool(StorageKeys.darkMode), isTrue);
  });

  test('setCity writes the key, setCity(null) removes it', () async {
    final s = SettingsProvider(prefs, dark: false);

    await s.setCity('Gwenborough');
    expect(await prefs.getString(StorageKeys.cityFilter), 'Gwenborough');

    await s.setCity(null);
    expect(s.city, isNull);
    expect(await prefs.containsKey(StorageKeys.cityFilter), isFalse);
  });

  test(
    'an empty disk reads as null — main() turns it into a default',
    () async {
      expect(await prefs.getBool(StorageKeys.darkMode), isNull);
      expect(await prefs.getBool(StorageKeys.darkMode) ?? false, isFalse);
    },
  );
}
