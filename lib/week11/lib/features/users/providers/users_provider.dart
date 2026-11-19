import 'package:flutter/foundation.dart';
import 'package:week11/core/errors/api_exception.dart';
import 'package:week11/features/users/models/user_model.dart';
import 'package:week11/features/users/repository/user_repository.dart';

class UsersProvider extends ChangeNotifier {
  UsersProvider(this._repo);

  final UserRepository _repo;

  List<User> items = const [];
  ApiException? error;
  bool loading = false;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      items = await _repo.getAll();
    } on ApiException catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<User> create(User draft) async {
    final user = await _repo.create(draft);
    items = [user, ...items];
    notifyListeners();
    return user;
  }
}
