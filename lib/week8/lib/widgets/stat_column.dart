import 'package:flutter/material.dart';

class StatColumn extends StatelessWidget {
  const StatColumn({super.key, required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Text('$value', style: text.headlineSmall),
        Text(label, style: text.bodySmall),
      ],
    );
  }
}
