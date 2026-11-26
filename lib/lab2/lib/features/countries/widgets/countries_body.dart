import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/core/widgets/empty_view.dart';
import 'package:trip_planner/core/widgets/error_view.dart';
import 'package:trip_planner/core/widgets/load_more_footer.dart';
import 'package:trip_planner/core/widgets/loading_view.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';
import 'package:trip_planner/features/countries/providers/countries_provider.dart';
import 'package:trip_planner/features/countries/widgets/country_list.dart';

class CountriesBody extends StatelessWidget {
  const CountriesBody({super.key, required this.onClear, required this.onOpen});

  final VoidCallback onClear;
  final ValueChanged<Country> onOpen;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CountriesProvider>();

    if (p.loading && p.items.isEmpty) {
      return const LoadingView(label: 'Loading countries…');
    }
    if (p.error case final e?) {
      return ErrorView(
        error: e,
        onRetry: () => context.read<CountriesProvider>().load(),
      );
    }
    if (p.items.isEmpty) {
      return EmptyView(
        icon: Icons.travel_explore,
        title: 'Nothing found',
        message: 'No country name contains "${p.query}".',
        actionLabel: 'Show all countries',
        actionIcon: Icons.clear,
        onAction: onClear,
      );
    }
    return CountryList(
      countries: p.items,
      onRefresh: () => context.read<CountriesProvider>().load(),
      onNearEnd: () => context.read<CountriesProvider>().loadMore(),
      onOpen: onOpen,
      footer: LoadMoreFooter(
        loading: p.loadingMore,
        error: p.moreError,
        onRetry: () => context.read<CountriesProvider>().loadMore(),
      ),
    );
  }
}
