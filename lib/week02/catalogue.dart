import 'models.dart';

class Library {
  final List<LibraryItem> items = [];
  late final DateTime openedAt;
  String? _cachedReport;

  void add(LibraryItem item) {
    items.add(item);
  }

  void open() {
    openedAt = DateTime.now();
  }

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }
    return null;
  }

  String countryOf(String title) =>
      findByTitle(title)?.author.country ?? 'unknown';

  Iterable<Book> get books => items.whereType<Book>();

  List<String> get titles => items.map((item) => item.title).toList();

  List<Book> get booksAfter2010 =>
      books.where((book) => book.year > 2010).toList();

  double get averagePages => books.isEmpty
      ? 0
      : books.fold<int>(0, (sum, book) => sum + book.pages) / books.length;

  Map<String, int> get booksPerAuthor => books.fold<Map<String, int>>(
        {},
        (counts, book) => {
          ...counts,
          book.author.name: (counts[book.author.name] ?? 0) + 1,
        },
      );

  Set<String> get authorNames =>
      books.map((book) => book.author.name).toSet();

  Set<Genre> get genres => books.map((book) => book.genre).toSet();

  List<String> get displayLines => [
        'CATALOGUE',
        for (final book in books) '${book.title} (${book.year})',
        ...authorNames,
        if (books.any((book) => book.pages == 0)) '(incomplete data)',
      ];

  String report() {
    return _cachedReport ??= displayLines.join('\n');
  }
}
