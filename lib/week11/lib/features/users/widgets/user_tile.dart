import 'package:flutter/material.dart';
import 'package:week11/features/users/models/user_model.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user, required this.onTap});

  final User user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final city = user.address.city;
    return ListTile(
      leading: CircleAvatar(child: Text(user.name.characters.first)),
      title: Text(user.name),
      subtitle: Text(city.isEmpty ? user.email : '${user.email} · $city'),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
