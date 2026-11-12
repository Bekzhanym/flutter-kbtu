import 'package:flutter/material.dart';

import 'screens/sign_up_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4169E1),
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      ),
    ),
    home: const SignUpScreen(),
  );
}
