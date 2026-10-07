import 'package:flutter/material.dart';

class TapCard extends StatefulWidget {
  const TapCard({super.key});

  @override
  State<TapCard> createState() => _TapCardState();
}

class _TapCardState extends State<TapCard> {
  int _taps = 0;

  @override
  void initState() {
    super.initState();
    debugPrint('[TapCard] initState: State created, _taps = $_taps');
  }

  void _increment() {
    setState(() => _taps++);
    debugPrint('[TapCard] onTap: setState -> _taps = $_taps');
  }

  Future<void> _confirmReset() async {
    debugPrint('[TapCard] onLongPress: opening dialog, awaiting result');
    final reset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset the count?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    debugPrint('[TapCard] dialog returned: $reset, mounted = $mounted');
    if (!mounted) return;
    if (reset == true) {
      setState(() => _taps = 0);
      debugPrint('[TapCard] Reset: setState -> _taps = $_taps');
    } else {
      debugPrint('[TapCard] Cancel: _taps unchanged = $_taps');
    }
  }

  @override
  void dispose() {
    debugPrint('[TapCard] dispose: State destroyed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[TapCard] build: drawing _taps = $_taps');
    return Card(
      child: InkWell(
        onTap: _increment,
        onLongPress: _confirmReset,
        child: ListTile(
          title: const Text('Tap me'),
          trailing: Text('$_taps'),
        ),
      ),
    );
  }
}
