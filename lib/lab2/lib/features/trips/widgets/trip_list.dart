import 'package:flutter/material.dart';
import 'package:trip_planner/features/trips/models/trip_model.dart';
import 'package:trip_planner/features/trips/widgets/trip_action.dart';
import 'package:trip_planner/features/trips/widgets/trip_tile.dart';

class TripList extends StatelessWidget {
  const TripList({
    super.key,
    required this.trips,
    required this.onRefresh,
    required this.onAction,
  });

  final List<Trip> trips;
  final Future<void> Function() onRefresh;
  final void Function(Trip trip, TripAction action) onAction;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final danger = Theme.of(context).colorScheme.error;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 88),
        itemCount: trips.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final trip = trips[i];
          return Dismissible(
            key: ValueKey(trip.id),
            direction: DismissDirection.endToStart,
            background: ColoredBox(
              color: danger,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 24),
                  child: Icon(Icons.delete_outline, color: Colors.white),
                ),
              ),
            ),
            confirmDismiss: (_) async {
              onAction(trip, TripAction.delete);
              return false;
            },
            child: TripTile(
              trip: trip,
              today: today,
              onAction: (a) => onAction(trip, a),
            ),
          );
        },
      ),
    );
  }
}
