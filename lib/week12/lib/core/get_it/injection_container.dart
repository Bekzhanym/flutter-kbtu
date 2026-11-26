import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week12/core/network/api_client.dart';
import 'package:week12/core/storage/secure_store.dart';
import 'package:week12/features/profile/avatar_store.dart';
import 'package:week12/features/users/providers/users_provider.dart';
import 'package:week12/features/users/repository/user_repository.dart';
import 'package:week12/features/users/users_cache.dart';

final getIt = GetIt.instance;

void init() {
  getIt.registerLazySingleton<SharedPreferencesAsync>(
    SharedPreferencesAsync.new,
  );
  getIt.registerLazySingleton<SecureStore>(SecureStore.new);
  getIt.registerLazySingleton<UsersCache>(UsersCache.new);
  getIt.registerLazySingleton<AvatarStore>(
    () => AvatarStore(getIt<SharedPreferencesAsync>()),
  );

  getIt.registerLazySingleton<Client>(Client.new, dispose: (c) => c.close());
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(getIt<Client>(), getIt<SecureStore>()),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(getIt<ApiClient>(), getIt<UsersCache>()),
  );
  getIt.registerFactory<UsersProvider>(
    () => UsersProvider(getIt<UserRepository>()),
  );
}
