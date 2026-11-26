import 'package:flutter/material.dart';
import 'package:trip_planner/core/routes/app_routes.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';
import 'package:trip_planner/features/countries/screens/country_detail_screen.dart';
import 'package:trip_planner/features/home/screens/home_shell.dart';
import 'package:trip_planner/features/trips/models/trip_model.dart';
import 'package:trip_planner/features/trips/screens/trip_form_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  static const _seed = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: _seed),
      darkTheme: ThemeData(colorSchemeSeed: _seed, brightness: Brightness.dark),
      initialRoute: AppRoutes.home,
      onGenerateRoute: onGenerateRoute,
    );
  }

  static Route<Object?>? onGenerateRoute(RouteSettings s) =>
      switch ((s.name, s.arguments)) {
        (AppRoutes.home, _) => _page<void>(s, const HomeShell()),
        (AppRoutes.country, final Country c) => _page<void>(
          s,
          CountryDetailScreen(code: c.alpha3, preloaded: c),
        ),
        (AppRoutes.country, final String code) => _page<void>(
          s,
          CountryDetailScreen(code: code),
        ),
        (AppRoutes.tripForm, final Trip t) => _page<Trip>(
          s,
          TripFormScreen(
            initial: t,
            countryCode: t.countryCode,
            countryName: t.countryName,
          ),
        ),
        (AppRoutes.tripForm, final Country c) => _page<Trip>(
          s,
          TripFormScreen(countryCode: c.alpha3, countryName: c.name.common),
        ),
        _ => null,
      };

  static MaterialPageRoute<T> _page<T>(RouteSettings s, Widget page) =>
      MaterialPageRoute<T>(settings: s, builder: (_) => page);
}
