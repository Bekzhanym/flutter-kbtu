import 'package:flutter/material.dart';

import 'models/book.dart';
import 'models/book_action.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.book});

  final Book book;

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Delete '${book.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    Navigator.of(context).pop(BookAction.delete);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final year = book.year;

    return Scaffold(
      appBar: AppBar(title: const Text('Book')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(book.title, style: text.headlineSmall),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(book.author),
            subtitle: const Text('Author'),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: Text('${book.pages}'),
            subtitle: const Text('Pages'),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(year == null ? 'Year unknown' : '$year'),
            subtitle: const Text('Year'),
          ),
          ListTile(
            leading: Icon(book.read ? Icons.check_circle : Icons.circle),
            title: Text(book.read ? 'Read' : 'Unread'),
            subtitle: const Text('Status'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(BookAction.toggleRead),
            child: Text(book.read ? 'Mark as unread' : 'Mark as read'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => _delete(context),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
