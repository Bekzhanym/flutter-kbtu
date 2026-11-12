import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, this.name});

  final String? name;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Not found')),
    body: Center(
      child: Text(name == null ? 'Not found' : 'Not found: $name'),
    ),
  );
}
