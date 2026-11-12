import 'package:flutter/material.dart';

import '../models/book.dart';
import 'stat_column.dart';

class LibraryHeader extends StatelessWidget {
  const LibraryHeader({super.key, required this.books});

  final List<Book> books;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: StatColumn(value: books.length, label: 'Books'),
          ),
          Expanded(
            child: StatColumn(value: totalPages(books), label: 'Pages'),
          ),
          Expanded(
            child: StatColumn(value: unread(books).length, label: 'Unread'),
          ),
        ],
      ),
    ),
  );
}
