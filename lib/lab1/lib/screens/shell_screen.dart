import 'package:flutter/material.dart';

import '../models/meetup.dart';
import '../models/profile.dart';
import '../models/seed.dart';
import '../routes.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_navigation_bar.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/top_message.dart';
import 'favourites_tab.dart';
import 'meetups_tab.dart';
import 'profile_tab.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  static const _profileTab = 2;

  List<Meetup> _meetups = buildSeed(DateTime.now());
  Profile _profile = const Profile.empty();
  int _tab = 0;

  void _selectTab(int index) => setState(() => _tab = index);

  void _replace(Meetup updated) => setState(
    () =>
        _meetups = [for (final m in _meetups) m.id == updated.id ? updated : m],
  );

  void _delete(String id) =>
      setState(() => _meetups = _meetups.where((m) => m.id != id).toList());

  void _toggleFavourite(Meetup m) {
    final added = !m.favourite;
    _replace(m.copyWith(favourite: added));
    final colors = Theme.of(context).colorScheme;
    showTopMessage(
      context,
      text: added ? 'Added to favourites' : 'Removed from favourites',
      background: added ? colors.primary : colors.inverseSurface,
      foreground: added ? colors.onPrimary : colors.onInverseSurface,
    );
  }

  void _setProfile(Profile profile) => setState(() => _profile = profile);

  void _open(Meetup meetup) => Navigator.of(context).pushNamed(
    Routes.detail,
    arguments: DetailArgs(
      meetup: meetup,
      profile: _profile,
      onChanged: _replace,
      onDeleted: _delete,
      onShowProfile: () => _selectTab(_profileTab),
    ),
  );

  Future<void> _add() async {
    final created = await Navigator.of(context)
        .pushNamed<Meetup>(Routes.form, arguments: const FormArgs());
    if (created == null || !mounted) return;
    setState(() => _meetups = [..._meetups, created]);
  }

  void _about() {
    Navigator.of(context).pop();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.forum),
        title: const Text('Language Exchange KBTU'),
        content: const Text(
          'Find a speaking club, join it, practise. Everything lives in '
          'memory: Reset data brings back the twelve original meetups.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _reset() async {
    Navigator.of(context).pop();
    final confirmed = await showConfirmDialog(
      context,
      title: 'Reset data?',
      message:
          'All meetups go back to the original twelve and your profile is '
          'cleared.',
      confirmLabel: 'Reset',
    );
    if (!confirmed || !mounted) return;
    final seed = buildSeed(DateTime.now());
    setState(() {
      _meetups = seed;
      _profile = const Profile.empty();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(switch (_tab) {
        0 => 'Language Exchange',
        1 => 'Favourites',
        _ => 'Profile',
      }),
    ),
    drawer: AppDrawer(onAbout: _about, onReset: _reset),
    body: IndexedStack(
      index: _tab,
      children: [
        MeetupsTab(
          meetups: _meetups,
          onOpen: _open,
          onToggleFavourite: _toggleFavourite,
        ),
        FavouritesTab(
          meetups: _meetups,
          onOpen: _open,
          onToggleFavourite: _toggleFavourite,
          onBrowse: () => _selectTab(0),
        ),
        ProfileTab(
          profile: _profile,
          meetups: _meetups,
          themeMode: widget.themeMode,
          onProfileChanged: _setProfile,
          onThemeModeChanged: widget.onThemeModeChanged,
        ),
      ],
    ),
    floatingActionButton: _tab == 0
        ? FloatingActionButton(
            onPressed: _add,
            tooltip: 'New meetup',
            child: const Icon(Icons.add),
          )
        : null,
    bottomNavigationBar: AppNavigationBar(
      selectedIndex: _tab,
      onDestinationSelected: _selectTab,
    ),
  );
}
