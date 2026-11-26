import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week12/core/errors/api_exception.dart';
import 'package:week12/core/widgets/state_views.dart';
import 'package:week12/features/profile/screens/profile_screen.dart';
import 'package:week12/features/settings/providers/settings_provider.dart';
import 'package:week12/features/settings/screens/settings_screen.dart';
import 'package:week12/features/users/providers/users_provider.dart';
import 'package:week12/features/users/screens/new_user_screen.dart';
import 'package:week12/features/users/widgets/stale_banner.dart';
import 'package:week12/features/users/widgets/user_list.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final city = context.watch<SettingsProvider>().city;
    return Scaffold(
      appBar: AppBar(
        title: Text(city == null ? 'Users' : 'Users · $city'),
        actions: [
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
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
    final city = context.watch<SettingsProvider>().city;
    if (m.loading && m.items.isEmpty) return const LoadingView();

    return switch (m.error) {
      null => Column(
        children: [
          if (m.fromCache) StaleBanner(onRetry: m.load),
          Expanded(child: UserList(m.inCity(city), onRefresh: m.load)),
        ],
      ),
      NoConnectionException() => Offline(onRetry: m.load),
      NotFoundException() || UnauthorizedException() => const NotAvailable(),
      ServerException(:final status) => ServerError(status, onRetry: m.load),
      BadResponseException() => const GenericError(),
    };
  }
}
