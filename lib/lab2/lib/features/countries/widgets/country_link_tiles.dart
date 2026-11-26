import 'package:flutter/material.dart';
import 'package:trip_planner/features/countries/models/country_links_model.dart';

class CountryLinkTiles extends StatelessWidget {
  const CountryLinkTiles({
    super.key,
    required this.links,
    required this.onOpen,
  });

  final CountryLinks links;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final items = [
      if (links.wikipedia case final url?) (Icons.menu_book, 'Wikipedia', url),
      if (links.googleMaps case final url?) (Icons.map_outlined, 'Map', url),
      if (links.official case final url?)
        (Icons.language, 'Official site', url),
    ];
    if (items.isEmpty) {
      return const ListTile(title: Text('No links for this country.'));
    }
    return Column(
      children: [
        for (final (icon, label, url) in items)
          ListTile(
            leading: Icon(icon),
            title: Text(label),
            subtitle: Text(url, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => onOpen(url),
          ),
      ],
    );
  }
}
