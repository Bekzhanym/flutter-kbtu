import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';
import 'package:trip_planner/features/countries/providers/country_detail_provider.dart';
import 'package:trip_planner/features/countries/repository/country_repository.dart';
import 'package:trip_planner/features/countries/widgets/country_detail_page.dart';

class CountryDetailScreen extends StatelessWidget {
  const CountryDetailScreen({super.key, required this.code, this.preloaded});

  final String code;
  final Country? preloaded;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CountryDetailProvider(
        context.read<CountryRepository>(),
        code,
        preloaded: preloaded,
      )..loadIfNeeded(),
      child: const CountryDetailPage(),
    );
  }
}
