import 'package:flutter/material.dart';
import 'package:week12/features/users/models/user_model.dart';
import 'package:week12/features/users/screens/user_detail_screen.dart';
import 'package:week12/features/users/widgets/user_tile.dart';

class UserList extends StatelessWidget {
  const UserList(this.users, {super.key, required this.onRefresh});

  final List<User> users;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 88),
        itemCount: users.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, i) => UserTile(
          user: users[i],
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => UserDetailScreen(user: users[i]),
            ),
          ),
        ),
      ),
    );
  }
}
