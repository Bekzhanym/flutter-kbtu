import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:week12/core/utils/open_uri.dart';
import 'package:week12/features/auth/providers/auth_provider.dart';
import 'package:week12/features/users/models/user_model.dart';
import 'package:week12/features/users/widgets/user_section_title.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  Future<void> _open(BuildContext context, Uri uri) async {
    final opened = await openUri(uri);
    if (opened || !context.mounted) return;
    _say(context, 'No app can open this.');
  }

  Future<void> _copyToken(BuildContext context) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;
    await Clipboard.setData(ClipboardData(text: token));
    if (!context.mounted) return;
    _say(context, 'Token copied to clipboard.');
  }

  void _say(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final a = user.address;
    final website = user.website;
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        children: [
          const UserSectionTitle('Account'),
          ListTile(
            leading: const Icon(Icons.tag),
            title: Text('${user.id}'),
            subtitle: const Text('id'),
          ),
          ListTile(
            leading: const Icon(Icons.alternate_email),
            title: Text(user.username),
            subtitle: const Text('username'),
          ),
          if (kDebugMode)
            ListTile(
              leading: const Icon(Icons.key_outlined),
              title: const Text('Copy token to clipboard'),
              subtitle: const Text('debug only'),
              onTap: () => _copyToken(context),
            ),
          const UserSectionTitle('Contact'),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text(user.email),
            subtitle: const Text('email'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () =>
                _open(context, Uri(scheme: 'mailto', path: user.email)),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(user.phone.isEmpty ? '—' : user.phone),
            subtitle: Text('phone · digits: ${user.phoneDigits}'),
            trailing: const Icon(Icons.open_in_new),
            onTap: user.phoneDigits.isEmpty
                ? null
                : () => _open(
                    context,
                    Uri(scheme: 'tel', path: user.phoneDigits),
                  ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(website ?? '—'),
            subtitle: const Text('website'),
            trailing: website == null ? null : const Icon(Icons.open_in_new),
            onTap: website == null
                ? null
                : () => _open(context, Uri.parse('https://$website')),
          ),
          const UserSectionTitle('Address'),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text('${a.street}, ${a.suite}'),
            subtitle: Text('${a.city} ${a.zipcode}'),
          ),
          ListTile(
            leading: const Icon(Icons.place_outlined),
            title: Text('${a.geo.lat}, ${a.geo.lng}'),
            subtitle: const Text('geo (lat, lng)'),
          ),
          const UserSectionTitle('Company'),
          ListTile(
            leading: const Icon(Icons.business),
            title: Text(user.company.name.isEmpty ? '—' : user.company.name),
            subtitle: Text(user.company.catchPhrase),
          ),
        ],
      ),
    );
  }
}
