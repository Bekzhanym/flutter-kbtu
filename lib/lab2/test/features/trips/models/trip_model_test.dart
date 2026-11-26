import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/core/json/json_path_exception.dart';
import 'package:trip_planner/features/trips/models/trip_model.dart';
import 'package:trip_planner/features/trips/models/trip_status.dart';

Map<String, dynamic> almaty() => {
  'id': '1',
  'countryCode': 'KAZ',
  'countryName': 'Kazakhstan',
  'startDate': '2026-12-01',
  'endDate': '2026-12-03',
  'budget': 250000,
  'notes': 'Shymbulak',
  'rating': null,
};

Matcher _badAt(String path) => throwsA(
  isA<JsonPathException>().having((e) => e.path, 'path', path),
);

void main() {
  test('fromJson reads every field', () {
    final t = Trip.fromJson(almaty());

    expect(t.id, '1');
    expect(t.countryCode, 'KAZ');
    expect(t.startDate, DateTime(2026, 12, 1));
    expect(t.budget, 250000.0);
    expect(t.notes, 'Shymbulak');
    expect(t.rating, isNull);
  });

  test('a MockAPI timestamp is cut to the calendar day', () {
    final t = Trip.fromJson(
      almaty()..['startDate'] = '2026-12-01T23:30:00.000Z',
    );
    expect(t.startDate, DateTime(2026, 12, 1));
  });

  test('toJson → fromJson round-trips', () {
    final t = Trip.fromJson(almaty()..['rating'] = 4);
    final again = Trip.fromJson(
      jsonDecode(jsonEncode(t.toJson())) as Map<String, dynamic>,
    );
    expect(again.toJson(), t.toJson());
    expect(t.toJson()['startDate'], '2026-12-01');
  });

  test('a draft sends no id — the server assigns it', () {
    final d = Trip.draft(
      countryCode: 'KAZ',
      countryName: 'Kazakhstan',
      startDate: DateTime(2026, 12, 1),
      endDate: DateTime(2026, 12, 3),
      budget: 1,
    );
    expect(d.isDraft, isTrue);
    expect(d.toJson().containsKey('id'), isFalse);
  });

  test('a wrong type names its field', () {
    expect(
      () => Trip.fromJson(almaty()..['budget'] = '250k'),
      _badAt('budget'),
    );
    expect(() => Trip.fromJson(almaty()..['id'] = 1), _badAt('id'));
    expect(
      () => Trip.fromJson(almaty()..['startDate'] = 'soon'),
      _badAt('startDate'),
    );
  });

  test('derived: days, status and days until start', () {
    final t = Trip.fromJson(almaty());

    expect(t.days, 3);
    expect(t.statusOn(DateTime(2026, 11, 25)), TripStatus.upcoming);
    expect(t.statusOn(DateTime(2026, 12, 3, 23, 59)), TripStatus.ongoing);
    expect(t.statusOn(DateTime(2026, 12, 4)), TripStatus.past);
    expect(t.daysUntil(DateTime(2026, 11, 25)), 6);
  });
}
