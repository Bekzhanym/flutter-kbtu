import 'package:flutter_test/flutter_test.dart';

import 'package:week8/models/book.dart';

void main() {
  test('seed totals', () {
    expect(totalPages(seed), 1220);
    expect(unread(seed).length, 4);
    expect(authors(seed).length, 5);
  });

  test('fromMap without year hides the parentheses', () {
    final book = Book.fromMap({'title': 'X', 'author': 'Y', 'pages': 10});
    expect(book.year, isNull);
    expect(book.read, isFalse);
    expect(book.toString(), 'X — Y, 10 pp.');
  });

  test('toString with year', () {
    expect(
      seed[1].toString(),
      'Null Safety for Humans — B. Seitkali, 196 pp. (2022)',
    );
  });

  test('authors keeps order and drops duplicates', () {
    final books = [
      Book(title: 'A', author: 'One', pages: 1),
      Book(title: 'B', author: 'Two', pages: 1),
      Book(title: 'C', author: 'One', pages: 1),
    ];
    expect(authors(books), ['One', 'Two']);
  });
}
