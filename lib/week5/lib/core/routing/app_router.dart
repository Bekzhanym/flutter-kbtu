import 'package:flutter/material.dart';

import 'package:week5/core/models/student.dart';
import 'package:week5/core/routing/routes.dart';
import 'package:week5/features/edit_student/screens/edit_screen.dart';
import 'package:week5/features/student_detail/screens/detail_screen.dart';

abstract final class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) =>
      switch (settings.name) {
        Routes.student => MaterialPageRoute<Student>(
          settings: settings,
          builder: (_) => DetailScreen(student: settings.arguments as Student),
        ),
        Routes.edit => MaterialPageRoute<Student>(
          settings: settings,
          builder: (_) => EditScreen(student: settings.arguments as Student),
        ),
        _ => null,
      };
}
