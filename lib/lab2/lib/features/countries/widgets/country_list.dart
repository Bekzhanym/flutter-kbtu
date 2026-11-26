import 'package:flutter/material.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';
import 'package:trip_planner/features/countries/widgets/country_card.dart';
import 'package:trip_planner/features/countries/widgets/country_tile.dart';

class CountryList extends StatelessWidget {
  const CountryList({
    super.key,
    required this.countries,
    required this.footer,
    required this.onRefresh,
    required this.onNearEnd,
    required this.onOpen,
  });

  static const double gridBreakpoint = 600;

  final List<Country> countries;
  final Widget footer;
  final Future<void> Function() onRefresh;
  final VoidCallback onNearEnd;
  final ValueChanged<Country> onOpen;

  bool _onScroll(ScrollNotification n) {
    if (n.metrics.extentAfter < 400) onNearEnd();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: LayoutBuilder(
          builder: (context, box) =>
              box.maxWidth >= gridBreakpoint ? _grid() : _list(),
        ),
      ),
    );
  }

  Widget _list() => ListView.separated(
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: countries.length + 1,
    separatorBuilder: (_, _) => const Divider(height: 1),
    itemBuilder: (_, i) => i == countries.length
        ? footer
        : CountryTile(
            country: countries[i],
            onTap: () => onOpen(countries[i]),
          ),
  );

  Widget _grid() => CustomScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.all(12),
        sliver: SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 240,
            childAspectRatio: 1.3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: countries.length,
          itemBuilder: (_, i) => CountryCard(
            country: countries[i],
            onTap: () => onOpen(countries[i]),
          ),
        ),
      ),
      SliverToBoxAdapter(child: footer),
    ],
  );
}
