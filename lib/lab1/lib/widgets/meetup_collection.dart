import 'package:flutter/material.dart';

import '../models/meetup.dart';
import 'meetup_card.dart';

class MeetupCollection extends StatelessWidget {
  const MeetupCollection({
    super.key,
    required this.meetups,
    required this.onOpen,
    required this.onToggleFavourite,
  });

  final List<Meetup> meetups;
  final ValueChanged<Meetup> onOpen;
  final ValueChanged<Meetup> onToggleFavourite;

  static const _padding = EdgeInsets.fromLTRB(8, 4, 8, 88);

  Widget _card(Meetup m) => MeetupCard(
    meetup: m,
    onTap: () => onOpen(m),
    onToggleFavourite: () => onToggleFavourite(m),
  );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth >= 600) {
        return GridView.builder(
          padding: _padding,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 360,
            mainAxisExtent: 156,
          ),
          itemCount: meetups.length,
          itemBuilder: (context, i) => _card(meetups[i]),
        );
      }
      return ListView.separated(
        padding: _padding,
        itemCount: meetups.length,
        separatorBuilder: (context, i) => const SizedBox(height: 4),
        itemBuilder: (context, i) => _card(meetups[i]),
      );
    },
  );
}
