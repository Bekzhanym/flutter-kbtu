import 'package:flutter/material.dart';

import 'package:week5/core/routing/app_router.dart';
import 'package:week5/core/routing/routes.dart';
import 'package:week5/features/students/screens/students_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      canvasColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.white,
      ),
      dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
    ),
    initialRoute: Routes.students,
    routes: {Routes.students: (_) => const StudentsScreen()},
    onGenerateRoute: AppRouter.onGenerateRoute,
  );
}
