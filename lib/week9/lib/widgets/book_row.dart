import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../models/cart.dart';

class BookRow extends StatelessWidget {
  const BookRow({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final b = book;
    final inCart = context.select<Cart, bool>((c) => c.qtyOf(b) > 0);
    return ListTile(
      title: Text(b.title),
      subtitle: Text('${b.author} · ${b.price} ₸'),
      trailing: inCart
          ? const Text('Added')
          : OutlinedButton(
              onPressed: () => _add(context),
              child: const Text('Add'),
            ),
    );
  }

  void _add(BuildContext context) {
    final ok = context.read<Cart>().add(book);
    if (!ok) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Added "${book.title}"')));
  }
}
