import 'package:week11/core/constants/app_constants.dart';
import 'package:week11/core/errors/api_exception.dart';
import 'package:week11/core/network/api_client.dart';
import 'package:week11/features/users/models/user_model.dart';

class UserRepository {
  UserRepository(this._api);

  final ApiClient _api;

  Future<List<User>> getAll() async {
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
