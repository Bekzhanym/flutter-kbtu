import 'package:flutter/material.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';
import 'package:trip_planner/features/countries/widgets/emoji_flag.dart';

class CountryHeader extends StatelessWidget {
  const CountryHeader({super.key, required this.country});

  final Country country;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final placeholder = EmojiFlag(country.flag.label);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Image.network(
                country.flag.pngUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => placeholder,
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : placeholder,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(country.name.common, style: text.headlineSmall),
          if (country.name.official != country.name.common)
            Text(country.name.official, style: text.bodyMedium),
        ],
      ),
    );
  }
}
