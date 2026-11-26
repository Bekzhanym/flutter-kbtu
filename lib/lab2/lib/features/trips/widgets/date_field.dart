import 'package:flutter/material.dart';
import 'package:trip_planner/features/trips/validation/trip_validators.dart';

class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.controller,
    required this.value,
    required this.onTap,
  });

  final String label;
  final TextEditingController controller;
  final DateTime? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      validator: (_) => TripValidators.date(value),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.event),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
