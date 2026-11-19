import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week11/core/errors/api_exception.dart';
import 'package:week11/core/widgets/state_views.dart';
import 'package:week11/features/users/providers/users_provider.dart';
import 'package:week11/features/users/screens/new_user_screen.dart';
import 'package:week11/features/users/widgets/user_list.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: const _UsersBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const NewUserScreen()),
        ),
        icon: const Icon(Icons.person_add),
        label: const Text('New user'),
      ),
    );
  }
}

class _UsersBody extends StatelessWidget {
  const _UsersBody();

  @override
  Widget build(BuildContext context) {
    final m = context.watch<UsersProvider>();
    if (m.loading && m.items.isEmpty) return const LoadingView();

    return switch (m.error) {
      null => UserList(m.items, onRefresh: m.load),
      NoConnectionException() => Offline(onRetry: m.load),
      NotFoundException() || UnauthorizedException() => const NotAvailable(),
      ServerException(:final status) => ServerError(status, onRetry: m.load),
      BadResponseException() => const GenericError(),
    };
  }
}
