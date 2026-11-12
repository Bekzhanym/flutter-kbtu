import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';

class ClearCartButton extends StatelessWidget {
  const ClearCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final empty = context.select<Cart, bool>((c) => c.count == 0);
    return IconButton(
      tooltip: 'Clear cart',
      icon: const Icon(Icons.delete_sweep_outlined),
      onPressed: empty ? null : () => _confirm(context),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('Every book will be removed from the cart.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    if (yes ?? false) context.read<Cart>().clear();
  }
}
