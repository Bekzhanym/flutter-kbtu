import 'package:flutter/material.dart';

import 'routes.dart';

class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Students',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    ),
    initialRoute: Routes.home,
    routes: Routes.table,
    onUnknownRoute: Routes.onUnknownRoute,
  );
}
