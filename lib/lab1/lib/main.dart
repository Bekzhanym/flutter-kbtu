import 'package:flutter/material.dart';

import 'routes.dart';
import 'screens/shell_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _seed = Color(0xFF4169E1);

  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) => setState(() => _themeMode = mode);

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Language Exchange',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      ),
    ),
    darkTheme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: Brightness.dark,
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      ),
    ),
    themeMode: _themeMode,
    initialRoute: Routes.home,
    routes: {
      Routes.home: (_) =>
          ShellScreen(themeMode: _themeMode, onThemeModeChanged: _setThemeMode),
    },
    onGenerateRoute: Routes.onGenerateRoute,
    onUnknownRoute: Routes.onUnknownRoute,
  );
}
