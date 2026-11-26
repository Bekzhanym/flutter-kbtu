import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week12/core/constants/storage_keys.dart';

class AvatarStore {
  AvatarStore(this._prefs, {Future<Directory> Function()? directory})
    : _directory = directory ?? getApplicationDocumentsDirectory;

  static const fileName = 'avatar.jpg';

  final SharedPreferencesAsync _prefs;
  final Future<Directory> Function() _directory;

  Future<File> _target() async =>
      File('${(await _directory()).path}/$fileName');

  Future<String> save(String sourcePath) async {
    final target = await _target();
    await File(sourcePath).copy(target.path);
    await _prefs.setString(StorageKeys.avatarPath, target.path);
    return target.path;
  }

  Future<String?> load() async {
    final saved = await _prefs.getString(StorageKeys.avatarPath);
    if (saved != null && await File(saved).exists()) return saved;
    final target = await _target();
    return await target.exists() ? target.path : null;
  }
}
