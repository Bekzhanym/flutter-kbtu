class Author {
  final String name;
  final String? country;

  const Author({required this.name, this.country});

  @override
  String toString() => country == null ? name : '$name ($country)';
}

abstract class LibraryItem {
  final String title;
  final int year;
  const LibraryItem({required this.title, required this.year});
  String describe();
  bool get isOld => year < 2000;
}

mixin Borrowable on LibraryItem {
  String borrowLabel() => 'Borrow $title';
}

class Magazine extends LibraryItem {
  final String issue;

  const Magazine({
    required super.title,
    required super.year,
    required this.issue,
  });

  @override
  String describe() => '$title, issue $issue ($year)';
}

class Ghost implements LibraryItem {
  @override
  final String title;

  @override
  final int year;

  const Ghost({required this.title, required this.year});

  @override
  String describe() {
    return 'Ghost: $title, published in $year';
  }

  @override
  bool get isOld => year < DateTime.now().year - 50;
}

class Book extends LibraryItem with Borrowable {
  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  const Book.missing()
    : pages = 0,
      author = const Author(name: 'Unknown'),
      genre = Genre.unknown,
      description = null,
      super(title: 'Unknown', year: 0);

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] is String ? json['title'] as String : 'Unknown',

      year: json['year'] is int ? json['year'] as int : 0,
      pages: json['pages'] is int ? json['pages'] as int : 0,

      author: Author(
        name: json['author'] is String ? json['author'] as String : 'Unknown',
        country: json['country'] is String ? json['country'] as String : null,
      ),

      genre: Genre.fromString(
        json['genre'] is String ? json['genre'] as String : null,
      ),

      description: json['description'] is String
          ? json['description'] as String
          : null,
    );
  }
  const Book({
    required super.title,
    required super.year,
    required this.pages,
    required this.author,
    required this.genre,
    this.description,
  });

  @override
  String describe() => '$title by ${author.name} ($year)';

  bool get isLong => pages > 400;

  Book copyWith({
    String? title,
    int? year,
    int? pages,
    Author? author,
    Genre? genre,
    String? description,
  }) {
    return Book(
      title: title ?? this.title,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      description: description ?? this.description,
    );
  }

  @override
  String toString() => '$title ($year) — $author, $pages p., ${genre.label}';
}

enum Genre {
  craft('Craft'),
  theory('Theory'),
  unknown('Unknown');

  final String label;

  const Genre(this.label);

  static Genre fromString(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'craft':
        return Genre.craft;

      case 'theory':
        return Genre.theory;

      default:
        return Genre.unknown;
    }
  }
}
