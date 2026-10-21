import 'package:flutter/material.dart';

import '../models/meetup.dart';
import 'empty_state.dart';

class MembersList extends StatelessWidget {
  const MembersList({super.key, required this.meetup, required this.you});

  final Meetup meetup;
  final String you;

  @override
  Widget build(BuildContext context) {
    final members = meetup.members;
    if (members.isEmpty) {
      return const EmptyState(
        icon: Icons.group_off,
        message: 'Nobody has joined yet.\nBe the first!',
      );
    }

    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: members.length,
      itemBuilder: (context, i) {
        final name = members[i];
        final isYou = you.isNotEmpty && name.toLowerCase() == you.toLowerCase();
        return ListTile(
          tileColor: isYou ? colors.primaryContainer : null,
          title: Text(
            isYou ? '$name (You)' : name,
            style: isYou
                ? text.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
                : null,
          ),
        );
      },
    );
  }
}
