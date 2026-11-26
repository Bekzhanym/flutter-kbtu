import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week12/app.dart';
import 'package:week12/core/constants/storage_keys.dart';
import 'package:week12/core/get_it/injection_container.dart';
import 'package:week12/core/storage/secure_store.dart';
import 'package:week12/dev/checks.dart';
import 'package:week12/features/auth/providers/auth_provider.dart';
import 'package:week12/features/profile/avatar_store.dart';
import 'package:week12/features/profile/providers/profile_provider.dart';
import 'package:week12/features/settings/providers/settings_provider.dart';
import 'package:week12/features/users/providers/users_provider.dart';

const _runChecks = bool.fromEnvironment('CHECKS');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  if (_runChecks) await runChecks();

  final prefs = getIt<SharedPreferencesAsync>();
  final dark = await prefs.getBool(StorageKeys.darkMode) ?? false;
  final city = await prefs.getString(StorageKeys.cityFilter);
  final token = await getIt<SecureStore>().readToken();
  final avatar = await getIt<AvatarStore>().load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(getIt<SecureStore>(), token: token),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(prefs, dark: dark, city: city),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              ProfileProvider(getIt<AvatarStore>(), avatarPath: avatar),
        ),
        ChangeNotifierProvider(create: (_) => getIt<UsersProvider>()..load()),
      ],
      child: const App(),
    ),
  );
}
