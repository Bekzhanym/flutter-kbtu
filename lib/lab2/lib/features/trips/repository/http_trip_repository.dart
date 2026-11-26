import 'package:trip_planner/core/api/api_client.dart';
import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/core/json/json_path_exception.dart';
import 'package:trip_planner/core/json/json_read.dart';
import 'package:trip_planner/features/trips/models/trip_model.dart';
import 'package:trip_planner/features/trips/repository/trip_repository.dart';

class HttpTripRepository implements TripRepository {
  HttpTripRepository(this._api);

  final ApiClient _api;

  static const _path = '/trips';

  @override
  Future<List<Trip>> getAll() async {
    final json = await _api.get(_path);
    return _parse('trips', () {
      if (json is! List) {
        throw JsonPathException('', 'expected a list, got ${json.runtimeType}');
      }
      return [
        for (var i = 0; i < json.length; i++)
          _item(i, () => Trip.fromJson(asObject(json[i]))),
      ];
    });
  }

  @override
  Future<Trip> getById(String id) async {
    final json = await _api.get('$_path/$id');
    return _parse('trips/$id', () => Trip.fromJson(asObject(json)));
  }

  @override
  Future<Trip> create(Trip draft) async {
    final json = await _api.post(_path, draft.toJson());
    return _parse('trips (POST)', () => Trip.fromJson(asObject(json)));
  }

  @override
  Future<Trip> update(Trip trip) async {
    final json = await _api.put('$_path/${trip.id}', trip.toJson());
    return _parse(
      'trips/${trip.id} (PUT)',
      () => Trip.fromJson(asObject(json)),
    );
  }

  @override
  Future<void> delete(String id) => _api.delete('$_path/$id');

  Trip _item(int i, Trip Function() read) {
    try {
      return read();
    } on JsonPathException catch (e) {
      throw e.under('[$i]');
    }
  }

  T _parse<T>(String resource, T Function() parse) {
    try {
      return parse();
    } on JsonPathException catch (e) {
      throw BadResponseException('$resource: $e');
    }
  }
}
