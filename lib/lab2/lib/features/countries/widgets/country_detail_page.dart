import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/core/launch/open_link.dart';
import 'package:trip_planner/core/routes/app_routes.dart';
import 'package:trip_planner/core/widgets/error_view.dart';
import 'package:trip_planner/core/widgets/loading_view.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';
import 'package:trip_planner/features/countries/providers/country_detail_provider.dart';
import 'package:trip_planner/features/countries/widgets/country_detail_view.dart';
import 'package:trip_planner/features/trips/models/trip_model.dart';

class CountryDetailPage extends StatelessWidget {
  const CountryDetailPage({super.key});

  Future<void> _openLink(BuildContext context, String url) async {
    final opened = await openLink(url);
    if (opened || !context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('No app can open this link.')));
  }

  void _openBorder(BuildContext context, String code) {
    Navigator.of(context).pushNamed(AppRoutes.country, arguments: code);
  }

  Future<void> _plan(BuildContext context, Country country) async {
    final saved = await Navigator.of(
      context,
    ).pushNamed<Trip>(AppRoutes.tripForm, arguments: country);
    if (saved == null || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Trip to ${saved.countryName} added to My trips.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CountryDetailProvider>();
    final country = p.country;
    return Scaffold(
      appBar: AppBar(title: Text(country?.name.common ?? p.code)),
      body: switch ((country, p.error)) {
        (final c?, _) => CountryDetailView(
          country: c,
          onOpenLink: (url) => _openLink(context, url),
          onOpenBorder: (code) => _openBorder(context, code),
        ),
        (null, final e?) => ErrorView(
          error: e,
          onRetry: () => context.read<CountryDetailProvider>().load(),
        ),
        (null, null) => const LoadingView(label: 'Loading country…'),
      },
      floatingActionButton: country == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _plan(context, country),
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Plan a trip'),
            ),
    );
  }
}
