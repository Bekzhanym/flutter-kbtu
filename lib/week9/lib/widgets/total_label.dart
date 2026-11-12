import 'package:flutter/material.dart';

class TotalLabel extends StatelessWidget {
  const TotalLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.receipt_long_outlined),
        const SizedBox(width: 8),
        Text('Total', style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
