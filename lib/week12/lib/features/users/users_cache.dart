import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:week12/features/users/models/user_model.dart';

class UsersCache {
  UsersCache({Future<Directory> Function()? directory})
    : _directory = directory ?? getApplicationDocumentsDirectory;

  static const fileName = 'users.json';

  final Future<Directory> Function() _directory;

  Future<File> _file() async => File('${(await _directory()).path}/$fileName');

  Future<void> save(List<User> users) async {
    final file = await _file();
    await file.writeAsString(jsonEncode([for (final u in users) u.toJson()]));
  }

  Future<List<User>?> load() async {
    final file = await _file();
    if (!await file.exists()) return null;
    try {
      final json = jsonDecode(await file.readAsString()) as List<dynamic>;
      return [for (final e in json) User.fromJson(e as Map<String, dynamic>)];
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }
}
