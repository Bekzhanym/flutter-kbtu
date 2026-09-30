import 'package:flutter/material.dart';

class TwoWayCounter extends StatefulWidget {
  const TwoWayCounter({super.key});

  @override
  State<TwoWayCounter> createState() => _TwoWayCounterState();
}

class _TwoWayCounterState extends State<TwoWayCounter> {
  int _count = 0;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    debugPrint(
      '[TwoWayCounter] initState: _count = $_count, _saving = $_saving',
    );
  }

  void _decrement() {
    setState(() => _count--);
    debugPrint('[TwoWayCounter] −: setState -> _count = $_count');
    if (_count == 0) {
      debugPrint(
        '[TwoWayCounter] _count = 0 -> − button gets onPressed: null (disabled)',
      );
    }
  }

  void _increment() {
    setState(() => _count++);
    debugPrint('[TwoWayCounter] +: setState -> _count = $_count');
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    debugPrint(
      '[TwoWayCounter] Save: setState -> _saving = true (button disabled)',
    );
    debugPrint(
      '[TwoWayCounter] Save: awaiting 2 seconds (outside setState)...',
    );
    await Future.delayed(const Duration(seconds: 2));
    debugPrint('[TwoWayCounter] Save: await finished, mounted = $mounted');
    if (!mounted) return;
    setState(() => _saving = false);
    debugPrint(
      '[TwoWayCounter] Save: setState -> _saving = false, showing SnackBar',
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saved')));
  }

  @override
  void dispose() {
    debugPrint('[TwoWayCounter] dispose: State destroyed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[TwoWayCounter] build: _count = $_count, _saving = $_saving');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: _count == 0 ? null : _decrement,
              child: const Text('−'),
            ),
            const SizedBox(width: 16),
            Text('$_count', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(width: 16),
            FilledButton(onPressed: _increment, child: const Text('+')),
          ],
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
