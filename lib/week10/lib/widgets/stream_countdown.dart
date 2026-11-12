import 'package:flutter/material.dart';

import '../api/countdown.dart';

class StreamCountdown extends StatefulWidget {
  const StreamCountdown({super.key});

  @override
  State<StreamCountdown> createState() => _StreamCountdownState();
}

class _StreamCountdownState extends State<StreamCountdown> {
  late final Stream<int> _stream = countdown(10);

  @override
  Widget build(BuildContext context) => StreamBuilder<int>(
    stream: _stream,
    builder: (context, snapshot) => Text(
      '${snapshot.data ?? 10}',
      style: Theme.of(context).textTheme.displayLarge,
    ),
  );
}
