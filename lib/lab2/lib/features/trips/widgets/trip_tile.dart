import 'package:flutter/material.dart';
import 'package:trip_planner/core/format/compact_number.dart';
import 'package:trip_planner/core/format/day_format.dart';
import 'package:trip_planner/features/trips/models/trip_model.dart';
import 'package:trip_planner/features/trips/widgets/trip_action.dart';
import 'package:trip_planner/features/trips/widgets/trip_status_chip.dart';

class TripTile extends StatelessWidget {
  const TripTile({
    super.key,
    required this.trip,
    required this.today,
    required this.onAction,
  });

  final Trip trip;
  final DateTime today;
  final ValueChanged<TripAction> onAction;

  @override
  Widget build(BuildContext context) {
    final t = trip;
    final rating = t.rating;
    return ListTile(
      leading: CircleAvatar(child: Text(t.countryCode)),
      title: Row(
        children: [
          Flexible(child: Text(t.countryName, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 8),
          TripStatusChip(status: t.statusOn(today)),
        ],
      ),
      subtitle: Text(
        '${dayRange(t.startDate, t.endDate)} · ${t.days} d · '
        '${t.budget.grouped}${rating == null ? '' : ' · ${'★' * rating}'}',
      ),
      onTap: () => onAction(TripAction.edit),
      trailing: PopupMenuButton<TripAction>(
        tooltip: 'Actions',
        onSelected: onAction,
        itemBuilder: (_) => const [
          PopupMenuItem(value: TripAction.edit, child: Text('Edit')),
          PopupMenuItem(value: TripAction.delete, child: Text('Delete')),
        ],
      ),
    );
  }
}
