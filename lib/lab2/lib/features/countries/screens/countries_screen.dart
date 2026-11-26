import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/core/routes/app_routes.dart';
import 'package:trip_planner/features/countries/models/country_model.dart';
import 'package:trip_planner/features/countries/providers/countries_provider.dart';
import 'package:trip_planner/features/countries/widgets/countries_body.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  static const debounce = Duration(milliseconds: 400);

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final _search = TextEditingController();
  Timer? _timer;

  void _onChanged(String text) {
    _timer?.cancel();
    _timer = Timer(CountriesScreen.debounce, () => _run(text));
  }

  void _run(String text) {
    _timer?.cancel();
    unawaited(context.read<CountriesProvider>().search(text));
  }

  void _clear() {
    _search.clear();
    _run('');
  }

  void _open(Country country) {
    Navigator.of(context).pushNamed(AppRoutes.country, arguments: country);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _search,
              onChanged: _onChanged,
              onSubmitted: _run,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search by name',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: ListenableBuilder(
                  listenable: _search,
                  builder: (_, _) => _search.text.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          tooltip: 'Clear',
                          icon: const Icon(Icons.clear),
                          onPressed: _clear,
                        ),
                ),
                filled: true,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
        ),
      ),
      body: CountriesBody(onClear: _clear, onOpen: _open),
    );
  }
}
