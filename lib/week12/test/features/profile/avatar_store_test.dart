import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:week12/core/constants/storage_keys.dart';
import 'package:week12/features/profile/avatar_store.dart';

void main() {
  late Directory docs;
  late Directory picked;
  late SharedPreferencesAsync prefs;
  late AvatarStore store;

  setUp(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    prefs = SharedPreferencesAsync();
    docs = await Directory.systemTemp.createTemp('docs_');
    picked = await Directory.systemTemp.createTemp('picker_');
    store = AvatarStore(prefs, directory: () async => docs);
  });

  tearDown(() async {
    await docs.delete(recursive: true);
    await picked.delete(recursive: true);
  });

  test('nothing picked yet → null', () async {
    expect(await store.load(), isNull);
  });

  test(
    'save copies into Documents/avatar.jpg and remembers the path',
    () async {
      final source = File('${picked.path}/IMG_1.jpg')..writeAsBytesSync([1, 2]);
      final path = await store.save(source.path);

      expect(path, '${docs.path}/avatar.jpg');
      expect(File(path).readAsBytesSync(), [1, 2]);
      expect(await prefs.getString(StorageKeys.avatarPath), path);
      expect(await store.load(), path);
    },
  );

  test('the picker file may vanish — our copy stays', () async {
    final source = File('${picked.path}/IMG_2.jpg')..writeAsBytesSync([3]);
    await store.save(source.path);
    await source.delete();
    expect(await store.load(), '${docs.path}/avatar.jpg');
  });

  test('a stale saved path falls back to Documents/avatar.jpg', () async {
    File('${docs.path}/avatar.jpg').writeAsBytesSync([4]);
    await prefs.setString(StorageKeys.avatarPath, '/old/container/avatar.jpg');
    expect(await store.load(), '${docs.path}/avatar.jpg');
  });
}
