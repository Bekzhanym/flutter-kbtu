import 'package:flutter/material.dart';
import 'package:trip_planner/core/widgets/section_title.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';
import 'package:trip_planner/features/countries/widgets/country_facts.dart';
import 'package:trip_planner/features/countries/widgets/country_header.dart';
import 'package:trip_planner/features/countries/widgets/country_link_tiles.dart';

class CountryDetailView extends StatelessWidget {
  const CountryDetailView({
    super.key,
    required this.country,
    required this.onOpenLink,
    required this.onOpenBorder,
  });

  final Country country;
  final ValueChanged<String> onOpenLink;
  final ValueChanged<String> onOpenBorder;

  @override
  Widget build(BuildContext context) {
    final c = country;
    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        CountryHeader(country: c),
        const SectionTitle('Overview'),
        CountryFacts(country: c),
        const SectionTitle('Currencies'),
        for (final cur in c.currencies)
          ListTile(
            leading: CircleAvatar(child: Text(cur.symbol ?? cur.code[0])),
            title: Text(cur.label),
            subtitle: Text(cur.code),
          ),
        const SectionTitle('Languages'),
        _chips([for (final l in c.languages) Chip(label: Text(l))]),
        if (c.borders.isNotEmpty) ...[
          const SectionTitle('Borders'),
          _chips([
            for (final code in c.borders)
              ActionChip(
                label: Text(code),
                onPressed: () => onOpenBorder(code),
              ),
          ]),
        ],
        const SectionTitle('Links'),
        CountryLinkTiles(links: c.links, onOpen: onOpenLink),
      ],
    );
  }

  Widget _chips(List<Widget> chips) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Wrap(spacing: 8, runSpacing: 8, children: chips),
  );
}
