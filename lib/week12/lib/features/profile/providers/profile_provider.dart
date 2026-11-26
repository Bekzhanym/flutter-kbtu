import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:week12/features/profile/avatar_store.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider(this._store, {this.avatarPath});

  final AvatarStore _store;

  String? avatarPath;

  Future<void> setPhoto(String pickedPath) async {
    final path = await _store.save(pickedPath);
    await FileImage(File(path)).evict();
    avatarPath = path;
    notifyListeners();
  }
}
