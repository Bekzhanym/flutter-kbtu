import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/core/widgets/empty_view.dart';
import 'package:trip_planner/core/widgets/error_view.dart';
import 'package:trip_planner/core/widgets/loading_view.dart';
import 'package:trip_planner/features/trips/models/trip_model.dart';
import 'package:trip_planner/features/trips/providers/trips_provider.dart';
import 'package:trip_planner/features/trips/widgets/trip_action.dart';
import 'package:trip_planner/features/trips/widgets/trip_list.dart';

class TripsBody extends StatelessWidget {
  const TripsBody({
    super.key,
    required this.onFindCountry,
    required this.onAction,
  });

  final VoidCallback onFindCountry;
  final void Function(Trip trip, TripAction action) onAction;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<TripsProvider>();

    if (p.loading && p.count == 0) {
      return const LoadingView(label: 'Loading your trips…');
    }
    if (p.error case final e?) {
      return ErrorView(
        error: e,
        onRetry: () => context.read<TripsProvider>().load(),
      );
    }
    if (p.count == 0) {
      return EmptyView(
        icon: Icons.luggage_outlined,
        title: 'No trips yet',
        message: 'Find a country in the catalogue and plan your first trip.',
        actionLabel: 'Find a country',
        actionIcon: Icons.travel_explore,
        onAction: onFindCountry,
      );
    }
    return TripList(
      trips: p.items,
      onRefresh: () => context.read<TripsProvider>().load(),
      onAction: onAction,
    );
  }
}
