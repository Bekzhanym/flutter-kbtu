import 'dart:async';

import 'package:flutter/material.dart';

import '../enums/meetup_menu_action.dart';
import '../models/meetup.dart';
import '../routes.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/meetup_about.dart';
import '../widgets/members_list.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.args});

  final DetailArgs args;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Meetup _meetup = widget.args.meetup;
  DateTime _now = DateTime.now();
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => setState(() => _now = DateTime.now()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _name => widget.args.profile.name.trim();

  void _apply(Meetup updated) {
    widget.args.onChanged(updated);
    setState(() => _meetup = updated);
  }

  void _goToProfile() {
    if (mounted) {
      Navigator.of(context).popUntil(ModalRoute.withName(Routes.home));
    }
    widget.args.onShowProfile();
  }

  Future<void> _join() async {
    if (_name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Add your name in the profile first'),
          action: SnackBarAction(label: 'Profile', onPressed: _goToProfile),
        ),
      );
      return;
    }
    final confirmed = await showConfirmDialog(
      context,
      title: 'Join "${_meetup.title}"?',
      message: 'You will be on the list as $_name.',
      confirmLabel: 'Join',
    );
    if (!confirmed || !mounted) return;
    _apply(_meetup.withMember(_name));
  }

  void _leave() => _apply(_meetup.withoutMember(_name));

  Future<void> _edit() async {
    final updated = await Navigator.of(context)
        .pushNamed<Meetup>(Routes.form, arguments: FormArgs(initial: _meetup));
    if (updated == null || !mounted) return;
    _apply(updated);
  }

  Future<void> _delete() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete "${_meetup.title}"?',
      message: 'Everyone on its list loses it too.',
      confirmLabel: 'Delete',
    );
    if (!confirmed || !mounted) return;
    widget.args.onDeleted(_meetup.id);
    Navigator.of(context).pop();
  }

  void _onMenu(MeetupMenuAction action) {
    switch (action) {
      case MeetupMenuAction.edit:
        _edit();
      case MeetupMenuAction.delete:
        _delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final joined = _meetup.contains(_name);

    final (String label, IconData icon, VoidCallback? onPressed) = switch ((
      _meetup.isPast,
      joined,
      _meetup.isFull,
    )) {
      (true, _, _) => ('Ended', Icons.history, null),
      (_, true, _) => ('Leave', Icons.logout, _leave),
      (_, _, true) => ('Full', Icons.block, null),
      _ => ('Join', Icons.how_to_reg, _join),
    };

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_meetup.title, overflow: TextOverflow.ellipsis),
          actions: [
            PopupMenuButton<MeetupMenuAction>(
              onSelected: _onMenu,
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: MeetupMenuAction.edit,
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                  ),
                ),
                PopupMenuItem(
                  value: MeetupMenuAction.delete,
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            tabs: [
              const Tab(text: 'About'),
              Tab(text: 'Members (${_meetup.count})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MeetupAbout(meetup: _meetup, now: _now),
            MembersList(meetup: _meetup, you: _name),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}
