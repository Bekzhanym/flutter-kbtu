import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/app.dart';
import 'package:trip_planner/core/api/api_client.dart';
import 'package:trip_planner/core/env.dart';
import 'package:trip_planner/features/countries/providers/countries_provider.dart';
import 'package:trip_planner/features/countries/repository/country_repository.dart';
import 'package:trip_planner/features/countries/repository/fake_country_repository.dart';
import 'package:trip_planner/features/countries/repository/http_country_repository.dart';
import 'package:trip_planner/features/trips/providers/trips_provider.dart';
import 'package:trip_planner/features/trips/repository/fake_trip_repository.dart';
import 'package:trip_planner/features/trips/repository/http_trip_repository.dart';
import 'package:trip_planner/features/trips/repository/trip_repository.dart';

final getIt = GetIt.instance;

const _fakeDelay = Duration(milliseconds: 400);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _register();

  runApp(
    MultiProvider(
      providers: [
        Provider<CountryRepository>.value(value: getIt<CountryRepository>()),
        ChangeNotifierProvider(
          create: (_) => CountriesProvider(getIt<CountryRepository>())..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => TripsProvider(getIt<TripRepository>())..load(),
        ),
      ],
      child: const App(),
    ),
  );
}

void _register() {
  getIt.registerLazySingleton<Client>(Client.new, dispose: (c) => c.close());

  getIt.registerLazySingleton<CountryRepository>(
    () => Env.useFakes
        ? FakeCountryRepository(delay: _fakeDelay)
        : HttpCountryRepository(
            ApiClient(
              getIt<Client>(),
              host: Env.countriesHost,
              basePath: '/countries/v5',
              fixedQuery: {'api-key': Env.countriesApiKey},
            ),
          ),
  );

  getIt.registerLazySingleton<TripRepository>(
    () => Env.useFakes || Env.tripsHost.isEmpty
        ? FakeTripRepository(delay: _fakeDelay)
        : HttpTripRepository(
            ApiClient(
              getIt<Client>(),
              host: Env.tripsHost,
              basePath: Env.tripsBasePath,
            ),
          ),
  );
}
