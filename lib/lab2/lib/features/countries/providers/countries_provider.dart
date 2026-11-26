import 'package:flutter/foundation.dart';
import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';
import 'package:trip_planner/features/countries/repository/country_repository.dart';

class CountriesProvider extends ChangeNotifier {
  CountriesProvider(this._repo);

  final CountryRepository _repo;

  List<Country> items = const [];
  ApiException? error;
  ApiException? moreError;
  bool loading = false;
  bool loadingMore = false;
  bool hasMore = false;
  bool fromCache = false;
  String query = '';

  int _generation = 0;
  bool _disposed = false;

  Future<void> search(String q) {
    query = q.trim();
    return load();
  }

  Future<void> load() async {
    final gen = ++_generation;
    loading = true;
    error = null;
    moreError = null;
    _notify();
    try {
      final page = await _repo.search(query: query);
      if (gen != _generation) return;
      items = page.items;
      hasMore = page.hasMore;
      fromCache = page.fromCache;
    } on ApiException catch (e) {
      if (gen != _generation) return;
      error = e;
    } finally {
      if (gen == _generation) {
        loading = false;
        _notify();
      }
    }
  }

  Future<void> loadMore() async {
    if (loading || loadingMore || !hasMore) return;
    final gen = _generation;
    loadingMore = true;
    moreError = null;
    _notify();
    try {
      final page = await _repo.search(query: query, offset: items.length);
      if (gen != _generation) return;
      items = [...items, ...page.items];
      hasMore = page.hasMore;
    } on ApiException catch (e) {
      if (gen != _generation) return;
      moreError = e;
    } finally {
      loadingMore = false;
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
