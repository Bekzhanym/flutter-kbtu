import 'package:flutter/material.dart';

import 'screens/countdown_screen.dart';
import 'screens/home_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/students_future_screen.dart';
import 'screens/students_screen.dart';

abstract final class Routes {
  static const home = '/';
  static const byHand = '/by-hand';
  static const futureBuilder = '/future';
  static const countdown = '/countdown';

  static final Map<String, WidgetBuilder> table = {
    home: (_) => const HomeScreen(),
    byHand: (_) => const StudentsScreen(),
    futureBuilder: (_) => const StudentsFutureScreen(),
    countdown: (_) => const CountdownScreen(),
  };

  static Route<dynamic> onUnknownRoute(RouteSettings settings) =>
      MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => NotFoundScreen(name: settings.name),
      );
}
