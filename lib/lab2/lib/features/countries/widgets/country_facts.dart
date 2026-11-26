import 'package:flutter/material.dart';
import 'package:trip_planner/core/format/compact_number.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';

class CountryFacts extends StatelessWidget {
  const CountryFacts({super.key, required this.country});

  final Country country;

  @override
  Widget build(BuildContext context) {
    final c = country;
    final density = c.density;
    return Column(
      children: [
        _fact(Icons.location_city, c.capitals.join(', '), 'Capital'),
        _fact(
          Icons.public,
          [c.region, ?c.subregion].join(' · '),
          'Region',
        ),
        _fact(Icons.groups_outlined, c.population.grouped, 'Population'),
        _fact(Icons.square_foot, '${c.areaKm2.grouped} km²', 'Area'),
        if (density != null)
          _fact(
            Icons.density_medium,
            '${density.toStringAsFixed(1)} people / km²',
            'Density',
          ),
        _fact(Icons.schedule, c.timezones.join(', '), 'Time zones'),
      ],
    );
  }

  Widget _fact(IconData icon, String value, String label) => ListTile(
    leading: Icon(icon),
    title: Text(value.isEmpty ? '—' : value),
    subtitle: Text(label),
  );
}
