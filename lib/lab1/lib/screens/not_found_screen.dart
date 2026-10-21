import 'package:flutter/material.dart';

import '../widgets/empty_state.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, this.name});

  final String? name;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Not found')),
    body: EmptyState(
      icon: Icons.explore_off,
      message: name == null ? 'Not found' : 'Not found: $name',
    ),
  );
}
