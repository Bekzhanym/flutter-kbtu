import 'dart:async';

import 'package:flutter/material.dart';

import '../api/countdown.dart';

class ListenCountdown extends StatefulWidget {
  const ListenCountdown({super.key});

  @override
  State<ListenCountdown> createState() => _ListenCountdownState();
}

class _ListenCountdownState extends State<ListenCountdown> {
  int _left = 10;
  late StreamSubscription<int> _sub;

  @override
  void initState() {
    super.initState();
    _sub = countdown(10).listen((i) => setState(() => _left = i));
  }

  @override
  void dispose() {
    unawaited(_sub.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(
    '$_left',
    style: Theme.of(context).textTheme.displayLarge,
  );
}
