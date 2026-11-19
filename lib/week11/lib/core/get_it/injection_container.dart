import 'package:get_it/get_it.dart';
import 'package:week11/core/network/api_client.dart';
import 'package:week11/features/users/providers/users_provider.dart';
import 'package:week11/features/users/repository/user_repository.dart';

final getIt = GetIt.instance;

void init() {
  getIt.registerLazySingleton<Client>(Client.new, dispose: (c) => c.close());
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Client>()));

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(getIt<ApiClient>()),
  );
  getIt.registerFactory<UsersProvider>(
    () => UsersProvider(getIt<UserRepository>()),
  );
}
