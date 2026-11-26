import 'package:flutter/foundation.dart';
import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/features/trips/models/trip_model.dart';
import 'package:trip_planner/features/trips/repository/trip_repository.dart';

class TripsProvider extends ChangeNotifier {
  TripsProvider(this._repo);

  final TripRepository _repo;

  List<Trip> _items = const [];
  ApiException? error;
  bool loading = false;
  bool saving = false;

  bool _disposed = false;

  List<Trip> get items =>
      [..._items]..sort((a, b) => a.countryName.compareTo(b.countryName));

  int get count => _items.length;

  Future<void> load() async {
    loading = true;
    error = null;
    _notify();
    try {
      _items = await _repo.getAll();
    } on ApiException catch (e) {
      error = e;
    } finally {
      loading = false;
      _notify();
    }
  }

  Future<Trip> create(Trip draft) => _save(() async {
    final saved = await _repo.create(draft);
    _items = [..._items, saved];
    return saved;
  });

  Future<Trip> update(Trip trip) => _save(() async {
    final saved = await _repo.update(trip);
    _items = [
      for (final t in _items) t.id == saved.id ? saved : t,
    ];
    return saved;
  });

  Future<void> delete(String id) => _save(() async {
    await _repo.delete(id);
    _items = [
      for (final t in _items)
        if (t.id != id) t,
    ];
  });

  Future<T> _save<T>(Future<T> Function() call) async {
    saving = true;
    _notify();
    try {
      return await call();
    } finally {
      saving = false;
      _notify();
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
