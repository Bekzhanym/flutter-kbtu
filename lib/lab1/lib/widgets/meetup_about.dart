import 'package:flutter/material.dart';

import '../models/countdown.dart';
import '../models/meetup.dart';
import '../utils/format.dart';

class MeetupAbout extends StatelessWidget {
  const MeetupAbout({super.key, required this.meetup, required this.now});

  final Meetup meetup;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final (:taken, :free) = meetup.places;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ListTile(
          leading: const Icon(Icons.translate),
          title: Text(meetup.language.label),
          subtitle: const Text('Language'),
        ),
        ListTile(
          leading: const Icon(Icons.event),
          title: Text(formatDate(meetup.startsAt)),
          subtitle: Text('Until ${formatTime(meetup.endsAt)}'),
        ),
        ListTile(
          leading: const Icon(Icons.hourglass_top),
          title: Text(Countdown.of(meetup, now).label),
          subtitle: const Text('Status'),
        ),
        ListTile(
          leading: Icon(meetup.online ? Icons.videocam : Icons.place),
          title: Text(meetup.place),
          subtitle: Text(meetup.online ? 'Online · meeting link' : 'Room'),
        ),
        ListTile(
          leading: const Icon(Icons.groups),
          title: Text('$taken of ${meetup.capacity} places taken'),
          subtitle: Text(free == 0 ? 'No places left' : '$free left'),
        ),
        if (meetup.notes case final notes?)
          ListTile(
            leading: const Icon(Icons.notes),
            title: Text(notes),
            subtitle: const Text('About this meetup'),
          ),
      ],
    );
  }
}
