import 'package:flutter/material.dart';

class RatingField extends StatelessWidget {
  const RatingField({super.key, required this.value, required this.onChanged});

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int?>(
      initialValue: value,
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Rating',
        prefixIcon: Icon(Icons.star_outline),
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem(value: null, child: Text('Not rated yet')),
        for (var n = 1; n <= 5; n++)
          DropdownMenuItem(value: n, child: Text('★' * n)),
      ],
    );
  }
}
