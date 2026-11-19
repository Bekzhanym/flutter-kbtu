import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week11/app.dart';
import 'package:week11/core/get_it/injection_container.dart';
import 'package:week11/dev/checks.dart';
import 'package:week11/features/users/providers/users_provider.dart';

const _runChecks = bool.fromEnvironment('CHECKS');

Future<void> main() async {
  init();
  if (_runChecks) await runChecks();

  runApp(
    ChangeNotifierProvider(
      create: (_) => getIt<UsersProvider>()..load(),
      child: const App(),
    ),
  );
}
