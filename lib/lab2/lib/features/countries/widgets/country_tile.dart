import 'package:flutter/material.dart';
import 'package:trip_planner/core/format/compact_number.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';

class CountryTile extends StatelessWidget {
  const CountryTile({super.key, required this.country, required this.onTap});

  final Country country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(country.flag.label, style: const TextStyle(fontSize: 32)),
      title: Text(country.name.common),
      subtitle: Text('${country.capital} · ${country.region}'),
      trailing: Text(country.population.compact),
      onTap: onTap,
    );
  }
}
