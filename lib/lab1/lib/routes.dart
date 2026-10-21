import 'package:flutter/material.dart';

import 'models/meetup.dart';
import 'models/profile.dart';
import 'screens/detail_screen.dart';
import 'screens/meetup_form_screen.dart';
import 'screens/not_found_screen.dart';

abstract final class Routes {
  static const home = '/';
  static const detail = '/meetup';
  static const form = '/meetup/form';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) =>
      switch ((settings.name, settings.arguments)) {
        (Routes.detail, final DetailArgs args) => MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => DetailScreen(args: args),
        ),
        (Routes.form, final FormArgs args) => MaterialPageRoute<Meetup>(
          settings: settings,
          builder: (_) => MeetupFormScreen(initial: args.initial),
        ),
        _ => null,
      };

  static Route<dynamic> onUnknownRoute(RouteSettings settings) =>
      MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => NotFoundScreen(name: settings.name),
      );
}

class DetailArgs {
  const DetailArgs({
    required this.meetup,
    required this.profile,
    required this.onChanged,
    required this.onDeleted,
    required this.onShowProfile,
  });

  final Meetup meetup;
  final Profile profile;
  final ValueChanged<Meetup> onChanged;
  final ValueChanged<String> onDeleted;
  final VoidCallback onShowProfile;
}

class FormArgs {
  const FormArgs({this.initial});

  final Meetup? initial;
}
