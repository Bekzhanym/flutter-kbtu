import 'package:flutter/foundation.dart';
import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';
import 'package:trip_planner/features/countries/repository/country_repository.dart';

class CountryDetailProvider extends ChangeNotifier {
  CountryDetailProvider(this._repo, this.code, {Country? preloaded})
    : country = preloaded;

  final CountryRepository _repo;
  final String code;

  Country? country;
  ApiException? error;
  bool loading = false;

  bool _disposed = false;

  Future<void> loadIfNeeded() async {
    if (country == null) await load();
  }

  Future<void> load() async {
    loading = true;
    error = null;
    _notify();
    try {
      country = await _repo.getByCode(code);
    } on ApiException catch (e) {
      error = e;
    } finally {
      loading = false;
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
