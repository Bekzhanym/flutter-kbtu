import 'package:week12/core/constants/app_constants.dart';
import 'package:week12/core/errors/api_exception.dart';
import 'package:week12/core/network/api_client.dart';
import 'package:week12/features/users/models/user_model.dart';
import 'package:week12/features/users/models/users_result.dart';
import 'package:week12/features/users/users_cache.dart';

class UserRepository {
  UserRepository(this._api, this._cache);

  final ApiClient _api;
  final UsersCache _cache;

  Future<UsersResult> getAll() async {
    try {
      final fresh = await _fetch();
      await _cache.save(fresh);
      return (items: fresh, fromCache: false);
    } on NoConnectionException {
      final saved = await _cache.load();
      if (saved == null) rethrow;
      return (items: saved, fromCache: true);
    }
  }

  Future<List<User>> _fetch() async {
    final json = await _api.get(AppConstants.users);
    return _parse(
      'users',
      () => (json as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<User> getById(int id) async {
    final json = await _api.get(AppConstants.userById(id));
    return _parse(
      'users/$id',
      () => User.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<User> create(User draft) async {
    final json = await _api.post(
      AppConstants.users,
      draft.toJson()..remove('id'),
    );
    return _parse(
      'users (POST)',
      () => User.fromJson(json as Map<String, dynamic>),
    );
  }

  T _parse<T>(String path, T Function() parse) {
    try {
      return parse();
    } on TypeError catch (e) {
      throw BadResponseException('$path: $e');
    } on FormatException catch (e) {
      throw BadResponseException('$path: ${e.message}');
    }
  }
}
