class TripValidators {
  TripValidators._();

  static const int notesMax = 500;

  static double? parseBudget(String? text) =>
      double.tryParse((text ?? '').replaceAll(RegExp(r'[\s,]'), ''));

  static String? budget(String? text) {
    if (text == null || text.trim().isEmpty) return 'Enter a budget';
    final value = parseBudget(text);
    if (value == null) return 'Only digits, e.g. 250000';
    if (value <= 0) return 'The budget must be more than 0';
    return null;
  }

  static String? date(DateTime? value) => value == null ? 'Pick a date' : null;

  static String? notes(String? text) =>
      (text ?? '').length > notesMax ? 'At most $notesMax characters' : null;
}
