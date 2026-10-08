import 'package:flutter/material.dart';

class DiscardChangesDialog extends StatelessWidget {
  const DiscardChangesDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
    backgroundColor: Colors.white,
    title: const Text('Discard changes?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('Keep editing'),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: const Text('Discard'),
      ),
    ],
  );
}
