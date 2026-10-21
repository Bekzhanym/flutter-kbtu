import '../enums/language.dart';

const meetupLength = Duration(minutes: 90);

class Meetup {
  const Meetup({
    required this.id,
    required this.title,
    required this.language,
    required this.startsAt,
    required this.capacity,
    required this.place,
    this._members = const [],
    this.online = false,
    this.notes,
    this.favourite = false,
  });

  Meetup.empty()
    : id = '',
      title = '',
      language = Language.english,
      startsAt = _tomorrowEvening(),
      capacity = 10,
      place = '',
      _members = const [],
      online = false,
      notes = null,
      favourite = false;

  final String id;
  final String title;
  final Language language;
  final DateTime startsAt;

  final int capacity;

  final String place;
  final List<String> _members;
  final bool online;
  final String? notes;
  final bool favourite;

  List<String> get members => List.unmodifiable(_members);

  int get count => _members.length;
  int get free => capacity > count ? capacity - count : 0;
  bool get isFull => count >= capacity;
  DateTime get endsAt => startsAt.add(meetupLength);
  bool get isPast => DateTime.now().isAfter(endsAt);

  ({int taken, int free}) get places => (taken: count, free: free);

  bool contains(String name) {
    final wanted = name.trim().toLowerCase();
    return wanted.isNotEmpty && _members.any((m) => m.toLowerCase() == wanted);
  }

  Meetup withMember(String name) =>
      copyWith(members: [..._members, name.trim()]);

  Meetup withoutMember(String name) {
    final gone = name.trim().toLowerCase();
    return copyWith(
      members: _members.where((m) => m.toLowerCase() != gone).toList(),
    );
  }

  Meetup copyWith({
    String? id,
    String? title,
    Language? language,
    DateTime? startsAt,
    int? capacity,
    String? place,
    List<String>? members,
    bool? online,
    String? notes,
    bool? favourite,
  }) => Meetup(
    id: id ?? this.id,
    title: title ?? this.title,
    language: language ?? this.language,
    startsAt: startsAt ?? this.startsAt,
    capacity: capacity ?? this.capacity,
    place: place ?? this.place,
    members: members ?? _members,
    online: online ?? this.online,
    notes: notes ?? this.notes,
    favourite: favourite ?? this.favourite,
  );

  static DateTime _tomorrowEvening() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1, 18);
  }
}

List<Meetup> sortByDate(Iterable<Meetup> meetups) => [...meetups]
  ..sort((a, b) {
    if (a.isPast != b.isPast) return a.isPast ? 1 : -1;
    return a.startsAt.compareTo(b.startsAt);
  });
