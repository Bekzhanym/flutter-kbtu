import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/features/trips/models/trip_model.dart';
import 'package:trip_planner/features/trips/providers/trips_provider.dart';
import 'package:trip_planner/features/trips/repository/fake_trip_repository.dart';

Trip _draft() => Trip.draft(
  countryCode: 'FRA',
  countryName: 'France',
  startDate: DateTime(2027, 5, 1),
  endDate: DateTime(2027, 5, 7),
  budget: 900000,
);

void main() {
  test('load → data, sorted by country name', () async {
    final p = TripsProvider(FakeTripRepository());
    await p.load();
    expect(p.items.map((t) => t.countryName), [
      'Georgia',
      'Japan',
      'Kazakhstan',
    ]);
    expect(p.error, isNull);
  });

  test('load → NoConnection is kept as the error', () async {
    final p = TripsProvider(
      FakeTripRepository(failWith: const NoConnectionException()),
    );
    await p.load();
    expect(p.error, isA<NoConnectionException>());
    expect(p.items, isEmpty);
  });

  test('create adds what the server returned, with its id', () async {
    final p = TripsProvider(FakeTripRepository());
    await p.load();
    final saved = await p.create(_draft());
    expect(saved.id, '4');
    expect(p.items, contains(saved));
    expect(p.saving, isFalse);
  });

  test('saving is true while a request is in flight', () async {
    final p = TripsProvider(
      FakeTripRepository(delay: const Duration(milliseconds: 10)),
    );
    final f = p.create(_draft());
    expect(p.saving, isTrue);
    await f;
    expect(p.saving, isFalse);
  });

  test('update replaces the trip with the server answer', () async {
    final p = TripsProvider(FakeTripRepository());
    await p.load();
    final japan = p.items.firstWhere((t) => t.countryCode == 'JPN');
    await p.update(japan.copyWith(budget: 1));
    expect(p.items.firstWhere((t) => t.id == japan.id).budget, 1);
  });

  test('delete removes only after the server said yes', () async {
    final repo = FakeTripRepository();
    final p = TripsProvider(repo);
    await p.load();

    repo.failWith = const ServerException(500);
    await expectLater(p.delete('1'), throwsA(isA<ServerException>()));
    expect(p.count, 3);

    repo.failWith = null;
    await p.delete('1');
    expect(p.count, 2);
  });
}
