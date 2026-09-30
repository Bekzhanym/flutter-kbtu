import 'dart:async';

import 'package:flutter/material.dart';

class StopwatchCard extends StatefulWidget {
  const StopwatchCard({super.key});

  @override
  State<StopwatchCard> createState() => _StopwatchCardState();
}

class _StopwatchCardState extends State<StopwatchCard> {
  int _seconds = 0;
  Timer? _timer;

  String get _formatted {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void initState() {
    super.initState();
    debugPrint('[Stopwatch] initState: _seconds = $_seconds, _timer = null');
  }

  void _start() {
    if (_timer != null) {
      debugPrint(
        '[Stopwatch] Start: timer already running, not creating a second one',
      );
      return;
    }
    setState(() {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _seconds++);
        debugPrint(
          '[Stopwatch] tick: setState -> _seconds = $_seconds ($_formatted)',
        );
      });
    });
    debugPrint('[Stopwatch] Start: Timer.periodic created');
  }

  void _stop() {
    _timer?.cancel();
    setState(() => _timer = null);
    debugPrint('[Stopwatch] Stop: timer.cancel(), _timer = null');
  }

  void _reset() {
    _stop();
    setState(() => _seconds = 0);
    debugPrint('[Stopwatch] Reset: _seconds = 0');
  }

  @override
  void dispose() {
    debugPrint(
      '[Stopwatch] dispose: cancelling timer (running = ${_timer != null})',
    );
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final running = _timer != null;
    debugPrint('[Stopwatch] build: $_formatted, running = $running');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(_formatted, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: running ? null : _start,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: running ? _stop : null,
                  child: const Text('Stop'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: _reset, child: const Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
