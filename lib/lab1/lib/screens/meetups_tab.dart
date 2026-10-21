import 'package:flutter/material.dart';

import '../enums/language.dart';
import '../models/meetup.dart';
import '../utils/keyboard.dart';
import '../widgets/empty_state.dart';
import '../widgets/meetup_collection.dart';

class MeetupsTab extends StatefulWidget {
  const MeetupsTab({
    super.key,
    required this.meetups,
    required this.onOpen,
    required this.onToggleFavourite,
  });

  final List<Meetup> meetups;
  final ValueChanged<Meetup> onOpen;
  final ValueChanged<Meetup> onToggleFavourite;

  @override
  State<MeetupsTab> createState() => _MeetupsTabState();
}

class _MeetupsTabState extends State<MeetupsTab> {
  final _search = TextEditingController();
  Language? _language;
  bool _showPast = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clearSearch() => setState(_search.clear);

  bool _matches(Meetup m, String query) =>
      (_showPast || !m.isPast) &&
      (_language == null || m.language == _language) &&
      m.title.toLowerCase().contains(query);

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final visible = sortByDate(widget.meetups.where((m) => _matches(m, query)));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            onTapOutside: hideKeyboard,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search meetups',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear',
                      icon: const Icon(Icons.close),
                      onPressed: _clearSearch,
                    ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Past'),
                selected: _showPast,
                onSelected: (v) => setState(() => _showPast = v),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('All'),
                selected: _language == null,
                onSelected: (_) => setState(() => _language = null),
              ),
              for (final l in Language.values) ...[
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text(l.label),
                  selected: _language == l,
                  onSelected: (_) => setState(() => _language = l),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: visible.isEmpty
              ? EmptyState(
                  icon: Icons.search_off,
                  message: 'No meetups match',
                  actionLabel: query.isEmpty ? null : 'Clear search',
                  onAction: _clearSearch,
                )
              : MeetupCollection(
                  meetups: visible,
                  onOpen: widget.onOpen,
                  onToggleFavourite: widget.onToggleFavourite,
                ),
        ),
      ],
    );
  }
}
