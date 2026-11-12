import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../widgets/clear_cart_button.dart';
import '../widgets/total_label.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: const [ClearCartButton()],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<Cart>(
                builder: (context, cart, child) => Row(
                  children: [
                    child!,
                    const Spacer(),
                    Text(
                      '${cart.total} ₸',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                child: const TotalLabel(),
              ),
            ),
          ),
          Expanded(
            child: Consumer<Cart>(
              builder: (context, cart, _) => cart.count == 0
                  ? const Center(child: Text('Your cart is empty'))
                  : ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, i) {
                        final b = cart.items[i];
                        return ListTile(
                          title: Text(b.title),
                          subtitle: Text('${b.price} ₸'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'One fewer',
                                icon: const Icon(Icons.remove),
                                onPressed: () => cart.decrement(b),
                              ),
                              Text(
                                '×${cart.qtyOf(b)}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              IconButton(
                                tooltip: 'One more',
                                icon: const Icon(Icons.add),
                                onPressed: () => cart.increment(b),
                              ),
                              IconButton(
                                tooltip: 'Remove',
                                icon: const Icon(Icons.close),
                                onPressed: () => cart.remove(b),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
