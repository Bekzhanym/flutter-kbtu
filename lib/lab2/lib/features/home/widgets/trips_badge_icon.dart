import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/features/trips/providers/trips_provider.dart';

class TripsBadgeIcon extends StatelessWidget {
  const TripsBadgeIcon({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final count = context.select<TripsProvider, int>((p) => p.count);
    return Badge(
      isLabelVisible: count > 0,
      label: Text('$count'),
      child: Icon(selected ? Icons.luggage : Icons.luggage_outlined),
    );
  }
}
