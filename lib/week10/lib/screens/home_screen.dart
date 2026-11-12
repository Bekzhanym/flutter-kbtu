import 'package:flutter/material.dart';

import '../routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('The Data Arrives Later')),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          _NavButton(label: 'By hand', route: Routes.byHand),
          _NavButton(label: 'FutureBuilder', route: Routes.futureBuilder),
          _NavButton(label: 'Countdown', route: Routes.countdown),
        ],
      ),
    ),
  );
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.label, required this.route});

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 220,
    child: FilledButton(
      onPressed: () => Navigator.pushNamed(context, route).ignore(),
      child: Text(label),
    ),
  );
}
