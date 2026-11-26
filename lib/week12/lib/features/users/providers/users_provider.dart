import 'package:flutter/foundation.dart';
import 'package:week12/core/errors/api_exception.dart';
import 'package:week12/features/users/models/user_model.dart';
import 'package:week12/features/users/repository/user_repository.dart';

class UsersProvider extends ChangeNotifier {
  UsersProvider(this._repo);

  final UserRepository _repo;

  List<User> items = const [];
  ApiException? error;
  bool loading = false;
  bool fromCache = false;

  /// Every city in the loaded list, sorted, each once — for the dropdown.
  List<String> get cities =>
      ({for (final u in items) u.address.city}).toList()..sort();

  /// The list the screen shows: all users, or only those in [city].
  List<User> inCity(String? city) => city == null
      ? items
      : [
          for (final u in items)
            if (u.address.city == city) u,
        ];

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final result = await _repo.getAll();
      items = result.items;
      fromCache = result.fromCache;
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
