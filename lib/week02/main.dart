import 'catalogue.dart';
import 'data.dart';
import 'models.dart';
import 'shelf_state.dart';

void main() {
  final library = Library();
  library.open();

  for (final raw in rawBooks) {
    library.add(Book.fromJson(raw));
  }

  print(library.report());
  print('titles: ${library.titles}');
  print('after 2010: ${library.booksAfter2010}');
  print('average pages: ${library.averagePages}');
  print('books per author: ${library.booksPerAuthor}');
  print('authors: ${library.authorNames}');
  print('genres: ${library.genres}');
  print('country of Design Patterns: ${library.countryOf('Design Patterns')}');
  print('country of Missing: ${library.countryOf('Missing')}');

  final stats = statsOf(library.books.toList());
  print('stats: count=${stats.count}, avgPages=${stats.avgPages}');

  print(describe(Empty()));
  print(describe(Ready(library.books.toList())));
  print(describe(Broken('shelf collapsed')));
}
