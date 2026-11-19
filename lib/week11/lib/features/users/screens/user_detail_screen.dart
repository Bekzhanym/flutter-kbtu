import 'package:flutter/material.dart';
import 'package:week11/features/users/models/user_model.dart';
import 'package:week11/features/users/widgets/user_section_title.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

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
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text(user.email),
            subtitle: const Text('email'),
          ),
          const UserSectionTitle('Contact'),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(user.phone.isEmpty ? '—' : user.phone),
            subtitle: Text('phone · digits: ${user.phoneDigits}'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(website ?? '—'),
            subtitle: const Text('website'),
            onTap: website == null ? null : () {},
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
