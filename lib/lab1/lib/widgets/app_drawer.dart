import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.onAbout, required this.onReset});

  final VoidCallback onAbout;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Language Exchange KBTU',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          onTap: onAbout,
        ),
        ListTile(
          leading: const Icon(Icons.restart_alt),
          title: const Text('Reset data'),
          onTap: onReset,
        ),
      ],
    ),
  );
}
