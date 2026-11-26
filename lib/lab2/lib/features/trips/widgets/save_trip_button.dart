import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/features/trips/providers/trips_provider.dart';

class SaveTripButton extends StatelessWidget {
  const SaveTripButton({super.key, required this.label, required this.onSave});

  final String label;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final saving = context.select<TripsProvider, bool>((p) => p.saving);
    return FilledButton.icon(
      onPressed: saving ? null : onSave,
      icon: saving
          ? const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.check),
      label: Text(label),
    );
  }
}
