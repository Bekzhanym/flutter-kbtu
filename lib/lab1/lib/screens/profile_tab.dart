import 'package:flutter/material.dart';

import '../models/meetup.dart';
import '../models/profile.dart';
import '../utils/keyboard.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({
    super.key,
    required this.profile,
    required this.meetups,
    required this.themeMode,
    required this.onProfileChanged,
    required this.onThemeModeChanged,
  });

  final Profile profile;
  final List<Meetup> meetups;
  final ThemeMode themeMode;
  final ValueChanged<Profile> onProfileChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  static final _groupPattern = RegExp(r'^[A-Z]{2,5}-\d{4}$');

  late final TextEditingController _name;
  late final TextEditingController _group;
  final _groupKey = GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.profile.name);
    _group = TextEditingController(text: widget.profile.group);
  }

  @override
  void didUpdateWidget(ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.profile != oldWidget.profile) {
      _name.text = widget.profile.name;
      _group.text = widget.profile.group;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _group.dispose();
    super.dispose();
  }

  String? _validateGroup(String? v) {
    final group = (v ?? '').trim().toUpperCase();
    if (group.isEmpty || _groupPattern.hasMatch(group)) return null;
    return 'Letters, a dash and four digits, like IT-2301';
  }

  void _saveName(String value) =>
      widget.onProfileChanged(widget.profile.copyWith(name: value.trim()));

  void _saveGroup(String value) {
    final valid = _groupKey.currentState?.validate() ?? false;
    if (!valid) return;
    widget.onProfileChanged(
      widget.profile.copyWith(group: value.trim().toUpperCase()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final profile = widget.profile;
    final lists = widget.meetups.fold(
      0,
      (n, m) => m.contains(profile.name) ? n + 1 : n,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _name,
          decoration: const InputDecoration(
            labelText: 'Name',
            helperText: 'Shown on the lists you join · the keyboard ✓ saves',
            prefixIcon: Icon(Icons.badge_outlined),
          ),
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          onSubmitted: _saveName,
          onTapOutside: hideKeyboard,
        ),
        const SizedBox(height: 16),
        TextFormField(
          key: _groupKey,
          controller: _group,
          decoration: const InputDecoration(
            labelText: 'Group',
            hintText: 'IT-2301',
            prefixIcon: Icon(Icons.groups_outlined),
          ),
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.done,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _validateGroup,
          onFieldSubmitted: _saveGroup,
          onTapOutside: hideKeyboard,
        ),
        const SizedBox(height: 24),
        Card(
          child: ListTile(
            leading: const Icon(Icons.forum),
            title: Text('You are on $lists ${lists == 1 ? 'list' : 'lists'}'),
            subtitle: Text(
              profile.hasName
                  ? 'Saved as ${profile.name}'
                  : 'Set your name to join meetups',
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Theme', style: text.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final mode in ThemeMode.values)
              ChoiceChip(
                label: Text(switch (mode) {
                  ThemeMode.system => 'System',
                  ThemeMode.light => 'Light',
                  ThemeMode.dark => 'Dark',
                }),
                selected: widget.themeMode == mode,
                onSelected: (_) => widget.onThemeModeChanged(mode),
              ),
          ],
        ),
      ],
    );
  }
}
