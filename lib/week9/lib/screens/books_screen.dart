import 'package:flutter/material.dart';

import '../models/book.dart';
import '../widgets/book_row.dart';
import '../widgets/cart_badge.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final _search = TextEditingController();

  final _rows = {
    for (final b in books) b: BookRow(key: ValueKey(b), book: b),
  };

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Book> _filter(String query) {
    final q = query.trim().toLowerCase();
    return books
        .where(
          (b) =>
              b.title.toLowerCase().contains(q) ||
              b.author.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: const [CartBadge()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                hintText: 'Search by title or author',
                prefixIcon: Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(28)),
                  borderSide: BorderSide.none,
                ),
                isDense: true,
              ),
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _search,
        builder: (context, value, _) {
          final shown = _filter(value.text);
          if (shown.isEmpty) {
            return const Center(child: Text('Nothing found'));
          }
          return ListView.builder(
            itemCount: shown.length,
            itemBuilder: (context, i) => _rows[shown[i]]!,
            findChildIndexCallback: (key) {
              final i = shown.indexWhere((b) => ValueKey(b) == key);
              return i < 0 ? null : i;
            },
          );
        },
      ),
    );
  }
}
