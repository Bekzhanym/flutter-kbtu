import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/core/api/api_exception.dart';
import 'package:trip_planner/core/api/api_exception_message.dart';
import 'package:trip_planner/core/routes/app_routes.dart';
import 'package:trip_planner/core/widgets/confirm_dialog.dart';
import 'package:trip_planner/features/trips/models/trip_model.dart';
import 'package:trip_planner/features/trips/providers/trips_provider.dart';
import 'package:trip_planner/features/trips/widgets/trip_action.dart';
import 'package:trip_planner/features/trips/widgets/trips_body.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key, required this.onFindCountry});

  final VoidCallback onFindCountry;

  Future<void> _onAction(BuildContext context, Trip trip, TripAction a) =>
      switch (a) {
        TripAction.edit => _edit(context, trip),
        TripAction.delete => _delete(context, trip),
      };

  Future<void> _edit(BuildContext context, Trip trip) async {
    final saved = await Navigator.of(
      context,
    ).pushNamed<Trip>(AppRoutes.tripForm, arguments: trip);
    if (saved == null || !context.mounted) return;
    _say(context, 'Trip to ${saved.countryName} saved.');
  }

  Future<void> _delete(BuildContext context, Trip trip) async {
    final yes = await showConfirmDialog(
      context,
      title: 'Delete this trip?',
      message: '${trip.countryName} will be removed from your trips.',
      confirmLabel: 'Delete',
    );
    if (!yes || !context.mounted) return;
    try {
      await context.read<TripsProvider>().delete(trip.id);
      if (!context.mounted) return;
      _say(context, 'Trip to ${trip.countryName} deleted.');
    } on ApiException catch (e) {
      if (!context.mounted) return;
      _say(context, 'Not deleted. ${e.message}');
    }
  }

  void _say(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My trips')),
      body: TripsBody(
        onFindCountry: onFindCountry,
        onAction: (trip, a) => _onAction(context, trip, a),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onFindCountry,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Plan a trip'),
      ),
    );
  }
}
