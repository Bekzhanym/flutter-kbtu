import 'package:flutter/material.dart';
import 'package:trip_planner/features/trips/models/trip_status.dart';

class TripStatusChip extends StatelessWidget {
  const TripStatusChip({super.key, required this.status});

  final TripStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg) = switch (status) {
      TripStatus.upcoming => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      TripStatus.ongoing => (
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
      TripStatus.past => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg),
      ),
    );
  }
}
