import 'package:flutter/material.dart';

import 'routes.dart';

class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Shop',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
    ),
    initialRoute: Routes.home,
    routes: Routes.table,
    onUnknownRoute: Routes.onUnknownRoute,
  );
}
