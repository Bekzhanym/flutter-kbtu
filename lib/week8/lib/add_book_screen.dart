import 'package:flutter/material.dart';

import 'models/book.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _author = TextEditingController();
  final _pages = TextEditingController();
  final _year = TextEditingController();

  @override
  void dispose() {
    for (final c in [_title, _author, _pages, _year]) {
      c.dispose();
    }
    super.dispose();
  }

  void _unfocus(PointerDownEvent _) =>
      FocusManager.instance.primaryFocus?.unfocus();

  String? _validateTitle(String? v) =>
      (v ?? '').trim().length < 2 ? 'At least 2 characters' : null;

  String? _validateAuthor(String? v) =>
      (v ?? '').trim().isEmpty ? 'Author is required' : null;

  String? _validatePages(String? v) {
    final n = int.tryParse((v ?? '').trim());
    if (n == null || n <= 0) return 'A whole number above 0';
    return null;
  }

  String? _validateYear(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return null;
    final now = DateTime.now().year;
    final n = int.tryParse(s);
    if (n == null || n < 1450 || n > now) return 'A year from 1450 to $now';
    return null;
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        title: _title.text.trim(),
        author: _author.text.trim(),
        pages: int.parse(_pages.text.trim()),
        year: int.tryParse(_year.text.trim()),
      );
      Navigator.of(context).pop(book);
    }
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Add book')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              onTapOutside: _unfocus,
              validator: _validateTitle,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _author,
              decoration: const InputDecoration(labelText: 'Author'),
              textInputAction: TextInputAction.next,
              onTapOutside: _unfocus,
              validator: _validateAuthor,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _pages,
              decoration: const InputDecoration(labelText: 'Pages'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onTapOutside: _unfocus,
              validator: _validatePages,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _year,
              decoration: const InputDecoration(
                labelText: 'Year',
                helperText: 'Optional',
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _save(),
              onTapOutside: _unfocus,
              validator: _validateYear,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    ),
  );
}
