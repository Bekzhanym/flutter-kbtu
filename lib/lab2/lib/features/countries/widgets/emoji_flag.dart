import 'package:flutter/material.dart';

class EmojiFlag extends StatelessWidget {
  const EmojiFlag(this.emoji, {super.key});

  final String emoji;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: Center(child: Text(emoji, style: const TextStyle(fontSize: 72))),
  );
}
