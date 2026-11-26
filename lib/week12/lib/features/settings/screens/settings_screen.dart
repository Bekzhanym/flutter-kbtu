import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week12/features/auth/providers/auth_provider.dart';
import 'package:week12/features/settings/providers/settings_provider.dart';
import 'package:week12/features/users/providers/users_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final cities = context.watch<UsersProvider>().cities;
    final city = settings.city;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark mode'),
            value: settings.dark,
            onChanged: (v) => context.read<SettingsProvider>().setDark(v),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String?>(
              // A saved city the list does not contain (yet) must not crash
              // the dropdown — show "All cities" until it appears.
              initialValue: cities.contains(city) ? city : null,
              decoration: const InputDecoration(
                labelText: 'City filter',
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('All cities')),
                for (final c in cities)
                  DropdownMenuItem(value: c, child: Text(c)),
              ],
              onChanged: (c) => context.read<SettingsProvider>().setCity(c),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () async {
              final auth = context.read<AuthProvider>();
              Navigator.of(context).popUntil((route) => route.isFirst);
              await auth.logout();
            },
          ),
        ],
      ),
    );
  }
}
