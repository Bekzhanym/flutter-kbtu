import 'package:flutter/material.dart';
import 'package:trip_planner/core/format/compact_number.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';

class CountryCard extends StatelessWidget {
  const CountryCard({super.key, required this.country, required this.onTap});

  final Country country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(country.flag.label, style: const TextStyle(fontSize: 40)),
              const Spacer(),
              Text(
                country.name.common,
                style: text.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${country.capital} · ${country.population.compact}',
                style: text.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
