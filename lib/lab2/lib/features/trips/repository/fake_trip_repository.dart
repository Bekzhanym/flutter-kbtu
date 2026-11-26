import 'dart:math';

import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/features/trips/models/trip_model.dart';
import 'package:trip_planner/features/trips/repository/trip_repository.dart';

class FakeTripRepository implements TripRepository {
  FakeTripRepository({
    this.delay = Duration.zero,
    this.failWith,
    List<Trip>? seed,
  }) {
    for (final t in seed ?? fakeTrips) {
      _trips[t.id] = t;
      _nextId = max(_nextId, int.parse(t.id) + 1);
    }
  }

  final Duration delay;
  ApiException? failWith;
  final Map<String, Trip> _trips = {};
  int _nextId = 1;
  int calls = 0;

  @override
  Future<List<Trip>> getAll() async {
    await _tick();
    return _trips.values.toList();
  }

  @override
  Future<Trip> getById(String id) async {
    await _tick();
    return _trips[id] ?? (throw const NotFoundException());
  }

  @override
  Future<Trip> create(Trip draft) async {
    await _tick();
    final saved = draft.copyWith(id: '${_nextId++}');
    _trips[saved.id] = saved;
    return saved;
  }

  @override
  Future<Trip> update(Trip trip) async {
    await _tick();
    if (!_trips.containsKey(trip.id)) throw const NotFoundException();
    _trips[trip.id] = trip;
    return trip;
  }

  @override
  Future<void> delete(String id) async {
    await _tick();
    if (_trips.remove(id) == null) throw const NotFoundException();
  }

  Future<void> _tick() async {
    calls++;
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (failWith case final e?) throw e;
  }
}

final fakeTrips = [
  Trip(
    id: '1',
    countryCode: 'KAZ',
    countryName: 'Kazakhstan',
    startDate: DateTime(2026, 12, 28),
    endDate: DateTime(2027, 1, 3),
    budget: 300000,
    notes: 'Shymbulak and Kolsai lakes',
  ),
  Trip(
    id: '2',
    countryCode: 'JPN',
    countryName: 'Japan',
    startDate: DateTime(2027, 4, 1),
    endDate: DateTime(2027, 4, 10),
    budget: 1200000,
  ),
  Trip(
    id: '3',
    countryCode: 'GEO',
    countryName: 'Georgia',
    startDate: DateTime(2026, 8, 5),
    endDate: DateTime(2026, 8, 12),
    budget: 450000,
    notes: 'Tbilisi, Kazbegi',
    rating: 5,
  ),
];
