import 'package:flutter/material.dart';

import '../models/meetup.dart';
import '../utils/format.dart';
import 'tag_label.dart';

class MeetupCard extends StatelessWidget {
  const MeetupCard({
    super.key,
    required this.meetup,
    required this.onTap,
    required this.onToggleFavourite,
  });

  final Meetup meetup;
  final VoidCallback onTap;
  final VoidCallback onToggleFavourite;

  String? get _badge {
    final (taken: _, :free) = meetup.places;
    if (free == 0) return 'FULL';
    if (free <= 5) return '$free left';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final when = formatDate(meetup.startsAt);
    final secondary = text.bodySmall?.copyWith(color: colors.onSurfaceVariant);
    final language = meetup.language;
    final badge = _badge;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        TagLabel(
                          text: language.label,
                          background: language.colorIn(colors),
                          foreground: language.onColorIn(colors),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 6),
                          TagLabel(
                            text: badge,
                            background: meetup.isFull
                                ? colors.error
                                : colors.inverseSurface,
                            foreground: meetup.isFull
                                ? colors.onError
                                : colors.onInverseSurface,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      meetup.title,
                      style: text.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meetup.isPast ? '$when · ended' : when,
                      style: secondary,
                    ),
                    Text(
                      meetup.online ? 'Online' : meetup.place,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: secondary,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onToggleFavourite,
                tooltip: meetup.favourite
                    ? 'Remove from favourites'
                    : 'Add to favourites',
                icon: Icon(
                  meetup.favourite ? Icons.star : Icons.star_border,
                  color: meetup.favourite ? colors.primary : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
