import 'models.dart';

sealed class ShelfState {}

class Empty extends ShelfState {}

class Ready extends ShelfState {
  final List<Book> books;

  Ready(this.books);
}

class Broken extends ShelfState {
  final String message;

  Broken(this.message);
}

String describe(ShelfState state) => switch (state) {
  Empty() => 'Shelf is empty',
  Ready(:final books) => 'Ready with ${books.length} books',
  Broken(:final message) => 'Broken: $message',
};

({int count, double avgPages}) statsOf(List<Book> books) => (
  count: books.length,
  avgPages: books.isEmpty
      ? 0
      : books.fold<int>(0, (sum, book) => sum + book.pages) / books.length,
);
