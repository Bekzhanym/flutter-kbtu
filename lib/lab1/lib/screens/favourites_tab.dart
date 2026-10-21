import 'package:flutter/material.dart';

import '../models/meetup.dart';
import '../widgets/empty_state.dart';
import '../widgets/meetup_collection.dart';

class FavouritesTab extends StatelessWidget {
  const FavouritesTab({
    super.key,
    required this.meetups,
    required this.onOpen,
    required this.onToggleFavourite,
    required this.onBrowse,
  });

  final List<Meetup> meetups;
  final ValueChanged<Meetup> onOpen;
  final ValueChanged<Meetup> onToggleFavourite;

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final favourites = sortByDate(meetups.where((m) => m.favourite));

    if (favourites.isEmpty) {
      return EmptyState(
        icon: Icons.star_border,
        message: 'No favourites yet.\nTap ☆ on a meetup to keep it here.',
        actionLabel: 'Browse meetups',
        onAction: onBrowse,
      );
    }
    return MeetupCollection(
      meetups: favourites,
      onOpen: onOpen,
      onToggleFavourite: onToggleFavourite,
    );
  }
}
