class Env {
  Env._();

  static const String name = String.fromEnvironment('ENV', defaultValue: 'dev');

  static const bool useFakes = bool.fromEnvironment('USE_FAKES');

  static const String countriesHost = String.fromEnvironment(
    'COUNTRIES_HOST',
    defaultValue: 'api.restcountries.com',
  );
  static const String countriesApiKey = String.fromEnvironment(
    'COUNTRIES_API_KEY',
  );

  static const String tripsHost = String.fromEnvironment('TRIPS_HOST');
  static const String tripsBasePath = String.fromEnvironment(
    'TRIPS_BASE_PATH',
  );
}
