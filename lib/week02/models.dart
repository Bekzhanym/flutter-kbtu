class Author{
  final String name;
  final String? country;

   const Author({
    required this.name,
    this.country,
  });
  
}

class Book{
  final String title;
  final int year;
  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  const Book.missing()
    : title = 'Unknown',
      year = 0,
      pages = 0,
      author = const Author(name: 'Unknown'),
      genre = Genre.unknown,
      description = null;

  factory Book.fromJson(Map<String, dynamic> json){
    return Book(
    title: json['title'] is String
        ? json['title'] as String
        : 'Unknown',
    
    year: json['year'] is int
          ?json['year'] as int
          :0,
    pages: json['pages'] is int
    ? json['pages'] as int
    :0,

    author: Author(
      name: json['author'] is String
          ? json['author'] as String
          : 'Unknown',
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
  required this.title,
  required this.year,
  required this.pages,
  required this.author,
  required this.genre,
  this.description,
});
  

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