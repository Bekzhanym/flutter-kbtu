import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week12/features/auth/providers/auth_provider.dart';
import 'package:week12/features/auth/screens/login_screen.dart';
import 'package:week12/features/settings/providers/settings_provider.dart';
import 'package:week12/features/users/screens/users_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Users API',
      debugShowCheckedModeBanner: false,
      themeMode: context.watch<SettingsProvider>().dark
          ? ThemeMode.dark
          : ThemeMode.light,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: context.watch<AuthProvider>().signedIn
          ? const UsersScreen()
          : const LoginScreen(),
    );
  }
}
