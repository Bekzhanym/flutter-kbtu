import 'package:trip_planner/features/trips/models/trip_model.dart';

abstract interface class TripRepository {
  Future<List<Trip>> getAll();

  Future<Trip> getById(String id);

  Future<Trip> create(Trip draft);

  Future<Trip> update(Trip trip);

  Future<void> delete(String id);
}
