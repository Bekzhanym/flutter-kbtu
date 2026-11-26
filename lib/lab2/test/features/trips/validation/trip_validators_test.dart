import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/features/trips/validation/trip_validators.dart';

void main() {
  test('budget', () {
    expect(TripValidators.budget(''), 'Enter a budget');
    expect(TripValidators.budget('abc'), 'Only digits, e.g. 250000');
    expect(TripValidators.budget('0'), 'The budget must be more than 0');
    expect(TripValidators.budget('250 000'), isNull);
    expect(TripValidators.parseBudget('1,250,000.5'), 1250000.5);
  });

  test('date', () {
    expect(TripValidators.date(null), 'Pick a date');
    expect(TripValidators.date(DateTime(2026)), isNull);
  });

  test('notes', () {
    expect(TripValidators.notes(null), isNull);
    expect(TripValidators.notes('x' * 501), 'At most 500 characters');
  });
}
