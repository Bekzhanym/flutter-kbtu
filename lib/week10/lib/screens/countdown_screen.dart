import 'package:flutter/material.dart';

import '../widgets/listen_countdown.dart';
import '../widgets/stream_countdown.dart';

enum _Version { a, b }

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  _Version _version = _Version.a;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Countdown')),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SegmentedButton<_Version>(
            segments: const [
              ButtonSegment(
                value: _Version.a,
                label: Text('A · StreamBuilder'),
              ),
              ButtonSegment(value: _Version.b, label: Text('B · listen')),
            ],
            selected: {_version},
            onSelectionChanged: (s) => setState(() => _version = s.first),
          ),
        ),
        Expanded(
          child: Center(
            child: switch (_version) {
              _Version.a => const StreamCountdown(),
              _Version.b => const ListenCountdown(),
            },
          ),
        ),
      ],
    ),
  );
}
