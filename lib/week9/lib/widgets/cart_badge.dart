import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../routes.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final n = context.select<Cart, int>((c) => c.count);
    return IconButton(
      tooltip: 'Cart',
      onPressed: () => Navigator.of(context).pushNamed(Routes.cartScreen),
      icon: Badge(
        label: Text('$n'),
        child: const Icon(Icons.shopping_cart_outlined),
      ),
    );
  }
}
